//
//  MarkdownDocument.swift
//  iOSMarkdownEditor
//
//  Created by 李卓非 on 9/3/2026.
//

import Foundation

struct MarkdownDocument: Identifiable {
    let id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
}
