//
//  TableViewController+UITableViewDelegate&DataSource.swift
//  On the Map
//
//  Created by António Ramos on 28/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit

//The normal methods to configure the tableview

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Locations.shared.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationCell", for: indexPath)
        let model = Locations.shared.list[indexPath.row]
        
        cell.textLabel?.text =       model.fullName
        cell.detailTextLabel?.text = model.mediaURL
        cell.imageView?.image =      UIImage(named: "locationIcon")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = Locations.shared.list[indexPath.row]
        
        guard let urlString = model.mediaURL else {return}
        if let url = URL(string: urlString) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                _ = UIApplication.shared.openURL(url)
            }
        }
    }
}
