import Foundation
import Moya

final class NetworkClient {
  static let shared = NetworkClient()

  private let provider: MoyaProvider<MultiTarget>

  init(provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>()) {
    self.provider = provider
  }

  func request<T: TargetType>(
    _ target: T,
    completion: @escaping (Result<Response, MoyaError>) -> Void
  ) {
    provider.request(MultiTarget(target), completion: completion)
  }
}
