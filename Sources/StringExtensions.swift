import Foundation

extension String {
  var cStringCopy: UnsafePointer<Int8> {
    return UnsafePointer(strdup(self))
  }

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

extension Sequence where Iterator.Element == String {
  //https://github.com/apple/swift/blob/master/stdlib/private/SwiftPrivate/SwiftPrivate.swift
  //I tried using the above but it didn't work, this probably isn't the most efficient thing to do but it's working at least
  var cArray: [UnsafePointer<Int8>?] {
    var ret = [UnsafePointer<Int8>?]()
    for str in self {
      ret.append(strdup(str))
    }
    return ret
  }
}
