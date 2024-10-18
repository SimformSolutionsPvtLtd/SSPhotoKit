//
//  EditorViewModel.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif
import Combine

@MainActor
class EditorViewModel: ObservableObject {
    
    // MARK: - Vars & Lets
    @Published var currentEditor: Editor = .none
    @Published var isLoading: Bool = false
    
    @Published var previewScale: CGSize = .one
    @Published var previewOffset: CGSize = .zero
    @Published var previewFrame: CGRect = .zero
    @Published var previewSize: CGSize = .zero
    @Published var isInitial = true
    var lastOffset: CGSize = .zero
    var lastScale: CGSize = .zero
    var containerSize: CGSize = .zero
    
    var shouldShowTabBar: Bool {
        currentEditor == .none
    }
    
    // MARK: - Methods
    func resetEditor() {
        currentEditor = .none
        objectWillChange.send()
    }
}
