//
//  SSPhotoKitEngine.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreImage

@MainActor
public class SSPhotoKitEngine {
    
    // MARK: - Vars & Lets
    public let originalImage: CIImage
    @Published var previewImage: CIImage!
    @Published var previewCGImage: CGImage!
    
    public var canUndo: Bool {
        undoManager.canUndo
    }
    
    public var canRedo: Bool {
        undoManager.canRedo
    }
    
    private var editingStack = EditingCommandStack()
    private var redoStack: [AnyEditingCommand] = []
    private let undoManager = UndoManager()
    private let previewSize: CGSize
    
    private lazy var ciContext: CIContext = {
        if let device = MTLCreateSystemDefaultDevice() {
            return CIContext(mtlDevice: device)
        } else {
            EngineLogger.debug("Can't create Metal device, switching to default context.")
            return CIContext()
        }
    }()
    
    
    // MARK: - Public Methods
    public func apply<C: EditingCommand>(_ command: C) {
        editingStack.push(command.asAny())
        
        undoManager.registerUndo(withTarget: self) { [weak self] _ in
            guard let self else { return }

            redoStack.append(editingStack.pop())
        }
    }
    
    public func undo() {
        undoManager.undo()
    }
    
    public func redo() {
        undoManager.redo()
    }
    
    public func reset() {
        EngineLogger.info("Reseting engine to initial state.")
        initializeImages(with: previewSize)
        redoStack = editingStack.commands
        editingStack.removeAll()
    }
    
    // MARK: - Private Methods
    private func initializeImages(with size: CGSize) {
        previewImage = originalImage.resizing(size)
        if let cgImage = previewImage.cgImage ?? ciContext.createCGImage(previewImage, from: previewImage.extent) {
            previewCGImage = cgImage
        } else {
            EngineLogger.error("Failed to create CGImage.")
        }
    }
    
    // MARK: - Initializer
    public init(image: CIImage, previewSize: CGSize) {
        originalImage = image
        self.previewSize = previewSize
        initializeImages(with: previewSize)
    }
}
