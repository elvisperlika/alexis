protocol UserProtocol {
  var avatarUrl: String { get }
  var name: String { get }
  var email: String { get }
  var type: String { get }
}

typealias Users = [UserProtocol]
