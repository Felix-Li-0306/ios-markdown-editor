# App Structure

## MVP Screens

### 1. Document List Screen
Purpose:
- show all local Markdown documents
- create a new document
- open an existing document
- delete a document

Main UI elements:
- navigation title
- list of documents
- create button
- delete action

### 2. Source Editor Screen
Purpose:
- edit raw Markdown text
- rename or show document title
- access preview mode

Main UI elements:
- document title
- text editor
- preview button
- save behavior

### 3. Preview Screen
Purpose:
- display rendered Markdown content
- let the user review the formatted result

Main UI elements:
- rendered content area
- back button
- optional refresh behavior

## Navigation Flow

Document List Screen
-> tap document
-> Source Editor Screen
-> tap preview
-> Preview Screen

Document List Screen
-> tap create
-> Source Editor Screen

Preview Screen
-> back
-> Source Editor Screen

Source Editor Screen
-> back
-> Document List Screen

## Data Flow

- each document has a title
- each document has raw Markdown content
- documents are stored locally
- the preview screen reads the raw Markdown and renders it for display

## MVP Principles

- keep navigation simple
- focus on local-first editing
- separate editing and preview clearly
- avoid advanced features in the first version
