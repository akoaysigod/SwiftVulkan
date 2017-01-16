import CVulkan

struct ValidationLayers {
  private let layers: [String]

  var count: UInt32 {
    return UInt32(layers.count)
  }

  var layerNames: [UnsafePointer<Int8>?] {
    return layers.flatMap { $0.withCString { return $0 } }
  }

  //is there a constant for this somewhere?
  init(layers: [String] = ["VK_LAYER_LUNARG_standard_validation"]) {
    self.layers = layers
  }

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
