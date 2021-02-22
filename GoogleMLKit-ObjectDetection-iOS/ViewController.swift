//
//  ViewController.swift
//  GoogleMLKit-ObjectDetection-iOS
//
//  Created by Daisuke TONOSAKI on 2021/02/22.
//

import UIKit
import PhotosUI

import MLKit


// refs:
// https://developers.google.com/ml-kit/guides
// https://developers.google.com/ml-kit/vision/object-detection/ios

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: OverlayView!
    private var objectDetector: ObjectDetector?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setup object detector.
        let options = ObjectDetectorOptions()
        options.detectorMode = .singleImage
        options.shouldEnableMultipleObjects = true
        options.shouldEnableClassification = true
        
        objectDetector = ObjectDetector.objectDetector(options: options)
    }
    
    
    @IBAction func selectImageAction() {
        openPhotoPicker()
    }
    
    
    func openPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    
    func objectDetectorProcess(image: UIImage) {
        guard let objectDetector = objectDetector else {
            return
        }
        
        
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        objectDetector.process(visionImage) { detectedObjects, error in
            guard error == nil else {
                return
            }
            
            guard let detectedObjects = detectedObjects,
                  !detectedObjects.isEmpty else {
                return
            }
            
            
            DispatchQueue.main.async {
                self.setupOverlayView(image: image, detectedObjects: detectedObjects)
            }
        }
        
    }
    
    
    func setupOverlayView(image: UIImage, detectedObjects: [Object]) {
        let colorArray: [UIColor] = [
            .red,
            .green,
            .blue,
            .yellow,
            .magenta,
            .cyan,
            .black,
        ]
        
                
        for i in 0..<detectedObjects.count {
            let convertedRect = self.imageView.convertRect(fromImageRect: detectedObjects[i].frame)
            let overlayObject: OverlayObject = OverlayObject(rect: convertedRect,
                                                             color: colorArray[i % colorArray.count])
            
            overlayView.overlayObjects.append(overlayObject)
        }
        
        overlayView.setNeedsDisplay()
    }

}


extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first,
              result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
            guard let image = image as? UIImage else {
                return
            }
            
            
            DispatchQueue.main.async {
                self.imageView.image = image
                
                self.overlayView.overlayObjects = []
                self.overlayView.setNeedsDisplay()
                
                self.objectDetectorProcess(image: image)
            }
        }
    }
    
}
