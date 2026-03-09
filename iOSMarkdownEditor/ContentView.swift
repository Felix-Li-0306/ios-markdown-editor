//
//  ContentView.swift
//  iOSMarkdownEditor
//
//  Created by 李卓非 on 9/3/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var documents: [MarkdownDocument] = [
        MarkdownDocument(
            id: UUID(),
            title: "Welcome.md",
            content: "# Welcome",
            createdAt: Date(),
            updatedAt: Date()
        ),
        MarkdownDocument(
            id: UUID(),
            title: "Notes.md",
            content: "## Notes",
            createdAt: Date(),
            updatedAt: Date()
        ),
        MarkdownDocument(
            id: UUID(),
            title: "Draft.md",
            content: "Draft content",
            createdAt: Date(),
            updatedAt: Date()
        )
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("Documents") {
                    ForEach($documents) { $document in
                        NavigationLink(destination: EditorView(document: $document)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(document.title)
                                    .font(.body)

                                Text(document.updatedAt, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteDocument)
                }
            }
            .navigationTitle("Markdown Documents")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        createDocument()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    private func createDocument() {
        let newDocument = MarkdownDocument(
            id: UUID(),
            title: "Untitled-\(documents.count + 1).md",
            content: "",
            createdAt: Date(),
            updatedAt: Date()
        )
        documents.insert(newDocument, at: 0)
    }

    private func deleteDocument(at offsets: IndexSet) {
        documents.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
