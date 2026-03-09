//
//  EditorView.swift
//  iOSMarkdownEditor
//
//  Created by 李卓非 on 9/3/2026.
//

import SwiftUI

struct EditorView: View {
    @Binding var document: MarkdownDocument

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Document Title", text: $document.title)
                .textFieldStyle(.roundedBorder)
                .font(.title3)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    toolbarButton("#") {
                        insert("#")
                    }

                    toolbarButton("-") {
                        insert("-")
                    }

                    toolbarButton("**") {
                        insert("**")
                    }

                    toolbarButton("`") {
                        insert("`")
                    }

                    toolbarButton("$") {
                        insert("$")
                    }

                    toolbarButton("$$") {
                        insert("$$")
                    }
                }
                .padding(.horizontal, 2)
            }

            Text("Markdown Source")
                .font(.headline)

            TextEditor(text: $document.content)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .padding()
        .navigationTitle("Editor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
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

    private func insert(_ text: String) {
        document.content += text
    }
}
