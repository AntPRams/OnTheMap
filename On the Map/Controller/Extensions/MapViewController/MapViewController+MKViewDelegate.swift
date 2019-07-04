//
//  MapViewController+MKViewDelegate.swift
//  On the Map
//
//  Created by António Ramos on 28/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit
import MapKit

//Extension made for custom pin view and annotation behaviour

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let button = UIButton(type: .detailDisclosure)
        button.setImage(UIImage(named: "locationIcon"), for: .normal)
        button.tintColor = UIColor.primaryGray
        
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
        annotationView?.rightCalloutAccessoryView = button
        
        let pinImage = UIImage(named: "pin")
        annotationView!.image = pinImage
        annotationView?.centerOffset = CGPoint(x: 0, y: -pinImage!.size.height / 2)
        
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            guard let stringToUrl = view.annotation?.subtitle! else {return}
            if let url = URL(string: stringToUrl) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    _ = UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
