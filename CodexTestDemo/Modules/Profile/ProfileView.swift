import UIKit
import SnapKit

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

    tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
    tableView.separatorColor = UIColor(white: 0.85, alpha: 1.0)
    tableView.rowHeight = 56
    tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: ProfileHeaderCell.reuseIdentifier)
    tableView.register(ProfileItemCell.self, forCellReuseIdentifier: ProfileItemCell.reuseIdentifier)
    addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
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
    avatarView.backgroundColor = UIColor(red: 0.82, green: 0.86, blue: 0.9, alpha: 1.0)
    avatarView.layer.cornerRadius = 12
    avatarView.layer.masksToBounds = true
    avatarView.image = UIImage(systemName: "person.crop.square")
    avatarView.tintColor = UIColor(white: 1.0, alpha: 0.9)

    nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)

    wechatIdLabel.font = .systemFont(ofSize: 13)
    wechatIdLabel.textColor = .secondaryLabel

    subtitleLabel.font = .systemFont(ofSize: 12)
    subtitleLabel.textColor = .tertiaryLabel

    qrImageView.image = UIImage(systemName: "qrcode")
    qrImageView.tintColor = .secondaryLabel
    qrImageView.contentMode = .scaleAspectFit

    contentView.addSubview(avatarView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(wechatIdLabel)
    contentView.addSubview(subtitleLabel)
    contentView.addSubview(qrImageView)

    avatarView.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
      make.size.equalTo(CGSize(width: 56, height: 56))
    }

    qrImageView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(36)
      make.size.equalTo(CGSize(width: 20, height: 20))
    }

    nameLabel.snp.makeConstraints { make in
      make.leading.equalTo(avatarView.snp.trailing).offset(16)
      make.top.equalToSuperview().inset(18)
      make.trailing.lessThanOrEqualTo(qrImageView.snp.leading).offset(-12)
    }

    wechatIdLabel.snp.makeConstraints { make in
      make.leading.equalTo(nameLabel)
      make.top.equalTo(nameLabel.snp.bottom).offset(4)
      make.trailing.lessThanOrEqualTo(qrImageView.snp.leading).offset(-12)
    }

    subtitleLabel.snp.makeConstraints { make in
      make.leading.equalTo(nameLabel)
      make.top.equalTo(wechatIdLabel.snp.bottom).offset(4)
      make.trailing.lessThanOrEqualTo(qrImageView.snp.leading).offset(-12)
    }
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
    iconContainer.layer.cornerRadius = 6

    iconView.contentMode = .scaleAspectFit

    titleLabel.font = .systemFont(ofSize: 16)

    iconContainer.addSubview(iconView)
    contentView.addSubview(iconContainer)
    contentView.addSubview(titleLabel)

    iconContainer.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
      make.size.equalTo(CGSize(width: 28, height: 28))
    }

    iconView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.size.equalTo(CGSize(width: 16, height: 16))
    }

    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(iconContainer.snp.trailing).offset(12)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(16)
    }
  }
}
