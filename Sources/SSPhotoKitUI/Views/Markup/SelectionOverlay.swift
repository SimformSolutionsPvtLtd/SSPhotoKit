//
//  SelectionOverlay.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct SelectionOverlay: View {
    
    // MARK: - Vars & Lets
    @Binding var currentRotation: CGFloat
    @Binding var currentSize: CGSize
    var keepAspectRatio: Bool = true
    var options: SelectionOptions = .all
    let onUpdate: (Action) -> Void
    
    @State private var lastRotation: CGFloat = 0
    @State private var lastSize: CGSize = .zero
    
    // MARK: - Body
    var body: some View {
        Color.clear
            .overlay(alignment: .topLeading) {
                if options.contains(.delete) {
                    Button {
                        onUpdate(.delete)
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .clipShape(Circle())
                    .frame(width: 36, height: 36)
                    .offset(x: -18, y: -18)
                    .foregroundStyle(.blue)
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                }
            }
            .overlay(alignment: .bottomLeading) {
                if options.contains(.rotate) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundStyle(.blue)
                        .padding(6)
                        .background(.white)
                        .clipShape(Circle())
                        .frame(width: 36, height: 36)
                        .offset(x: -18, y: 18)
                        .gesture(rotationGesture)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if options.contains(.magnify) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .foregroundStyle(.blue)
                        .padding(6)
                        .background(.white)
                        .clipShape(Circle())
                        .frame(width: 36, height: 36)
                        .offset(x: 18, y: 18)
                        .gesture(magnificationGesture)
                }
            }
            .overlay(alignment: .topTrailing) {
                if options.contains(.edit) {
                    Button {
                        onUpdate(.edit)
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .clipShape(Circle())
                    .frame(width: 36, height: 36)
                    .offset(x: 18, y: -18)
                    .foregroundStyle(.blue)
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                }
            }
            .onAppear {
                lastSize = currentSize
            }
    }
}

// MARK: - Gestures
extension SelectionOverlay {
    
    private var rotationGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { value in
                onUpdate(.rotate(-value.translation.height + lastRotation))
                currentRotation = -value.translation.height + lastRotation
            }
            .onEnded { _ in
                lastRotation = currentRotation
            }
    }
    
    private var magnificationGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { value in
                var translation: CGSize
                if keepAspectRatio {
                    let size = value.translation.width + value.translation.height
                    translation = CGSize(width: size, height: size)
                } else {
                    translation = CGSize(width: 2, height: 2) * value.translation
                }
                
                let newSize = lastSize + translation
                guard newSize.width > 1 && newSize.height > 1 else {
                    return
                }
                
                currentSize = newSize
            }
            .onEnded { _ in
                lastSize = currentSize
            }
    }
}

// MARK: - SelectionOverlay + Enums
extension SelectionOverlay {
    
    // MARK: - SelectionAction
    enum Action {
        case delete
        case rotate(CGFloat)
        case edit
        case magnify
    }
}

// MARK: - SelectionOverlay + Options
extension SelectionOverlay {
    
    // MARK: - SelectionAction
    struct SelectionOptions: OptionSet {
        
        var rawValue: UInt32
        
        static let delete = SelectionOptions(rawValue: 1 << 0)
        static let rotate = SelectionOptions(rawValue: 1 << 1)
        static let edit = SelectionOptions(rawValue: 1 << 2)
        static let magnify = SelectionOptions(rawValue: 1 << 3)
        
        static let all: SelectionOptions = [.delete, .rotate, .edit, .magnify]
        
    }
}
