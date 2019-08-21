//
//  AddProductScreen.swift
//  StoreUpload
//
//  Created by Kylee Krzanich on 3/30/19.
//  Copyright © 2019 Kylee Krzanich. All rights reserved.
//

import UIKit
import Alamofire

class AddProductScreen: AltBGView , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var productQuantity: UITextField!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productCatagory: UITextField!
    
    var authToken: String = ""
    let catagories = ["", "Resistors", "Capacitors", "Inductors", "Crystals", "Amplifiers", "Digital to Analog Converters", "Analog to Digital Converters", "Clocks and Timers", "Switches", "Memory", "Logic", "Voltage Regulators", "Sensors", "Transistors", "Diodes", "Motors", "Relays", "Buttons", "Actuators", "LEDs", "Displays", "Photodiodes", "Connectors", "Plugs and Sockets", "Microcontrollers", "FPGAs", "Prototyping", "Adhesives", "Plastics", "Metals", "Wood and Particleboard", "Wire", "3D Printing", "Screws", "Class Kits", "Cables", "Tools"]
    var catagoryIDs = ["": 2,
                       "Tools": 11,
                       "Resistors": 21,
                       "Capacitors": 20, //sensors 60
                       "Inductors": 22,  //microcontroller also 24 plugs and sockets 43
                       "Crystals": 100,
                       "Amplifiers": 23,
                       "Digital to Analog Converters": 25,
                       "Analog to Digital Converters": 26,
                       "Clocks and Timers": 27,
                       "Switches": 28,
                       "Memory": 30,
                       "Logic": 31,
                       "Voltage Regulators":32,
                       "Sensors": 67,
                       "Transistors": 36,
                       "Diodes": 37,
                       "Motors": 52,
                       "Relays": 54,
                       "Buttons": 55,
                       "Actuators": 99,
                       "LEDs": 46,
                       "Displays": 70,
                       "Photodiodes": 48,
                       "Connectors": 41,
                       "Plugs and Sockets": 43,
                       "Microcontrollers": 88,
                       "FPGAs": 89,
                       "Prototyping": 90,
                       "Adhesives": 71,
                       "Plastics": 73,
                       "Metals": 74,
                       "Wood and Particleboard": 75,
                       "Wire": 77,
                       "3D Printing": 78,
                       "Screws": 79,
                       "Class Kits": 76,
                       "Cables": 85]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        productImage.isUserInteractionEnabled = true
        productImage.addGestureRecognizer(tapGestureRecognizer)
        let pickerView = UIPickerView()
        pickerView.delegate = self
        productCatagory.inputView = pickerView
    }
        


        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return catagories.count
        }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return catagories[row]
        }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            productCatagory.text = catagories[row]
        }
    

    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        self.present(imagePickerController,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        productImage.image = imageOrientation(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadProduct(_ sender: UIBarButtonItem) {
        self.createSpinnerView()
        
        print(self.authToken)
        let name: String = productName?.text ?? ""
        let quantity: String = productQuantity?.text ?? "0"
        let price: String = productPrice?.text ?? "0.0"
        let catagory: String = productCatagory?.text ?? ""
        let catagoryID: Int = catagoryIDs[catagory] ?? 2
        
        let head: HTTPHeaders = [
            "Authorization": "Bearer \(self.authToken)",
            "Content-Type": "application/json"
        ]

        let parameters: Parameters = [
            "product": [
                "type_id": "simple",
                "attribute_set_id": 4,
                "extension_attributes": ["stock_item": ["qty": Int(quantity) ?? 0, "is_in_stock": true]],
                "sku": name,
                "name": name,
                "price": Float(price) ?? 0.0,
                "media_gallery_entries": [
                    [
                        "content": [
                            "base64_encoded_data": productImage.image?.jpegData(compressionQuality: 0.1)?.base64EncodedString(),
                            "type": "image/jpeg",
                            "name": "\(name).jpg"
                        ],
                        "disabled": false,
                        "label": name,
                        "media_type": "image",
                        "position": 0,
                        "types": ["thumbnail", "small_image", "image", "swatch_image"],
                    ]
                ]
            ]
        ]

        Alamofire.request("https://makerstore.stanford.edu/rest/V1/products", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: head).responseJSON{ response in
            self.removeSpinnerView()
            if response.result.isSuccess {
                debugPrint(response)
                self.moveProduct(catagory: catagoryID, product: name)
                let alertController = UIAlertController(title: "Product Uploaded!", message: "\"\(name)\" has been successfully uploaded to the store.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) -> Void in
                    self.performSegue(withIdentifier: "returnHome", sender: self)
                }))
                self.present(alertController, animated: true, completion: nil)
            } else{
                let alertController = UIAlertController(title: "Error", message: "Something went wrong. Please check your entries and internet connection.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func moveProduct(catagory: Int, product: String) {
        let head: HTTPHeaders = [
            "Authorization": "Bearer \(self.authToken)",
            "Content-Type": "application/json"
        ]
        let params: Parameters = [
            "productLink": ["sku": product,
                            "position": 0,
                            "category_id": String(catagory)]]
        let makerstore_request: String = "https://makerstore.stanford.edu/rest/V1/categories/" + String(catagory) + "/products";
        Alamofire.request(makerstore_request, method: .post, parameters: params, encoding: JSONEncoding.default, headers: head).responseJSON{ res in
            if res.result.isSuccess { debugPrint(res)}}
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomeScreen {
            let vc = segue.destination as? HomeScreen
            vc?.authToken = self.authToken
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func imageOrientation(_ src:UIImage)-> UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }
        
        switch src.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch src.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
    
}
