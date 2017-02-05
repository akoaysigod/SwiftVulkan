import CVulkan

final class ValidationLayers {
  let count: UInt32 
  let names: [UnsafePointer<Int8>?] 
  private let layers: [String]

  //is there a constant for this somewhere?
  init(layers: [String] = ["VK_LAYER_LUNARG_standard_validation"]) {
    self.layers = layers
    names = layers.cArray
    count = UInt32(layers.count)
  }

//  deinit {
//    for name in names {
//      name?.deinitialize(count: 1)
//      name?.deallocate(capacity: 1)
//    }
//  }

  func checkSupport() -> Bool {
    var layerCount: UInt32 = 0
    vkEnumerateInstanceLayerProperties(&layerCount, nil)
    var layerProperties = [VkLayerProperties](repeating: VkLayerProperties(), count: Int(layerCount))
    vkEnumerateInstanceLayerProperties(&layerCount, &layerProperties)

    //this is weird
    for validationName in layers {
      var layerFound = false
      for p in layerProperties {
        let layerName = String.make(from: p.layerName)
        if validationName == layerName {
          layerFound = true
          break
        }
      }

      if !layerFound {
        return false
      }
    }
    return true
  }
}
