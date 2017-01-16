import Foundation

extension String {
  static func make(from: Any) -> String {
    let mirror = Mirror(reflecting: from)
    let str = mirror.children.reduce(String()) { (str, char) in
      guard let charVal = char.value as? Int8, charVal != 0 else { return str }
      var str = str
      str.append(Character(UnicodeScalar(UInt8(charVal))))
      return str
    }
    return str
  }
}
