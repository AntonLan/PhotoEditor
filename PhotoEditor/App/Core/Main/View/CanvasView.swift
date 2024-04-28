//
//  CanvasView.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 28.04.2024.
//

import Foundation
import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var inputImage: UIImage?
    @Binding var toolPicker: PKToolPicker
    var size: CGSize
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        
        let imageView = UIImageView(image: inputImage)
        imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tag = 999
        let subView = canvas.subviews[0]
        subView.addSubview(imageView)
        subView.sendSubviewToBack(imageView)


        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if let subView = uiView.subviews.first,
           let imageView = subView.viewWithTag(999) as? UIImageView {
            imageView.image = inputImage
        }
    }
}
