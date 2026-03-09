//
//  MarkdownRenderer.swift
//  iOSMarkdownEditor
//
//  Created by 李卓非 on 9/3/2026.
//

import Foundation

enum MarkdownRenderer {
    static func makeHTML(title: String, markdown: String) -> String {
        let body = renderMarkdown(markdown)

        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <script>
                window.MathJax = {
                    tex: {
                        inlineMath: [['$', '$']],
                        displayMath: [['$$', '$$']]
                    },
                    svg: {
                        fontCache: 'global'
                    }
                };
            </script>
            <script
                id="MathJax-script"
                async
                src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js">
            </script>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                    padding: 16px;
                    line-height: 1.7;
                    font-size: 17px;
                    color: #111111;
                    background-color: #ffffff;
                    word-wrap: break-word;
                }

                h1, h2, h3 {
                    line-height: 1.25;
                    margin-top: 1.2em;
                    margin-bottom: 0.6em;
                }

                p {
                    margin: 0.8em 0;
                }

                ul, ol {
                    padding-left: 1.4em;
                    margin: 0.8em 0;
                }

                blockquote {
                    border-left: 4px solid #d0d0d0;
                    padding-left: 12px;
                    color: #555555;
                    margin: 1em 0;
                }

                pre {
                    background: #f4f4f4;
                    padding: 12px;
                    border-radius: 10px;
                    overflow-x: auto;
                }

                code {
                    background: #f4f4f4;
                    padding: 2px 6px;
                    border-radius: 6px;
                    font-family: SFMono-Regular, Menlo, monospace;
                }

                pre code {
                    background: transparent;
                    padding: 0;
                }

                a {
                    color: #0a84ff;
                    text-decoration: none;
                }
            </style>
        </head>
        <body>
            <h2>\(escapeHTML(title))</h2>
            \(body)
        </body>
        </html>
        """
    }

    private static func renderMarkdown(_ markdown: String) -> String {
        let lines = markdown.components(separatedBy: .newlines)
        var html: [String] = []
        var inCodeBlock = false
        var codeBuffer: [String] = []
        var inUnorderedList = false
        var inOrderedList = false

        func closeListsIfNeeded() {
            if inUnorderedList {
                html.append("</ul>")
                inUnorderedList = false
            }
            if inOrderedList {
                html.append("</ol>")
                inOrderedList = false
            }
        }

        for rawLine in lines {
            let line = rawLine.trimmingCharacters(in: .whitespaces)

            if line.hasPrefix("```") {
                closeListsIfNeeded()

                if inCodeBlock {
                    let code = codeBuffer.joined(separator: "\n")
                    html.append("<pre><code>\(escapeHTML(code))</code></pre>")
                    codeBuffer.removeAll()
                    inCodeBlock = false
                } else {
                    inCodeBlock = true
                }
                continue
            }

            if inCodeBlock {
                codeBuffer.append(rawLine)
                continue
            }

            if line.isEmpty {
                closeListsIfNeeded()
                continue
            }

            if line.hasPrefix("# ") {
                closeListsIfNeeded()
                html.append("<h1>\(renderInline(String(line.dropFirst(2))))</h1>")
                continue
            }

            if line.hasPrefix("## ") {
                closeListsIfNeeded()
                html.append("<h2>\(renderInline(String(line.dropFirst(3))))</h2>")
                continue
            }

            if line.hasPrefix("### ") {
                closeListsIfNeeded()
                html.append("<h3>\(renderInline(String(line.dropFirst(4))))</h3>")
                continue
            }

            if line.hasPrefix("> ") {
                closeListsIfNeeded()
                html.append("<blockquote>\(renderInline(String(line.dropFirst(2))))</blockquote>")
                continue
            }

            if line.hasPrefix("- ") || line.hasPrefix("* ") {
                if inOrderedList {
                    html.append("</ol>")
                    inOrderedList = false
                }
                if !inUnorderedList {
                    html.append("<ul>")
                    inUnorderedList = true
                }
                html.append("<li>\(renderInline(String(line.dropFirst(2))))</li>")
                continue
            }

            if let numberedItem = parseOrderedListItem(line) {
                if inUnorderedList {
                    html.append("</ul>")
                    inUnorderedList = false
                }
                if !inOrderedList {
                    html.append("<ol>")
                    inOrderedList = true
                }
                html.append("<li>\(renderInline(numberedItem))</li>")
                continue
            }

            closeListsIfNeeded()
            html.append("<p>\(renderInline(line))</p>")
        }

        closeListsIfNeeded()

        if inCodeBlock {
            let code = codeBuffer.joined(separator: "\n")
            html.append("<pre><code>\(escapeHTML(code))</code></pre>")
        }

        return html.joined(separator: "\n")
    }

    private static func parseOrderedListItem(_ line: String) -> String? {
        let pattern = #"^\d+\.\s+(.*)$"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(location: 0, length: line.utf16.count)

        guard let match = regex.firstMatch(in: line, options: [], range: range),
              let contentRange = Range(match.range(at: 1), in: line) else {
            return nil
        }

        return String(line[contentRange])
    }

    private static func renderInline(_ text: String) -> String {
        var result = escapeHTML(text)

        result = replaceRegex(in: result, pattern: #"`([^`]+)`"#, template: "<code>$1</code>")
        result = replaceRegex(in: result, pattern: #"\*\*([^*]+)\*\*"#, template: "<strong>$1</strong>")
        result = replaceRegex(in: result, pattern: #"\*([^*]+)\*"#, template: "<em>$1</em>")
        result = replaceRegex(
            in: result,
            pattern: #"\[([^\]]+)\]\(([^)]+)\)"#,
            template: #"<a href="$2">$1</a>"#
        )

        return result
    }

    private static func replaceRegex(in text: String, pattern: String, template: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return text
        }

        let range = NSRange(location: 0, length: text.utf16.count)
        return regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: template)
    }

    private static func escapeHTML(_ text: String) -> String {
        text
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }
}
