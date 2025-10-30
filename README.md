# ``Alexis``

![Notion + Swift](Resources/alexis.png)

Unofficial iOS/macOS SDK for the Notion API.

## Overview


## Setup

This SDK requires a [Notion Integration](https://www.notion.so/my-integrations).

1. Create a new integration in Notion.  
2. Copy the **Integration Key**.  
3. Save it as an environment variable in your codebase:

    ```bash
    NOTION_TOKEN=your_integration_key_here
    ```
    
4. Create your Notion Client with the variable as parameter:
    ```swift
    let apiKey: String = ProcessInfo.processInfo.environment["NOTION_TOKEN"] ?? "Missing env. variable"
    client = NotionClient(apiKey: apiKey)
    ```

## Guide

Note: this SDK requires a Notion Integration.
Create an integration in Notion, copy its key, 
and save it as an environment variable in your codebase.
Keep in mind that the integration can only access 
pages or databases you have manually shared with it.


### Workspace's users

``let users = try await client?.getUsers()``

### Pages

### Databases

