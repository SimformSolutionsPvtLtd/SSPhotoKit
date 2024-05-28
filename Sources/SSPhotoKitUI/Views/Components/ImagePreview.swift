//
//  ImagePreview.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 09/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct ImagePreview<Overlay>: View where Overlay: View {
    
    // MARK: - Vars & Lets
    @EnvironmentObject private var model: EditorViewModel
    let imageSource: ImageSource
    let centerOptions: CenterOptions
    let gesturesEnabled: Bool
    let overlay: Overlay?
    
    // MARK: - Body
    var body: some View {
        
        GeometryReader { proxy in
            Group {
                switch imageSource {
                case .coreImage(let image):
                    MetalView(image: image)
                        .frame(width: imageSource.size.width, height: imageSource.size.height)
                case .platformImage(let image):
                    Image(platformImage: image)
                }
            }
            .preference(key: PreviewOffsetPreference.self, value: model.previewOffset)
            .preference(key: PreviewScalePreference.self, value: model.previewScale)
            .overlay {
                overlay
            }
            .offset(model.previewOffset)
            .scaleEffect(model.previewScale, anchor: .center)
            .overlay {
                GeometryReader { innerProxy in
                    Color.clear
                        .preference(key: PreviewFramePreference.self, value: innerProxy.frame(in: .global))
                        .onAppear {
                            model.previewFrame = innerProxy.frame(in: .global)
                        }
                }
            }
            .onAppear {
                model.containerSize = proxy.size
                if centerOptions.contains(.initial) && model.isInitial {
                    resizeAndCenterImage(with: imageSource.size, to: proxy.size)
                    model.isInitial = false
                }
                model.lastOffset = model.previewOffset
            }
            .onChange(of: imageSource.size) { imageSize in
                if centerOptions.contains(.imageSizeChange) {
                    resizeAndCenterImage(with: imageSize, to: proxy.size)
                }
            }
            .onChange(of: proxy.size) { proxySize in
                model.containerSize = proxySize
                if centerOptions.contains(.frameSizeChange) {
                    resizeAndCenterImage(with: imageSource.size, to: proxySize)
                }
            }
        }
        .contentShape(.rect)
        .simultaneousGesture(dragGesture.simultaneously(with: magnificationGesture))
        .allowsHitTesting(gesturesEnabled)
        .clipped()
    }
    
    // MARK: - Initializer
    init(imageSource: ImageSource, gesturesEnabled: Bool = true, centerOptions: CenterOptions = [], @ViewBuilder overlay: () -> Overlay) {
        self.imageSource = imageSource
        self.centerOptions = centerOptions
        self.gesturesEnabled = gesturesEnabled
        self.overlay = overlay()
    }
    
    init(imageSource: ImageSource, gesturesEnabled: Bool = true, centerOptions: CenterOptions = []) where Overlay == EmptyView {
        self.imageSource = imageSource
        self.centerOptions = centerOptions
        self.gesturesEnabled = gesturesEnabled
        self.overlay = nil
    }
}

// MARK: - Gestures
extension ImagePreview {
    
    private var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .local)
            .onChanged { value in
                // Calculation - ((image size - frame size / scale) / 2) - abs(offset) > 0
                var centerOffset = model.lastOffset + (value.translation / model.previewScale)
                let imageSize = imageSource.size
                let scaledFrameSize = model.containerSize / model.previewScale
                // Initial height offset. Same way used to center the image.
                let initialCenteringOffset = (scaledFrameSize - (imageSource.size / model.previewScale)) / CGSize(width: 2, height: 2)
                let availableOffset = abs(scaledFrameSize - imageSize) / CGSize(width: 2, height: 2)
                let offsetFromCenter = abs(centerOffset - initialCenteringOffset)
                print(offsetFromCenter)
                if availableOffset.width - offsetFromCenter.width < -40 {
                    centerOffset.width = model.previewOffset.width
                }

                if availableOffset.height - offsetFromCenter.height < -40 {
                    centerOffset.height = model.previewOffset.height
                }
                model.previewOffset = centerOffset
            }
            .onEnded { _ in
                model.lastOffset = model.previewOffset
            }
    }
    
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let newScale = (CGSize(width: value - 1, height: value - 1) * model.lastScale)
                let newValue = model.lastScale + newScale
                guard newValue.width > 0.05, newValue.height > 0.05 else { return }
                model.previewScale = newValue
            }
            .onEnded { _ in
                model.lastScale = CGSize(width: model.previewScale.width, height: model.previewScale.height)
            }
    }
}

// MARK: - Methods
extension ImagePreview {
    
    private func resizeAndCenterImage(with imageSize: CGSize, to proxySize: CGSize) {
        let ratio = proxySize / imageSize
        let minScale = min(ratio.width, ratio.height)
        model.previewScale = CGSize(width: minScale, height: minScale)
        model.lastScale = model.previewScale
        model.previewOffset = (proxySize - imageSize) / model.previewScale / CGSize(width: 2, height: 2)
        model.lastOffset = model.previewOffset
    }
}

// MARK: - Enums
extension ImagePreview {
    
    // MARK: - ImageSource
    enum ImageSource {
        case coreImage(Binding<CIImage>)
        case platformImage(PlatformImage)
    }
}

// MARK: - Image Center Options
struct CenterOptions: OptionSet {
    
    var rawValue: UInt32
    
    static let initial = CenterOptions(rawValue: 1 << 0)
    static let imageSizeChange = CenterOptions(rawValue: 1 << 1)
    static let frameSizeChange = CenterOptions(rawValue: 1 << 2)
    static let always: CenterOptions = [.initial, .imageSizeChange, .frameSizeChange]
}

// MARK: - ImagePreview.ImageSource + Extension
extension ImagePreview.ImageSource {
    
    var size: CGSize {
        switch self {
        case .coreImage(let coreImage):
            coreImage.wrappedValue.extent.size
        case .platformImage(let platformImage):
            platformImage.size
        }
    }
}
