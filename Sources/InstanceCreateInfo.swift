import CVulkan

//https://www.khronos.org/registry/vulkan/specs/1.0/man/html/VkInstanceCreateInfo.html
final class InstanceCreateInfoBuilder {
  //does any of this stuff need to be released? 
  private let sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO
  //var pNext: //is a void pointer no idea what it's for 
  private let flags: UInt32 = 0 //not sure why you can even set this it has to be 0
  var applicationInfo: UnsafePointer<VkApplicationInfo>? //not required but useful?
  var enabledLayerCount: UInt32 = 0 //not required
  var enabledLayerNames: [UnsafePointer<Int8>?]! //this get bridged automatically as a function call but not as a property being set
  var enabledExtensionCount: UInt32 = 0 //required I think
  var enabledExtensionNames: UnsafePointer<UnsafePointer<Int8>?>! 

  func build() -> VkInstanceCreateInfo {
//    var appInfo: UnsafePointer<VkApplicationInfo>?
//    if let applicationInfo = applicationInfo {
//      var applicationInfo = applicationInfo
//      appInfo = withUnsafePointer(to: &applicationInfo) { return $0 }
//    }
    return VkInstanceCreateInfo(sType: sType,
                                pNext: nil,
                                flags: flags,
                                pApplicationInfo: applicationInfo,
                                enabledLayerCount: enabledLayerCount,
                                ppEnabledLayerNames: enabledLayerNames,
                                enabledExtensionCount: enabledExtensionCount,
                                ppEnabledExtensionNames: enabledExtensionNames)
  }
}
