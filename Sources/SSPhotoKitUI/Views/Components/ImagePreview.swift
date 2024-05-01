//
//  ImagePreview.swift
//  SSPhotoKitUI
//
//  Created by Krunal Patel on 09/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct ImagePreview<Overlay>: View where Overlay : View {
    
    @EnvironmentObject var model: EditorViewModel
    
    // MARK: - Vars & Lets
    let imageSource: ImageSource
    let centerOptions: CenterOptions
    let gesturesEnabled: Bool
    let overlay: Overlay?
    @State private var lastOffset: CGSize = .zero
    @State private var lastScale: CGSize = .zero
    
    var body: some View {
        
        GeometryReader { proxy in
            Group {
                switch imageSource {
                case .coreImage(let image):
                    MetalView(image: image)
                        .frame(width: imageSource.size.width, height: imageSource.size.height)
                case .platformImage(let image):
                    platformImagePreview(image, with: proxy)
                }
            }
            .preference(key: PreviewOffsetPreference.self, value: model.previewOffset)
            .preference(key: PreviewScalePreference.self, value: model.previewScale)
            .overlay {
                GeometryReader { innerProxy in
                    Color.clear
                        .preference(key: PreviewFramePreference.self, value: innerProxy.frame(in: .global))
                        .onAppear {
                            model.previewFrame = innerProxy.frame(in: .global)
                        }
                }
            }
            .overlay {
                overlay
            }
            .scaleEffect(model.previewScale, anchor: .zero)
            .offset(model.previewOffset)
            .onAppear {
                if centerOptions.contains(.initial) && model.isInitial {
                    resizeAndCenterImage(with: imageSource.size, to: proxy.size)
                    model.isInitial = false
                }
                lastOffset = model.previewOffset
            }
            .onChange(of: imageSource.size) { imageSize in
                if centerOptions.contains(.imageSizeChange) {
                    resizeAndCenterImage(with: imageSize, to: proxy.size)
                }
            }
            .onChange(of: proxy.size) { proxySize in
                if centerOptions.contains(.frameSizeChange) {
                    resizeAndCenterImage(with: imageSource.size, to: proxySize)
                }
            }
            .simultaneousGesture(dragGesture.simultaneously(with: magnificationGesture))
            .allowsHitTesting(gesturesEnabled)
        }
        .clipped()
    }
    
    @ViewBuilder
    private func platformImagePreview(_ image: PlatformImage, with proxy: GeometryProxy) -> some View {
        
        Image(platformImage: image)
    }
    
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
        DragGesture(coordinateSpace: .global)
            .onChanged { value in
                model.previewOffset = lastOffset + (value.translation)
            }
            .onEnded { value in
                lastOffset = model.previewOffset
            }
    }
    
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                model.previewScale = lastScale + CGSize(width: value, height: value)
            }
            .onEnded { _ in
                lastScale = CGSize(width: model.previewScale.width - 1, height: model.previewScale.height - 1)
            }
        
    }
    
}

// MARK: - Methods
extension ImagePreview {
    
    private func resizeAndCenterImage(with imageSize: CGSize, to proxySize: CGSize) {
        let ratio = proxySize / imageSize
        let minScale = min(ratio.width, ratio.height)
        model.previewScale = CGSize(width: minScale, height: minScale)
        let newSize = imageSize * model.previewScale
        model.previewOffset = (proxySize - newSize) / CGSize(width: 2, height: 2)
        lastOffset = model.previewOffset
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
