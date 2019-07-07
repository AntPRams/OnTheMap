//
//  TableViewController.swift
//  On the Map
//
//  Created by António Ramos on 24/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit

class TableViewController: MainViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTable()
        tableView.delegate = self
        title = "Students List"
        customActivityIndicatorContainer.setNeedsLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateTable()
        setAddLocationButtonImage(addLocationButton)
        
    }
    
    //MARK: Buttons
    
    @IBAction func refreshTableView(_ sender: Any) {
        setActivityIndicator(animated: true)
        populateTable()
    }
    
    //MARK: Methods
    
    func populateTable() {
        OTMClient.getStudentLocations(completionHandler: handleLocations(students:error:))
    }
    
    //Handle the response of getStudentLocations
    func handleLocations(students: [StudentLocation], error: Error?){
        
        if error != nil {
            self.handleErrorAlert(error: error)
            setActivityIndicator(animated: false)
        } else {
            self.tableView.reloadData()
            setActivityIndicator(animated: false)
        }
    }
    
    override func setUiState(isInterationEnable: Bool) {
        tableView.isUserInteractionEnabled = isInterationEnable
        refreshButton.isEnabled =            isInterationEnable
        addLocationButton.isEnabled =        isInterationEnable
    }
}
