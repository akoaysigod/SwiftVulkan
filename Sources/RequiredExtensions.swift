import CGLFW3
import CVulkan

final class RequiredExtensions {
  let count: UInt32
  let names: [UnsafePointer<Int8>?]

  init() {
    let (count, names) = RequiredExtensions.getExtensions()
    self.count = count
    self.names = names
  }

  //no idea if this is supposed to work or not
//  deinit {
//    for e in names {
//      e?.deinitialize(count: 1)
//      e?.deallocate(capacity: 1)
//    }
//  }

  //gets the available extensions as strings
  //probably can figure out how to use this to make sure glfwGetRequiredinstanceExtensions are satisfied
  private func checkAvailableExtensions() {
    var extensionCount: UInt32 = 0
    vkEnumerateInstanceExtensionProperties(nil, &extensionCount, nil)
    var extensionProperties = [VkExtensionProperties](repeating: VkExtensionProperties(), count: Int(extensionCount))
    vkEnumerateInstanceExtensionProperties(nil, &extensionCount, &extensionProperties)
    for p in extensionProperties {
      print(String.make(from: p.extensionName))
    }
  }

  private static func getExtensions() -> (UInt32, [UnsafePointer<Int8>?]) {
    var glfwExtensionCount: UInt32 = 0
    guard let glfwExtensions = glfwGetRequiredInstanceExtensions(&glfwExtensionCount) else {
      fatalError("Cannot get glfw extensions.")
    }

    defer {
      //do I need this?
      glfwExtensions.deinitialize(count: Int(glfwExtensionCount))
      glfwExtensions.deallocate(capacity: Int(glfwExtensionCount))
    }

    var retExtensions = [UnsafePointer<CChar>]()
    for i in 0..<glfwExtensionCount {
      guard let name = glfwExtensions[Int(i)] else { continue }
      retExtensions.append(name)
    }

    #if DEBUG
    retExtensions.append(VK_EXT_DEBUG_REPORT_EXTENSION_NAME.cStringCopy)
    glfwExtensionCount += 1
    #endif

    return (glfwExtensionCount, retExtensions)
  }
}
