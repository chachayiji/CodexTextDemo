import UIKit

final class ProfileView: UIView {
  let tableView = UITableView(frame: .zero, style: .insetGrouped)

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureView() {
    backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
    tableView.separatorColor = UIColor(white: 0.85, alpha: 1.0)
    tableView.rowHeight = 56
    tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: ProfileHeaderCell.reuseIdentifier)
    tableView.register(ProfileItemCell.self, forCellReuseIdentifier: ProfileItemCell.reuseIdentifier)
    addSubview(tableView)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}

final class ProfileHeaderCell: UITableViewCell {
  static let reuseIdentifier = "ProfileHeaderCell"

  private let avatarView = UIImageView()
  private let nameLabel = UILabel()
  private let wechatIdLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let qrImageView = UIImageView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    accessoryType = .disclosureIndicator
    configureSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(name: String, wechatId: String, subtitle: String) {
    nameLabel.text = name
    wechatIdLabel.text = wechatId
    subtitleLabel.text = subtitle
  }

  private func configureSubviews() {
    avatarView.translatesAutoresizingMaskIntoConstraints = false
    avatarView.backgroundColor = UIColor(red: 0.82, green: 0.86, blue: 0.9, alpha: 1.0)
    avatarView.layer.cornerRadius = 12
    avatarView.layer.masksToBounds = true
    avatarView.image = UIImage(systemName: "person.crop.square")
    avatarView.tintColor = UIColor(white: 1.0, alpha: 0.9)

    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)

    wechatIdLabel.translatesAutoresizingMaskIntoConstraints = false
    wechatIdLabel.font = .systemFont(ofSize: 13)
    wechatIdLabel.textColor = .secondaryLabel

    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.font = .systemFont(ofSize: 12)
    subtitleLabel.textColor = .tertiaryLabel

    qrImageView.translatesAutoresizingMaskIntoConstraints = false
    qrImageView.image = UIImage(systemName: "qrcode")
    qrImageView.tintColor = .secondaryLabel
    qrImageView.contentMode = .scaleAspectFit

    contentView.addSubview(avatarView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(wechatIdLabel)
    contentView.addSubview(subtitleLabel)
    contentView.addSubview(qrImageView)

    NSLayoutConstraint.activate([
      avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      avatarView.widthAnchor.constraint(equalToConstant: 56),
      avatarView.heightAnchor.constraint(equalToConstant: 56),

      nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
      nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: qrImageView.leadingAnchor, constant: -12),

      wechatIdLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
      wechatIdLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
      wechatIdLabel.trailingAnchor.constraint(lessThanOrEqualTo: qrImageView.leadingAnchor, constant: -12),

      subtitleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
      subtitleLabel.topAnchor.constraint(equalTo: wechatIdLabel.bottomAnchor, constant: 4),
      subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: qrImageView.leadingAnchor, constant: -12),

      qrImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      qrImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
      qrImageView.widthAnchor.constraint(equalToConstant: 20),
      qrImageView.heightAnchor.constraint(equalToConstant: 20)
    ])
  }
}

final class ProfileItemCell: UITableViewCell {
  static let reuseIdentifier = "ProfileItemCell"

  private let iconContainer = UIView()
  private let iconView = UIImageView()
  private let titleLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .default
    accessoryType = .disclosureIndicator
    configureSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(title: String, systemImage: String, tint: UIColor) {
    titleLabel.text = title
    iconView.image = UIImage(systemName: systemImage)
    iconView.tintColor = .white
    iconContainer.backgroundColor = tint
  }

  private func configureSubviews() {
    iconContainer.translatesAutoresizingMaskIntoConstraints = false
    iconContainer.layer.cornerRadius = 6

    iconView.translatesAutoresizingMaskIntoConstraints = false
    iconView.contentMode = .scaleAspectFit

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = .systemFont(ofSize: 16)

    iconContainer.addSubview(iconView)
    contentView.addSubview(iconContainer)
    contentView.addSubview(titleLabel)

    NSLayoutConstraint.activate([
      iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      iconContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      iconContainer.widthAnchor.constraint(equalToConstant: 28),
      iconContainer.heightAnchor.constraint(equalToConstant: 28),

      iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
      iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
      iconView.widthAnchor.constraint(equalToConstant: 16),
      iconView.heightAnchor.constraint(equalToConstant: 16),

      titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }
}
