import UIKit

final class ProfileViewController: UIViewController {
  private let viewModel = ProfileViewModel()
  private let contentView = ProfileView()

  override func loadView() {
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "我的"
    contentView.tableView.dataSource = self
    contentView.tableView.delegate = self
  }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = ProfileViewModel.Section(rawValue: section) else { return 0 }
    return viewModel.numberOfRows(in: section)
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let section = ProfileViewModel.Section(rawValue: indexPath.section) else { return UITableViewCell() }

    switch section {
    case .profile:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: ProfileHeaderCell.reuseIdentifier,
        for: indexPath
      ) as? ProfileHeaderCell else {
        return UITableViewCell()
      }
      let header = viewModel.header()
      cell.configure(name: header.name, wechatId: header.wechatId, subtitle: header.subtitle)
      return cell
    case .services:
      return makeItemCell(tableView, item: viewModel.item(at: indexPath), indexPath: indexPath)
    case .favorites:
      return makeItemCell(tableView, item: viewModel.item(at: indexPath), indexPath: indexPath)
    case .settings:
      return makeItemCell(tableView, item: viewModel.item(at: indexPath), indexPath: indexPath)
    }
  }

  private func makeItemCell(
    _ tableView: UITableView,
    item: ProfileViewModel.Item?,
    indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: ProfileItemCell.reuseIdentifier,
      for: indexPath
    ) as? ProfileItemCell else {
      return UITableViewCell()
    }
    if let item {
      cell.configure(title: item.title, systemImage: item.systemImage, tint: item.tint)
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if ProfileViewModel.Section(rawValue: indexPath.section) == .profile {
      return 88
    }
    return 56
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    if ProfileViewModel.Section(rawValue: section) == .profile {
      return " "
    }
    return nil
  }
}
