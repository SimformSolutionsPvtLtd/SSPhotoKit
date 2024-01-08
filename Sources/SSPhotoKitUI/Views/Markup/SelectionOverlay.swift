//
//  SwiftUIView.swift
//  
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct SelectionOverlay: View {
    
    // MARK: - Vars & Lets
    @Binding var currentRotation: CGFloat
    @Binding var currentSize: CGSize
    var keepAspectRatio: Bool = true
    let onUpdate: (SelectionAction) -> Void
    
    @State private var lastRotation: CGFloat = 0
    @State private var lastSize: CGSize = .zero
    
    // MARK: - Body
    var body: some View {
        Color.clear
            .overlay(alignment: .topLeading) {
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
            .overlay(alignment: .bottomLeading) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundStyle(.blue)
                    .padding(6)
                    .background(.white)
                    .clipShape(Circle())
                    .frame(width: 36, height: 36)
                    .offset(x: -18, y: 18)
                    .gesture(rotationGesture)
            }
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .foregroundStyle(.blue)
                    .padding(6)
                    .background(.white)
                    .clipShape(Circle())
                    .frame(width: 36, height: 36)
                    .offset(x: 18, y: 18)
                    .gesture(magnificationGesture)
            }
            .overlay(alignment: .topTrailing) {
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
            .onEnded { value in
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
            .onEnded { value in
                lastSize = currentSize
            }
    }
}

enum SelectionAction {
    case delete
    case rotate(CGFloat)
    case edit
    case magnify
}
