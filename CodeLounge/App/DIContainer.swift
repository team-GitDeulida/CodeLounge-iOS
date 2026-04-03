//
//  DIContainer.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import Foundation

@propertyWrapper
class Dependency<T> {
    let wrappedValue: T
    init() {
        self.wrappedValue = DIContainer.shared.resolve(T.self)
    }
}


final class DIContainer {
    static let shared = DIContainer()
    private init() {}
    private var dependencies: [String: Any] = [:]
    
    /// 타입 자체를 Key로 사용하여 의존성을 등록합니다.
    /// - Parameter dependency: 등록할 객체 인스턴스
    /// - Example: `DIContainer.shared.register(NetworkManager())`
    func register<T>(_ dependency: T) {
        let key = String(describing: T.self)
        dependencies[key] = dependency
    }
    
    /// 명시적으로 특정 타입(보통은 프로토콜)을 Key로 지정하여 의존성을 등록합니다.
    /// - Parameters:
    ///   - dependency: 등록할 객체 인스턴스
    ///   - type: 이 객체가 매칭될 인터페이스(예: 프로토콜)
    /// - Example:
    ///   ```swift
    ///   DIContainer.shared.register(NetworkManager(), for: NetworkService.self)
    ///   ```
    func register<T>(_ dependency: T, for type: T.Type) {
      let key = String(describing: type)
      dependencies[key] = dependency
    }
    
    /// 등록된 의존성을 꺼냅니다. 존재하지 않으면 앱을 중단시킵니다.
    /// - Parameter type: 꺼내고 싶은 타입
    /// - Returns: 등록된 의존성 인스턴스
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let dependency = dependencies[key] as? T else {
            preconditionFailure("⚠️ \(key)는 register되지 않았습니다. resolve호출 전에 register 해주세요.")
        }
        return dependency
    }
}

extension DIContainer {
  static func config() {
    let userRepository = UserDBRepository()
    self.shared.register(
      UserService(dbRepository: userRepository),
      for: UserServiceProtocol.self
    )
    self.shared.register(
      AuthService(),
      for: AuthServiceProtocol.self
    )
  }
}
