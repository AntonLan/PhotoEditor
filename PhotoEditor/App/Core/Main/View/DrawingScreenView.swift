//
//  DrawingScreenView.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 28.04.2024.
//

import SwiftUI
import PencilKit
import PhotosUI

struct DrawingScreenView: View {
    @Environment(\.mainVm) private var viewModel: MainViewModel
    var body: some View {
        @Bindable var viewModel = viewModel
        ZStack {
            GeometryReader { proxy -> AnyView in
                let size = proxy.frame(in: .global).size
                DispatchQueue.main.async {
                    if viewModel.rect == .zero {
                        viewModel.rect = proxy.frame (in: .global)
                    }
                }
                
                return AnyView(
                    ZStack {
                        CanvasView(
                            canvas: $viewModel.canvas,
                            inputImage: $viewModel.processedImage,
                            toolPicker: $viewModel.toolPicker,
                            size: size
                        )
                        
                        ForEach(viewModel.textBoxes) { box in
                            Text(viewModel.textBoxes[viewModel.currentIndex].id == box.id &&
                                 viewModel.addNewBox ? "" : box.text)
                            .font(.system(size: 30))
                            .fontWeight(box.isBold ? .bold : .none)
                            .foregroundColor(box.textColor)
                            .offset(box.offset)
                            .gesture(
                                DragGesture().onChanged { value in
                                    let current = value.translation
                                    let lastOffset = box.lastOffset
                                    let newTranslation = CGSize(
                                        width: lastOffset.width + current.width,
                                        height: lastOffset.height + current.height
                                    )
                                    viewModel.textBoxes[getIndex(textBox: box)].offset = newTranslation
                                }
                                    .onEnded({ value in
                                        viewModel.textBoxes[getIndex(textBox: box)].lastOffset = viewModel.textBoxes[getIndex(textBox: box)].offset
                                    })
                            )
                        }
                    }
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: viewModel.cancel) {
                    Image(systemName: "xmark")
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button("Change Filter") {
                    viewModel.showingFilterSheet = true
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: viewModel.saveImage)
                    .disabled(viewModel.image == nil)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                    viewModel.textBoxes.append(TextBox())
                    viewModel.currentIndex = viewModel.textBoxes.count - 1
                    withAnimation {
                        viewModel.addNewBox.toggle()
                    }
                    viewModel.toolPicker.setVisible(false,
                                                    forFirstResponder: viewModel.canvas)
                    viewModel.canvas.resignFirstResponder()
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
    }
    
    func getIndex (textBox: TextBox) -> Int {
        let index = viewModel.textBoxes.firstIndex { (box) -> Bool in
            return textBox.id == box.id
        } ?? 0
        return index
    }
}

#Preview {
    MainView()
}
