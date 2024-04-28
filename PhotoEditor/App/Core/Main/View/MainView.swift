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
                
                HStack {
                    Button(action: {}, label: {
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
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .navigationTitle("Photo Editor")
        .onChange(of: viewModel.inputImage, viewModel.loadImage)
        .sheet(isPresented: $viewModel.isShowingImagePicker) {
            ImagePicker(image: $viewModel.inputImage)
        }
        .confirmationDialog("Select a filter", isPresented: $viewModel.showingFilterSheet) {
            //dialog here
            Button("Crystallize") { viewModel.setFilter(CIFilter.crystallize()) }
            Button("Edges") { viewModel.setFilter(CIFilter.edges()) }
            Button("Gaussian Blur") { viewModel.setFilter(CIFilter.gaussianBlur()) }
            Button("Pixellate") { viewModel.setFilter(CIFilter.pixellate()) }
            Button("Sepia Tone") { viewModel.setFilter(CIFilter.sepiaTone()) }
            Button("Unsharp Mask") { viewModel.setFilter(CIFilter.unsharpMask()) }
            Button("Vignette") { viewModel.setFilter(CIFilter.vignette()) }
            Button("Cancel", role: .cancel) { }
        }
    }
}


#Preview {
    MainView()
}
