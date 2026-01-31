import UIKit

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
    tableView.translatesAutoresizingMaskIntoConstraints = false
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

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  private func configureStatusLabel() {
    statusLabel.translatesAutoresizingMaskIntoConstraints = false
    statusLabel.textAlignment = .center
    statusLabel.numberOfLines = 0
    statusLabel.font = .systemFont(ofSize: 14)
    statusLabel.textColor = .secondaryLabel
    statusLabel.isHidden = true
    view.addSubview(statusLabel)

    NSLayoutConstraint.activate([
      statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
      statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
    ])
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
