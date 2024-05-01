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
    @Published var isLoading: Bool = false
    
    @Published var previewScale: CGSize = .one
    @Published var previewOffset: CGSize = .zero
    @Published var previewFrame: CGRect = .zero
    @Published var isInitial = true
    
    var shouldShowTabBar: Bool {
        currentEditor == .none
    }
    
    // MARK: - Methods
    func resetEditor() {
        currentEditor = .none
        objectWillChange.send()
    }
    
//    // MARK: - Initializer
//    init(image: CIImage, previewSize: CGSize) {
//        self.engine = SSPhotoKitEngine(image: image, previewSize: previewSize)
//    }
}
