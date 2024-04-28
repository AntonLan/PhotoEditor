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
    
    @ObservationIgnored
    let context = CIContext()
    
    
    func save() {
        guard let processedImage = processedImage else { return }
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success!")
        }
        
        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
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
        UIGraphicsBeginImageContextWithOptions (rect.size, false, 1)
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = generatedImage{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            print ("success..." )
        }
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
