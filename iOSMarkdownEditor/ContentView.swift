//
//  ContentView.swift
//  iOSMarkdownEditor
//
//  Created by 李卓非 on 9/3/2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var documents: [MarkdownDocument] = []
    @State private var isImporting = false
    @State private var importErrorMessage: String?
    
    private var sortedDocuments: [MarkdownDocument] {
        documents.sorted { $0.updatedAt > $1.updatedAt }
    }

    var body: some View {
        NavigationStack {
            Group {
                if documents.isEmpty {
                    emptyStateView
                } else {
                    List {
                        Section("Documents") {
                            ForEach(sortedDocuments) { document in
                                if let index = documents.firstIndex(where: { $0.id == document.id }) {
                                    NavigationLink(destination: EditorView(document: $documents[index])) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(displayTitle(for: documents[index]))
                                                .font(.body)

                                            Text(documents[index].updatedAt, style: .date)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                            .onDelete(perform: deleteDocumentFromSortedList)
                        }
                    }
                }
            }
            .navigationTitle("Markdown Documents")
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    if !documents.isEmpty {
                        EditButton()
                    }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        isImporting = true
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }

                    Button {
                        createDocument()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear {
            loadDocuments()
        }
        .onChange(of: documents) { _, newValue in
            DocumentStore.saveDocuments(newValue)
        }
        
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.plainText, UTType(filenameExtension: "md") ?? .plainText],
            allowsMultipleSelection: false
        ) { result in
            handleImportResult(result)
        }
        .alert("Import Failed", isPresented: Binding(
            get: { importErrorMessage != nil },
            set: { if !$0 { importErrorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(importErrorMessage ?? "Unknown error")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("No Documents Yet")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Create your first Markdown document to start writing.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Button {
                createDocument()
            } label: {
                Label("Create Document", systemImage: "plus")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private func handleImportResult(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            importDocument(from: url)

        case .failure(let error):
            importErrorMessage = error.localizedDescription
        }
    }

    private func importDocument(from url: URL) {
        let didStartAccessing = url.startAccessingSecurityScopedResource()

        defer {
            if didStartAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }

        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            let importedTitle = makeImportedTitle(from: url)

            let newDocument = MarkdownDocument(
                id: UUID(),
                title: importedTitle,
                content: content,
                createdAt: Date(),
                updatedAt: Date()
            )

            documents.append(newDocument)
        } catch {
            importErrorMessage = error.localizedDescription
        }
    }

    private func makeImportedTitle(from url: URL) -> String {
        let baseName = url.deletingPathExtension().lastPathComponent
        let trimmedBaseName = baseName.trimmingCharacters(in: .whitespacesAndNewlines)
        let fallback = trimmedBaseName.isEmpty ? "Imported Document" : trimmedBaseName

        let existingTitles = Set(
            documents.map { $0.title.trimmingCharacters(in: .whitespacesAndNewlines) }
        )

        if !existingTitles.contains(fallback) {
            return fallback
        }

        var index = 2
        while existingTitles.contains("\(fallback) \(index)") {
            index += 1
        }

        return "\(fallback) \(index)"
    }
    
    private func loadDocuments() {
        let savedDocuments = DocumentStore.loadDocuments()

        if savedDocuments.isEmpty {
            documents = [
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
        } else {
            documents = savedDocuments
        }
    }
    
    private func displayTitle(for document: MarkdownDocument) -> String {
        let trimmed = document.title.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Untitled" : trimmed
    }

    private func makeUntitledName() -> String {
        let existingTitles = Set(
            documents.map { $0.title.trimmingCharacters(in: .whitespacesAndNewlines) }
        )

        if !existingTitles.contains("Untitled") {
            return "Untitled"
        }

        var index = 2
        while existingTitles.contains("Untitled \(index)") {
            index += 1
        }

        return "Untitled \(index)"
    }
    
    private func createDocument() {
        let newDocument = MarkdownDocument(
            id: UUID(),
            title: makeUntitledName(),
            content: "",
            createdAt: Date(),
            updatedAt: Date()
        )
        documents.append(newDocument)
    }

    private func deleteDocumentFromSortedList(at offsets: IndexSet) {
        let documentsToDelete = offsets.map { sortedDocuments[$0].id }
        documents.removeAll { documentsToDelete.contains($0.id) }
    }
}

#Preview {
    ContentView()
}
