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
                
                return AnyView(
                    ZStack {
                        CanvasView(
                            canvas: $viewModel.canvas,
                            inputImage: $viewModel.processedImage,
                            toolPicker: $viewModel.toolPicker,
                            size: size
                        )
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
                Button("Save", action: viewModel.save)
                    .disabled(viewModel.image == nil)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
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
}

#Preview {
    MainView()
}
