# iOS Markdown Editor

A lightweight iOS Markdown editor with separate source and preview modes.

## Overview

iOS Markdown Editor is a mobile-first Markdown writing app built for iPhone.  
It focuses on a simple editing experience, rendered preview, and support for basic Markdown plus LaTeX math.

This project started as an open-source learning project and has now reached a usable v1 state.

## Features

- Create and edit Markdown documents on iPhone
- Separate source mode and preview mode
- Basic Markdown rendering
- Inline math with `$...$`
- Display math with `$$...$$`
- Local document persistence
- Import Markdown files from Files / iCloud Drive
- Share documents as `.md` files
- Documents sorted by recent update time
- Empty state for first-time use
- Basic editor toolbar for common Markdown symbols

## Current v1 Scope

### Editor
- document title editing
- raw Markdown editing
- cursor-aware symbol insertion
- basic toolbar for Markdown symbols

### Preview
- rendered Markdown preview
- support for headings, lists, blockquotes, code blocks, links, bold, italic
- support for inline and display math

### Storage and File Actions
- local document saving
- import from Files / iCloud Drive
- share current document as a Markdown file

## Current Limitations

- Markdown support focuses on common syntax only
- Preview rendering is intentionally lightweight and not fully Typora-compatible
- Imported files are currently copied into the app workflow rather than continuously synced with external files
- No PDF export yet
- No full external file editing workflow yet

## Tech Stack

- Swift
- SwiftUI
- UIKit bridge for cursor-aware editing
- WKWebView for rendered preview
- MathJax for math rendering
- local JSON-based persistence

## Project Structure

- `ContentView`: document list
- `EditorView`: source editing
- `PreviewView`: rendered preview
- `CursorTextEditor`: cursor-aware editing bridge
- `MarkdownRenderer`: lightweight Markdown + math rendering
- `DocumentStore`: local persistence

## Status

Version 1 is complete and usable as a local Markdown editor MVP.

## Future Ideas

- export to Files
- dark mode polish
- better preview styling
- document search
- richer Markdown support
- external file editing workflows

## License

MIT
