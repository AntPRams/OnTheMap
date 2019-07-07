//
//  MapViewController.swift
//  On the Map
//
//  Created by António Ramos on 24/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: MainViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
   
    var annotations = [MKPointAnnotation]()
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddLocationButtonImage(addLocationButton)
        mapView.delegate = self
        populateMap()
        title = "Students Location"

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(annotations.count)
        populateMap()
        setAddLocationButtonImage(addLocationButton)
        setMapInMyLocation()
    }
    
    //MARK: Buttons
    
    @IBAction func refreshButton(_ sender: Any) {
        setActivityIndicator(animated: true)
        print(annotations.count)
        populateMap()
    }
    
    //MARK: Methods
    
    func populateMap() {
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        OTMClient.getStudentLocations(completionHandler: handleLocations(students:error:))
    }
    
    //Method to set the mapview in the location i've choosen in AddLocationController
    func setMapInMyLocation() {

        guard let latitude = DummyInfo.latitude, let longitude = DummyInfo.longitude else {return}

        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mapCamera = MKMapCamera(
            lookingAtCenter: coordinates,
            fromDistance: 5000,
            pitch: 0,
            heading: 0
        )
        mapView.setCamera(mapCamera, animated: true)
    }
    
    
    func handleLocations(students: [StudentLocation]?, error: Error?) {
        
        if let error = error as NSError? {
            handleErrorAlert(error: error)
            setActivityIndicator(animated: false)
        } else {
            guard let studentsLocations = students else {return}
            
            for location in studentsLocations {
                
                if let latitude = location.latitude, let longitude = location.longitude {
                    
                    let lat = CLLocationDegrees(exactly: latitude)
                    let long = CLLocationDegrees(exactly: longitude)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat ?? 28.1461248, longitude: long ?? -82.75676799999999)
                    
                    let fullName = location.fullName
                    let url = location.studentUrl
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = fullName
                    annotation.subtitle = url
                    self.annotations.append(annotation)
                }
                self.mapView.addAnnotations(self.annotations)
                setActivityIndicator(animated: false)
            }
        }
    }
    
    override func setUiState(isInterationEnable: Bool) {
        
        mapView.isUserInteractionEnabled = isInterationEnable
        refreshButton.isEnabled =          isInterationEnable
        addLocationButton.isEnabled =      isInterationEnable
    }
}


