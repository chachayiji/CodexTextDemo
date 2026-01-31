import UIKit
import SnapKit

final class NewsListCell: UITableViewCell {
  static let reuseIdentifier = "NewsListCell"

  private let cardView = UIView()
  private let coverImageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let timeLabel = UILabel()
  private var imageTask: URLSessionDataTask?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    backgroundColor = .clear
    configureViews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageTask?.cancel()
    imageTask = nil
    coverImageView.image = UIImage(systemName: "photo")
    titleLabel.text = nil
    subtitleLabel.text = nil
    timeLabel.text = nil
  }

  func configure(with item: NewsItem) {
    titleLabel.text = item.title
    subtitleLabel.text = item.displaySubtitle
    timeLabel.text = item.timeText
    loadImage(from: item.imageURL)
  }

  private func configureViews() {
    cardView.backgroundColor = .white
    cardView.layer.cornerRadius = 14
    cardView.layer.shadowColor = UIColor.black.cgColor
    cardView.layer.shadowOpacity = 0.06
    cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
    cardView.layer.shadowRadius = 10
    contentView.addSubview(cardView)

    coverImageView.contentMode = .scaleAspectFill
    coverImageView.clipsToBounds = true
    coverImageView.layer.cornerRadius = 10
    coverImageView.image = UIImage(systemName: "photo")
    coverImageView.tintColor = UIColor(white: 0.85, alpha: 1)
    cardView.addSubview(coverImageView)

    titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
    titleLabel.textColor = .label
    titleLabel.numberOfLines = 2
    cardView.addSubview(titleLabel)

    subtitleLabel.font = .systemFont(ofSize: 13)
    subtitleLabel.textColor = .secondaryLabel
    subtitleLabel.numberOfLines = 2
    cardView.addSubview(subtitleLabel)

    timeLabel.font = .systemFont(ofSize: 12, weight: .medium)
    timeLabel.textColor = .tertiaryLabel
    cardView.addSubview(timeLabel)

    cardView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(8)
      make.leading.trailing.equalToSuperview().inset(16)
      make.bottom.equalToSuperview().inset(8)
    }

    coverImageView.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().inset(12)
      make.size.equalTo(CGSize(width: 96, height: 72))
    }

    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(12)
      make.leading.equalTo(coverImageView.snp.trailing).offset(12)
      make.trailing.equalToSuperview().inset(12)
    }

    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(6)
      make.leading.equalTo(titleLabel)
      make.trailing.equalTo(titleLabel)
    }

    timeLabel.snp.makeConstraints { make in
      make.top.greaterThanOrEqualTo(subtitleLabel.snp.bottom).offset(6)
      make.leading.equalTo(titleLabel)
      make.bottom.equalToSuperview().inset(12)
    }
  }

  private func loadImage(from url: URL?) {
    guard let url else {
      coverImageView.image = UIImage(systemName: "photo")
      return
    }

    if let cached = ImageCache.shared.image(for: url) {
      coverImageView.image = cached
      return
    }

    imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
      guard let self, let data, let image = UIImage(data: data) else { return }
      ImageCache.shared.store(image: image, for: url)
      DispatchQueue.main.async {
        self.coverImageView.image = image
      }
    }
    imageTask?.resume()
  }
}

private final class ImageCache {
  static let shared = ImageCache()
  private let cache = NSCache<NSURL, UIImage>()

  func image(for url: URL) -> UIImage? {
    cache.object(forKey: url as NSURL)
  }

  func store(image: UIImage, for url: URL) {
    cache.setObject(image, forKey: url as NSURL)
  }
}
