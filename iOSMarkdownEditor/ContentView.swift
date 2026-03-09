//
//  ContentView.swift
//  iOSMarkdownEditor
//
//  Created by 李卓非 on 9/3/2026.
//

import SwiftUI

struct ContentView: View {
    let documents: [MarkdownDocument] = [
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
                    ForEach(documents) { document in
                        NavigationLink(destination: EditorView(document: document)) {
                            Text(document.title)
                        }
                    }
                }
            }
            .navigationTitle("Markdown Documents")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: Create new document
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
