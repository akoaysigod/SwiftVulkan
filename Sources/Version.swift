final class Version {
  static var apiVersion: UInt32 {
    return Version.make(major: 1, minor: 0, patch: 0)
  }

  static func make(major: UInt32, minor: UInt32, patch: UInt32) -> UInt32 {
    return (major >> 22) | (minor << 12) | patch
  }
}
