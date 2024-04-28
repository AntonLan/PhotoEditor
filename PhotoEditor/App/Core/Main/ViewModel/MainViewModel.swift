//
//  MainViewModel.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 28.04.2024.
//

import Foundation
import SwiftUI
import Observation
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import PencilKit
import Factory

@Observable
final class MainViewModel {
    var image: Image?
    var filterIntensity = 0.8
    var isShowingImagePicker = false
    var inputImage: UIImage?
    var processedImage: UIImage?
    var currentFilter: CIFilter = CIFilter.sepiaTone()
    var showingFilterSheet = false
    var canvas = PKCanvasView()
    var toolPicker = PKToolPicker()
    var textBoxes: [TextBox] = []
    var addNewBox = false
    var currentIndex = 0
    var rect: CGRect = .zero
    
    var showAlert = false
    var message = ""
    
    @ObservationIgnored
    let context = CIContext()
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func cancel() {
        image = nil
        inputImage = nil
        canvas = PKCanvasView()
    }
    
    func cancelTextView() {
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        
        withAnimation {
            addNewBox = false
        }
        
        textBoxes.removeLast()
    }
    
    func saveImage() {
        UIGraphicsBeginImageContextWithOptions (rect.size, false, 0)
        canvas.drawHierarchy (in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates:true)
        
        let SwiftUIView = ZStack{
            ForEach(textBoxes) { [self] box in
                Text(textBoxes[currentIndex].id == box.id && addNewBox ? "" : box.text)
                    .font(.system(size: 30))
                    .fontWeight(box.isBold ? .bold : .none)
                    .foregroundColor(box.textColor)
                    .offset(box.lastOffset)
            }
        }
        
        let controller = UIHostingController (rootView: SwiftUIView).view!
        controller.frame = rect
        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        controller.backgroundColor = .clear
        canvas.backgroundColor = .clear
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = generatedImage{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            print ("success..." )
            message = "Saved Successfully !!!"
            showAlert.toggle()
        }
        cancel()
    }
}

struct MainVmKey: EnvironmentKey {
    static var defaultValue: MainViewModel = MainViewModel()
}

extension EnvironmentValues {
    var mainVm: MainViewModel {
        get { self[MainVmKey.self] }
        set { self[MainVmKey.self] = newValue }
    }
}
