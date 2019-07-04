//
//  AddLocationController+MKViewDelegate.swift
//  On the Map
//
//  Created by António Ramos on 28/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit
import MapKit

extension AddLocationController: MKMapViewDelegate {
    
    //Set the custom pin image when looking for a location
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        mapLocalView.delegate = self
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "pin")
        annotationView!.image = pinImage
        annotationView?.centerOffset = CGPoint(x: 0, y: -pinImage!.size.height / 2)
        
        
        return annotationView
    }
    
    //Handle the response of the geocoder to set the place on the map
    
    func handleResponse(withPlacemark placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error as NSError? {
            self.handleErrorAlert(error: error)
            self.setActivityIndicator(animated: false)
        } else {
            var rawLocation: CLLocation?
            
            if let placemarks = placemarks {
                rawLocation = placemarks.first?.location
            }
            
            guard let location = rawLocation else {return}
            
            let latitude =    location.coordinate.latitude
            let longitude =   location.coordinate.longitude
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            DummyInfo.latitude =  latitude
            DummyInfo.longitude = longitude
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinates
            
            let mapCamera = MKMapCamera(
                lookingAtCenter: coordinates,
                fromDistance: 50,
                pitch: 0,
                heading: 0
            )
            
            self.whereAreYouLabel.fadeTransition(1)
            self.textField.text = ""
            self.mapLocalView.addAnnotation(annotation)
            self.mapLocalView.setCamera(mapCamera, animated: true)
            self.submitButton.setTitle("Submit", for: .normal)
            self.setActivityIndicator(animated: false)
            self.mapView(isActive: true)
            
        }
    }
}
