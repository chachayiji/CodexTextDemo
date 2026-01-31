import Foundation

struct NewsItem: Hashable {
  let title: String
  let link: String
  let summary: String
  let source: String?
  let pubDate: Date?
  let imageURL: URL?

  var linkURL: URL? {
    guard var components = URLComponents(string: link) else { return nil }
    if components.scheme == nil {
      components.scheme = "https"
    } else if components.scheme == "http" {
      components.scheme = "https"
    }
    return components.url
  }

  var subtitleText: String {
    var parts: [String] = []
    if let source, !source.isEmpty {
      parts.append(source)
    }
    if let pubDate {
      parts.append(Self.dateFormatter.string(from: pubDate))
    }
    return parts.isEmpty ? "中国新闻网" : parts.joined(separator: " · ")
  }

  var displaySubtitle: String {
    if !summary.isEmpty {
      return summary
    }
    return subtitleText
  }

  var timeText: String? {
    guard let pubDate else { return nil }
    return Self.timeFormatter.string(from: pubDate)
  }

  private static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
  }()

  private static let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "HH:mm"
    return formatter
  }()
}
