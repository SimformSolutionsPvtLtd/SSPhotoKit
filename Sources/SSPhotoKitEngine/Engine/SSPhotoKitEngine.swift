//
//  SSPhotoKitEngine.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreImage

@MainActor
public class SSPhotoKitEngine : ObservableObject {
    
    // MARK: - Vars & Lets
    public let originalImage: CIImage
    public var configuration: EngineConfiguration
    @Published public private(set) var previewImage: CIImage!
    @Published public private(set) var previewCGImage: CGImage?
    @Published public private(set) var previewPlatformImage: PlatformImage?
    
    public var canUndo: Bool {
        !editingStack.isEmpty
    }
    
    public var canRedo: Bool {
        !redoStack.isEmpty
    }
    
    public var canDiscard: Bool {
        !editingStack.isEmpty
    }
    
    public var canSave: Bool {
        !editingStack.isEmpty
    }
    
    private var editingStack = EditingCommandStack()
    private var redoStack = EditingCommandStack()
    private var originalPreviewImage: CIImage!
    
    private lazy var ciContext: CIContext = {
        if let device = MTLCreateSystemDefaultDevice() {
            return CIContext(mtlDevice: device, options: [.cacheIntermediates: false])
        } else {
            EngineLogger.debug("Can't create Metal device, switching to default context.")
            return CIContext(options: [.cacheIntermediates: false])
        }
    }()
    
    
    // MARK: - Public Methods
    public func apply<each C: EditingCommand>(_ commands: repeat each C) async {
        redoStack.removeAll()
        
        repeat editingStack.push((each commands).asAny())
        
        await updatePreviewImage()
    }
    
    public func undo() async {
        redoStack.push(editingStack.pop())
        await updatePreviewImage()
    }
    
    public func redo() async {
        editingStack.push(redoStack.pop())
        await updatePreviewImage()
    }
    
    public func reset() {
        Task {
            await initializeImages(with: configuration.previewSize)
            redoStack.removeAll()
            editingStack.removeAll()
        }
    }
    
    public func createImage() async -> CIImage {
        let scale = originalImage.size / originalPreviewImage.size
        var commands = editingStack.commands
        for i in commands.indices {
            commands[i].scale = scale
        }
        return await commands.apply(to: originalImage)
    }
    
    public func createPlatformImage() async -> PlatformImage? {
        let image = await createImage()
        guard let cgImage = ciContext.createCGImage(image, from: image.extent) else {
            return nil
        }
        
        return PlatformImage(cgImage: cgImage)
    }
    
    // MARK: - Private Methods
    private func initializeImages(with size: CGSize) async {
        originalPreviewImage = originalImage.resizing(size)
        previewImage = originalPreviewImage
        await updateImages()
    }
    
    private func updateImages() async {
        if let cgImage = previewImage.cgImage ?? ciContext.createCGImage(previewImage, from: previewImage.extent) {
            previewCGImage = cgImage
            previewPlatformImage = PlatformImage(cgImage: cgImage)
        } else {
            EngineLogger.error("Failed to create CGImage.")
        }
    }
    
    private func updatePreviewImage() async {
        previewImage = originalPreviewImage
        await editingStack.commands.asyncForEach { command in
            await previewImage = command.apply(to: previewImage)
        }
        await updateImages()
    }
    
    // MARK: - Initializer
    public init(image: CIImage, previewSize: CGSize, configuration: EngineConfiguration = .init(previewSize: .zero)) {
        self.configuration = configuration
        self.configuration.previewSize = previewSize
        originalImage = image
        Task {
            await initializeImages(with: previewSize)
        }
    }
}
