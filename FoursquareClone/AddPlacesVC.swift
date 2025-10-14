//
//  AddPlacesVC.swift
//  FoursquareClone
//
//  Created by Meryem Demir on 14.10.2025.
//

import UIKit

class AddPlacesVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeAtmosphereText: UITextField!
   
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosenImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    @objc func choosenImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if placeNameText.text != "" && placeTypeText.text != "" && placeAtmosphereText.text != "" {
            if let choosenImage = imageView.image {
                PlacesModel.sharedInstance.placeName = placeNameText.text!
                PlacesModel.sharedInstance.placeType = placeTypeText.text!
                PlacesModel.sharedInstance.placeAtmosphere = placeAtmosphereText.text!
                PlacesModel.sharedInstance.placeImage = choosenImage
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Place Name/Type/Atmosphere??", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    
        
    }
    
    

}
