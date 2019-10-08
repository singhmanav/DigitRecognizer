//
//  ViewController.swift
//  DigitRecognizer
//
//  Created by xeadmin on 13/11/17.
//  Copyright © 2017 manav. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var drawingCanvas: DigitView!
    @IBOutlet weak var resultLabel: UILabel!
    var imageToDetect:CIImage?
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func predictButtonPressed(_ sender: UIBarButtonItem) {
        self.predictDigit()
    }
    
    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        self.drawingCanvas.clear()
        self.imageToDetect = nil
        self.resultLabel.text = "Draw a number or tap on an image"
    }
    
    func predictDigit() -> Void{
        
        let scaledCanvasImage = self.drawingCanvas.imageWithImage(newSize: CGSize(width: 28, height: 28))
        
        self.imageToDetect = CIImage(image: scaledCanvasImage)
        let mlModel = keras_mnist_cnn().model
        let vnCoreMLModel = try! VNCoreMLModel(for: mlModel)
        let request = VNCoreMLRequest(model: vnCoreMLModel) { (request, error) in
            let results = request.results
            let res = results![0] as! VNCoreMLFeatureValueObservation
            var prediction : NSNumber = 0
            var compare : NSNumber = 0
            var atIndex = 0
            
            for i in 0..<res.featureValue.multiArrayValue!.count{
                compare = res.featureValue.multiArrayValue![i]
                if compare.floatValue > prediction.floatValue {
                    prediction = compare
                    atIndex = i
                }
            }
            self.resultLabel.text = "Digit may be \(atIndex)"
        }
        let optionsDict = Dictionary<VNImageOption, Any>()
        let requestArray = [request]
        let handler = VNImageRequestHandler(ciImage: self.imageToDetect!, options: optionsDict)
        self.resultLabel.text = "Predicting..."
        try! handler.perform(requestArray)
    }
    
    func imageWithImage(image:UIImage, newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
        
    }
    
}

extension UIView {
    func imageWithImage(newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        drawHierarchy(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height), afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil) {
            return image!
        }
        
        return UIImage()
    }
    
}


