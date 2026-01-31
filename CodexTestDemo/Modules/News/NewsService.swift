import Foundation
import Moya

final class NewsService {
  private let client: NetworkClient

  init(client: NetworkClient = .shared) {
    self.client = client
  }

  func fetchLatest(completion: @escaping (Result<[NewsItem], Error>) -> Void) {
    client.request(NewsAPI.chinaNews) { result in
      switch result {
      case .success(let response):
        let parser = NewsFeedParser()
        completion(parser.parse(data: response.data))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

private enum NewsAPI {
  case chinaNews
}

extension NewsAPI: TargetType {
  var baseURL: URL {
    URL(string: "https://www.chinanews.com.cn")!
  }

  var path: String {
    switch self {
    case .chinaNews:
      return "/rss/scroll-news.xml"
    }
  }

  var method: Moya.Method { .get }

  var task: Task { .requestPlain }

  var headers: [String: String]? {
    ["Accept": "application/rss+xml, application/xml"]
  }
}

private final class NewsFeedParser: NSObject, XMLParserDelegate {
  private var items: [NewsItem] = []
  private var currentItem: NewsItemBuilder?
  private var currentElement = ""
  private var currentValue = ""

  func parse(data: Data) -> Result<[NewsItem], Error> {
    let parser = XMLParser(data: data)
    parser.delegate = self
    parser.shouldResolveExternalEntities = false
    if parser.parse() {
      return .success(items)
    }
    return .failure(parser.parserError ?? NSError(domain: "NewsFeedParser", code: -1))
  }

  func parser(
    _ parser: XMLParser,
    didStartElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?,
    attributes attributeDict: [String: String] = [:]
  ) {
    currentElement = elementName
    currentValue = ""
    if elementName == "item" {
      currentItem = NewsItemBuilder()
    }
    if elementName == "enclosure", let url = attributeDict["url"] {
      if let type = attributeDict["type"], type.contains("image") {
        currentItem?.imageURLString = url
      } else if url.hasSuffix(".jpg") || url.hasSuffix(".jpeg") || url.hasSuffix(".png") {
        currentItem?.imageURLString = url
      }
    }
    if elementName == "media:thumbnail", let url = attributeDict["url"] {
      currentItem?.imageURLString = url
    }
  }

  func parser(_ parser: XMLParser, foundCharacters string: String) {
    currentValue += string
  }

  func parser(
    _ parser: XMLParser,
    didEndElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?
  ) {
    let trimmed = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let currentItem else { return }

    switch elementName {
    case "title":
      currentItem.title = trimmed
    case "link":
      currentItem.link = trimmed
    case "description":
      currentItem.summary = Self.stripHTML(trimmed)
      if let firstImage = Self.extractImageURL(from: trimmed) {
        // Prefer the first inline image from the description.
        currentItem.imageURLString = firstImage
      }
    case "pubDate":
      currentItem.pubDate = Self.parseDate(trimmed)
    case "source":
      currentItem.source = trimmed
    case "item":
      if let item = currentItem.build() {
        items.append(item)
      }
      self.currentItem = nil
    default:
      break
    }
  }

  private static func parseDate(_ value: String) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
    return formatter.date(from: value)
  }

  private static func stripHTML(_ value: String) -> String {
    guard let data = value.data(using: .utf8) else { return value }
    if let attributed = try? NSAttributedString(
      data: data,
      options: [
        .documentType: NSAttributedString.DocumentType.html,
        .characterEncoding: String.Encoding.utf8.rawValue
      ],
      documentAttributes: nil
    ) {
      return attributed.string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return value.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
  }

  private static func extractImageURL(from value: String) -> String? {
    let pattern = "<img[^>]+src=[\"']([^\"']+)[\"']"
    guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
      return nil
    }
    let range = NSRange(value.startIndex..., in: value)
    guard let match = regex.firstMatch(in: value, options: [], range: range),
          match.numberOfRanges > 1,
          let urlRange = Range(match.range(at: 1), in: value) else {
      return nil
    }
    return String(value[urlRange])
  }
}

private final class NewsItemBuilder {
  var title: String = ""
  var link: String = ""
  var summary: String = ""
  var source: String?
  var pubDate: Date?
  var imageURLString: String?

  func build() -> NewsItem? {
    guard !title.isEmpty, !link.isEmpty else { return nil }
    return NewsItem(
      title: title,
      link: link,
      summary: summary,
      source: source,
      pubDate: pubDate,
      imageURL: Self.makeURL(from: imageURLString)
    )
  }

  private static func makeURL(from value: String?) -> URL? {
    guard let value, !value.isEmpty else { return nil }
    var trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.hasPrefix("//") {
      trimmed = "https:" + trimmed
    }
    if trimmed.hasPrefix("http://") {
      trimmed = "https://" + trimmed.dropFirst("http://".count)
    }
    return URL(string: trimmed)
  }
}
