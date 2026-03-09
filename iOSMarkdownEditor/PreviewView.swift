//
//  PreviewView.swift
//  iOSMarkdownEditor
//
//  Created by 李卓非 on 9/3/2026.
//

import SwiftUI

struct PreviewView: View {
    let title: String
    let content: String

    var body: some View {
        MarkdownWebView(
            html: MarkdownRenderer.makeHTML(title: title, markdown: content)
        )
        .navigationTitle("Preview")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PreviewView(
        title: "Welcome.md",
        content: """
        # Welcome

        This is **bold** text, and this is *italic* text.

        Here is inline code: `print("Hello")`

        > This is a quote.

        - Item one
        - Item two

        1. First
        2. Second

        Inline math: $E=mc^2$

        $$\\int_0^1 x^2 \\, dx = \\frac{1}{3}$$

        ```swift
        let message = "Hello, Markdown"
        print(message)
        ```
        """
    )
}
