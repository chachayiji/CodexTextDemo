import UIKit

final class TabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configureTabs()
  }

  private func configureTabs() {
    let newsController = ViewController()
    newsController.title = "今日新闻"
    let newsNav = UINavigationController(rootViewController: newsController)
    newsNav.tabBarItem = UITabBarItem(title: "新闻", image: UIImage(systemName: "newspaper"), tag: 0)

    let videoController = VideoViewController()
    let videoNav = UINavigationController(rootViewController: videoController)
    videoNav.tabBarItem = UITabBarItem(title: "视频", image: UIImage(systemName: "play.rectangle"), tag: 1)

    let mallController = MallViewController()
    let mallNav = UINavigationController(rootViewController: mallController)
    mallNav.tabBarItem = UITabBarItem(title: "商城", image: UIImage(systemName: "cart"), tag: 2)

    let profileController = ProfileViewController()
    let profileNav = UINavigationController(rootViewController: profileController)
    profileNav.tabBarItem = UITabBarItem(title: "我的", image: UIImage(systemName: "person.crop.circle"), tag: 3)

    viewControllers = [newsNav, videoNav, mallNav, profileNav]
  }
}
