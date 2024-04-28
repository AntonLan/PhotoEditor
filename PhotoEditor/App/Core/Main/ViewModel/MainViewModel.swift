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
    
    @ObservationIgnored
    @Injected(\.authService) private var authService
    
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
        guard let processedImage = processedImage else { return }
        
        let renderer = UIGraphicsImageRenderer(size: processedImage.size)
        let img = renderer.image { ctx in
            processedImage.draw(in: CGRect(origin: .zero, size: processedImage.size))
            for box in textBoxes {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                    
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 30),
                    .paragraphStyle: paragraphStyle,
                    .foregroundColor: UIColor(box.textColor)
                ]
                    
                let string = NSAttributedString(string: box.text, attributes: attrs)
                let rect = CGRect(x: box.lastOffset.width, y: box.lastOffset.height, width: 200, height: 200)
                ctx.cgContext.saveGState()
                ctx.cgContext.translateBy(x: rect.origin.x, y: rect.origin.y)
                string.draw(with: CGRect(origin: .zero, size: rect.size), options: .usesLineFragmentOrigin, context: nil)
                ctx.cgContext.restoreGState()
            }
            
            let format = UIGraphicsImageRendererFormat.default()
            format.scale = UIScreen.main.scale
            let bounds = canvas.bounds
            let renderer = UIGraphicsImageRenderer(bounds: bounds, format: format)
            let image = renderer.image { (context) in
                canvas.drawHierarchy(in: bounds, afterScreenUpdates: true)
            }
            image.draw(in: CGRect(origin: .zero, size: processedImage.size))
        }
            
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        print("success...")
        message = "Saved Successfully !!!"
        showAlert.toggle()
        cancel()
    }
    
    func singOut() {
        authService.singOut()
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
