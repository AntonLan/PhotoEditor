//
//  MainView.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import Factory

struct MainView: View {
    
    @Injected(\.authService) private var authService
    @State private var viewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    if (viewModel.image != nil) {
                        DrawingScreenView()
                            .environment(\.mainVm, viewModel)
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo to get started"))
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button("Add photo") {
                                        viewModel.isShowingImagePicker = true
                                    }
                                }
                            }
                    }
                }
            }
            
            if viewModel.addNewBox {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                
                TextField("Type Here", text: $viewModel.textBoxes[viewModel.currentIndex].text)
                    .font(.system(size: 35, weight: viewModel.textBoxes[viewModel.currentIndex].isBold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundStyle(viewModel.textBoxes[viewModel.currentIndex].textColor)
                    .padding()
                
                HStack {
                    Button(action: {
                        viewModel.toolPicker.setVisible(true, forFirstResponder:
                                                            viewModel.canvas)
                        viewModel.canvas.becomeFirstResponder ()
                        
                        withAnimation {
                            viewModel.addNewBox = false
                        }
                    }, label: {
                        Text ("Add")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.cancelTextView()
                    }, label: {
                        Text ("Cancel")
                            .fontWeight (.heavy)
                            .foregroundColor (.white)
                            .padding()
                    })
                }
                .overlay (
                    HStack(spacing: 15) {
                        
                        ColorPicker("", selection: $viewModel.textBoxes[viewModel.currentIndex].textColor)
                            .labelsHidden()
                        
                        Button {
                            viewModel.textBoxes[viewModel.currentIndex].isBold.toggle()
                        } label: {
                            Text(viewModel.textBoxes[viewModel.currentIndex].isBold ? "Normal" : "Bold")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }

                    }
                )
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .navigationTitle("Photo Editor")
        .onChange(of: viewModel.inputImage, viewModel.loadImage)
        .sheet(isPresented: $viewModel.isShowingImagePicker) {
            ImagePicker(image: $viewModel.inputImage)
        }
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(title: Text("Message"), message: Text(viewModel.message),
            dismissButton: . destructive (Text ("Ok")))
        })
        .confirmationDialog("Select a filter", isPresented: $viewModel.showingFilterSheet) {
            Button("Crystallize") { viewModel.setFilter(CIFilter.crystallize()) }
            Button("Edges") { viewModel.setFilter(CIFilter.edges()) }
            Button("Gaussian Blur") { viewModel.setFilter(CIFilter.gaussianBlur()) }
            Button("Pixellate") { viewModel.setFilter(CIFilter.pixellate()) }
            Button("Sepia Tone") { viewModel.setFilter(CIFilter.sepiaTone()) }
            Button("Unsharp Mask") { viewModel.setFilter(CIFilter.unsharpMask()) }
            Button("Vignette") { viewModel.setFilter(CIFilter.vignette()) }
            Button("Cancel", role: .cancel) { }
        }
        .tint(.black)
    }
}


#Preview {
    MainView()
}
