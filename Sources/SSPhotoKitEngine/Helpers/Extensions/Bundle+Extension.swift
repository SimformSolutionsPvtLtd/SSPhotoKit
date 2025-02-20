//
//  Bundle+Extension.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 16/01/24.
//

import Foundation

#if !SPM
extension Bundle {
  static var module: Bundle {
      Bundle(for: BundleFinder.self)
  }
}

private class BundleFinder {
    private init() { }
}
#endif
