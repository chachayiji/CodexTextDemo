import UIKit

final class ProfileViewModel {
  struct HeaderInfo {
    let name: String
    let wechatId: String
    let subtitle: String
  }

  struct Item {
    let title: String
    let systemImage: String
    let tint: UIColor
  }

  enum Section: Int, CaseIterable {
    case profile
    case services
    case favorites
    case settings
  }

  private let headerInfo = HeaderInfo(
    name: "Xiong Jinhui",
    wechatId: "微信号: xiongjinhui",
    subtitle: "设置头像与个性签名"
  )

  private let services: [Item] = [
    Item(title: "服务", systemImage: "creditcard", tint: UIColor(red: 0.96, green: 0.76, blue: 0.18, alpha: 1.0))
  ]

  private let favorites: [Item] = [
    Item(title: "收藏", systemImage: "star", tint: UIColor(red: 0.98, green: 0.76, blue: 0.2, alpha: 1.0)),
    Item(title: "朋友圈", systemImage: "photo.on.rectangle", tint: UIColor(red: 0.27, green: 0.68, blue: 0.95, alpha: 1.0)),
    Item(title: "卡包", systemImage: "creditcard.fill", tint: UIColor(red: 0.95, green: 0.36, blue: 0.47, alpha: 1.0)),
    Item(title: "表情", systemImage: "face.smiling", tint: UIColor(red: 0.42, green: 0.82, blue: 0.36, alpha: 1.0))
  ]

  private let settings: [Item] = [
    Item(title: "设置", systemImage: "gearshape", tint: UIColor(red: 0.54, green: 0.58, blue: 0.64, alpha: 1.0))
  ]

  var sections: [Section] {
    Section.allCases
  }

  func header() -> HeaderInfo {
    headerInfo
  }

  func numberOfRows(in section: Section) -> Int {
    switch section {
    case .profile:
      return 1
    case .services:
      return services.count
    case .favorites:
      return favorites.count
    case .settings:
      return settings.count
    }
  }

  func item(at indexPath: IndexPath) -> Item? {
    guard let section = Section(rawValue: indexPath.section) else { return nil }
    switch section {
    case .profile:
      return nil
    case .services:
      return services[indexPath.row]
    case .favorites:
      return favorites[indexPath.row]
    case .settings:
      return settings[indexPath.row]
    }
  }
}
