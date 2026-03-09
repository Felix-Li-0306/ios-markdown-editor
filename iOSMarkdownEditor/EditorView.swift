//
//  EditorView.swift
//  iOSMarkdownEditor
//
//  Created by 李卓非 on 9/3/2026.
//

import SwiftUI

struct EditorView: View {
    @Binding var document: MarkdownDocument
    @State private var selectedRange: NSRange = NSRange(location: 0, length: 0)

    private var displayTitle: String {
        let trimmed = document.title.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Untitled" : trimmed
    }

    private var shareURL: URL {
        let safeTitle = sanitizedFileName(from: displayTitle)
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(safeTitle)
            .appendingPathExtension("md")

        try? document.content.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Untitled", text: $document.title)
                .textFieldStyle(.roundedBorder)
                .font(.title3)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    toolbarButton("#") {
                        insertAtCursor("#")
                    }

                    toolbarButton("-") {
                        insertAtCursor("-")
                    }

                    toolbarButton("**") {
                        insertAtCursor("**")
                    }

                    toolbarButton("`") {
                        insertAtCursor("`")
                    }

                    toolbarButton("$") {
                        insertAtCursor("$")
                    }

                    toolbarButton("$$") {
                        insertAtCursor("$$")
                    }
                }
                .padding(.horizontal, 2)
            }

            Text("Markdown Source")
                .font(.headline)

            CursorTextEditor(
                text: $document.content,
                selectedRange: $selectedRange
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .padding()
        .navigationTitle("Editor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                ShareLink(
                    item: shareURL,
                    subject: Text(displayTitle),
                    message: Text("Shared from iOS Markdown Editor")
                ) {
                    Image(systemName: "square.and.arrow.up")
                }

                NavigationLink(
                    destination: PreviewView(
                        title: document.title,
                        content: document.content
                    )
                ) {
                    Text("Preview")
                }
            }
        }
        .onChange(of: document.title) { _, _ in
            document.updatedAt = Date()
        }
        .onChange(of: document.content) { _, _ in
            document.updatedAt = Date()
        }
    }

    @ViewBuilder
    private func toolbarButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline.monospaced())
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    private func insertAtCursor(_ insertedText: String) {
        let currentText = document.content
        guard let stringRange = Range(selectedRange, in: currentText) else {
            document.content += insertedText
            selectedRange = NSRange(location: document.content.count, length: 0)
            return
        }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: insertedText)
        document.content = updatedText

        let newLocation = selectedRange.location + insertedText.count
        selectedRange = NSRange(location: newLocation, length: 0)
    }

    private func sanitizedFileName(from title: String) -> String {
        let invalidCharacters = CharacterSet(charactersIn: "/\\:?%*|\"<>")
        let cleaned = title.components(separatedBy: invalidCharacters).joined(separator: "-")
        let trimmed = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Untitled" : trimmed
    }
}
