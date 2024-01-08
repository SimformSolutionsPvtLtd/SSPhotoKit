//
//  SwiftUIView.swift
//  
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI

struct SSSlider<V, StartLabel, EndLabel>: View where V: BinaryFloatingPoint, V.Stride : BinaryFloatingPoint, StartLabel: View, EndLabel: View {
    
    @Binding var value: V
    var range: ClosedRange<V>
    let step: V.Stride
    @State private var thumbPosition: CGFloat = 0
    @State var dragging: Bool = false
    
    let padding: CGFloat = 16
    private var height: CGFloat { startingLabel == nil && trailingLabel == nil ? 20 : 40 }
    
    let onEditingChanged: (Bool) -> Void
    var startingLabel: StartLabel?
    var trailingLabel: EndLabel?
    
    
    // MARK: - Body
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 4) {
                HStack {
                    startingLabel
                    Spacer()
                    trailingLabel
                }
                
                ZStack {
                    Capsule()
                        .fill(.gray.opacity(0.6))
                        .overlay(alignment: .leading) {
                            Capsule()
                                .fill(.white)
                                .frame(width: getPerfectProgress() * proxy.size.width)
                        }
                        .frame(height: Sizes.sliderHeight)
                    
                    Circle()
                        .frame(width: Sizes.thumbSize, height: Sizes.thumbSize)
                        .position(x: thumbPosition)
                        .offset(y: Sizes.thumbSize / 2)
                        .gesture(getDragGesture(width: proxy.size.width))
                }
                .frame(height: Sizes.thumbSize)
                .onChange(of: value) { _ in
                    self.thumbPosition = getPerfectProgress() * proxy.size.width
                }
                .onAppear {
                    self.thumbPosition = getPerfectProgress() * proxy.size.width
                }
            }
        }
        .padding(.horizontal, padding)
        .frame(height: height)
    }
    
    // MARK: - Initializer
    init(value: Binding<V>, in range: ClosedRange<V> = 0...1, step: V.Stride = 1, startingLabel: @escaping () -> StartLabel, trailingLabel: @escaping () -> EndLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._value = value
        self.range = range
        self.step = step
        self.startingLabel = startingLabel()
        self.trailingLabel = trailingLabel()
        self.onEditingChanged = onEditingChanged
    }
}

// MARK: - Gestures
extension SSSlider {
    
    private func getDragGesture(width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0.5, coordinateSpace: .local)
            .onChanged { dragValue in
                if dragging == false {
                    onEditingChanged(true)
                    dragging = true
                }
                thumbPosition = dragValue.location.x.clamped(to: 0...(width))
                value = V(thumbPosition / width) * (range.upperBound - range.lowerBound) + range.lowerBound
            }
            .onEnded { _ in
                onEditingChanged(false)
                dragging = false
            }
    }
    
    enum GestureProgress {
        case started
        case changed(DragGesture.Value)
        case ended
    }
}

// MARK: - Methods
extension SSSlider {
    
    private func getPerfectProgress() -> CGFloat {
        CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
    }
}

// MARK: - Initializers
extension SSSlider {
    
    init(value: Binding<V>, in range: ClosedRange<V> = 0...1, step: V.Stride = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where StartLabel == EmptyView, EndLabel == EmptyView {
        self._value = value
        self.range = range
        self.step = step
        self.startingLabel = nil
        self.trailingLabel = nil
        self.onEditingChanged = onEditingChanged
    }
    
    init(value: Binding<V>, in range: ClosedRange<V> = 0...1, step: V.Stride = 1, startingLabel: @escaping () -> StartLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where EndLabel == EmptyView {
        self._value = value
        self.range = range
        self.step = step
        self.startingLabel = startingLabel()
        self.trailingLabel = nil
        self.onEditingChanged = onEditingChanged
    }
    
//    init(value: Binding<V>, in range: ClosedRange<V> = 0...1, step: V.Stride = 1, trailingLabel: @escaping () -> EndLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where StartLabel == EmptyView {
//        self._value = value
//        self.range = range
//        self.step = step
//        self.startingLabel = nil
//        self.trailingLabel = trailingLabel()
//        self.onEditingChanged = onEditingChanged
//    }
}
