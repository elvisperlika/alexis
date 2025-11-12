extension NotionPage {

  /// Get the title of the Notion page.
  /// - Returns: The title as a String, or an empty string if not found.
  public func getTitle() -> String {
    return self.properties.title.title.first?.plainText ?? ""
  }
}
