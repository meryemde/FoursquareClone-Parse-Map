//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Meryem Demir on 14.10.2025.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var chosenLatitude = ""
    var chosenLongitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //pin ekleme
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }
    
    @objc func chooseLocation(gesture: UIGestureRecognizer) {
        
        if gesture.state == .began {
            let touchPoint = gesture.location(in: self.mapView)
            let coordinates = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlacesModel.sharedInstance.placeName
            annotation.subtitle = PlacesModel.sharedInstance.placeType
            self.mapView.addAnnotation(annotation)
            
            PlacesModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlacesModel.sharedInstance.placeLongitude = String(coordinates.longitude)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func saveButtonClicked() {
        //parse save
        let placeModel = PlacesModel.sharedInstance
        
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        if let imagedata = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpeg", data: imagedata)
        }
        
        object.saveInBackground { success, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
    }

    @objc func backButtonClicked() {
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    

}
