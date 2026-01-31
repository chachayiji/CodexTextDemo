import UIKit
import SnapKit

final class ViewController: UIViewController {
  private let tableView = UITableView(frame: .zero, style: .plain)
  private let statusLabel = UILabel()
  private let refreshControl = UIRefreshControl()
  private let service = NewsService()
  private var allItems: [NewsItem] = []
  private var displayItems: [NewsItem] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "今日新闻"
    view.backgroundColor = .systemBackground
    configureTableView()
    configureStatusLabel()
    fetchNews(isRefreshing: false)
  }

  private func configureTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 112
    tableView.separatorStyle = .none
    tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
    tableView.refreshControl = refreshControl
    tableView.register(NewsListCell.self, forCellReuseIdentifier: NewsListCell.reuseIdentifier)
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func configureStatusLabel() {
    statusLabel.textAlignment = .center
    statusLabel.numberOfLines = 0
    statusLabel.font = .systemFont(ofSize: 14)
    statusLabel.textColor = .secondaryLabel
    statusLabel.isHidden = true
    view.addSubview(statusLabel)

    statusLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.leading.greaterThanOrEqualToSuperview().inset(20)
      make.trailing.lessThanOrEqualToSuperview().inset(20)
    }
  }

  @objc private func handleRefresh() {
    fetchNews(isRefreshing: true)
  }

  private func fetchNews(isRefreshing: Bool) {
    if !isRefreshing {
      statusLabel.isHidden = false
      statusLabel.text = "正在获取最新新闻…"
    }

    service.fetchLatest { [weak self] result in
      DispatchQueue.main.async {
        guard let self else { return }
        self.refreshControl.endRefreshing()

        switch result {
        case .success(let items):
          self.allItems = items
          self.displayItems = self.filterForToday(items)
          if self.displayItems.isEmpty {
            self.displayItems = items
          }
          self.statusLabel.isHidden = !self.displayItems.isEmpty
          self.statusLabel.text = self.displayItems.isEmpty ? "暂时没有新闻数据" : nil
          self.tableView.reloadData()
        case .failure(let error):
          self.displayItems = []
          self.tableView.reloadData()
          self.statusLabel.isHidden = false
          self.statusLabel.text = "获取失败：\(error.localizedDescription)"
        }
      }
    }
  }

  private func filterForToday(_ items: [NewsItem]) -> [NewsItem] {
    let calendar = Calendar.current
    let today = Date()
    return items.filter { item in
      guard let date = item.pubDate else { return false }
      return calendar.isDate(date, inSameDayAs: today)
    }
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    displayItems.count
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: NewsListCell.reuseIdentifier,
      for: indexPath
    ) as? NewsListCell else {
      return UITableViewCell()
    }
    let item = displayItems[indexPath.row]
    cell.configure(with: item)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let item = displayItems[indexPath.row]
    let detail = NewsDetailViewController(item: item)
    navigationController?.pushViewController(detail, animated: true)
  }
}
