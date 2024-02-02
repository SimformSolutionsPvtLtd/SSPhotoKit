//
//  File.swift
//  
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI
import SSPhotoKitEngine
import Combine

@MainActor
class EditorViewModel : ObservableObject {
    
    // MARK: - Vars & Lets
    @Published var currentEditor: Editor = .none
    var can: Set<AnyCancellable> = []
    
    
    var shouldShowTabBar: Bool {
        currentEditor == .none
    }
    
    let editors = Array(Editor.allCases.filter { $0 != .none })
    
    // MARK: - Methods
    func resetEditor() {
        currentEditor = .none
    }
    
//    // MARK: - Initializer
//    init(image: CIImage, previewSize: CGSize) {
//        self.engine = SSPhotoKitEngine(image: image, previewSize: previewSize)
//    }
}
