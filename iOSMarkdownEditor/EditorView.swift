//
//  EditorView.swift
//  iOSMarkdownEditor
//
//  Created by 李卓非 on 9/3/2026.
//

import SwiftUI

struct EditorView: View {
    let document: MarkdownDocument
    @State private var content: String

    init(document: MarkdownDocument) {
        self.document = document
        _content = State(initialValue: document.content)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(document.title)
                .font(.title2)
                .fontWeight(.bold)

            Text("Markdown Source")
                .font(.headline)

            TextEditor(text: $content)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .padding()
        .navigationTitle("Editor")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EditorView(
        document: MarkdownDocument(
            id: UUID(),
            title: "Welcome.md",
            content: "# Welcome",
            createdAt: Date(),
            updatedAt: Date()
        )
    )
}
