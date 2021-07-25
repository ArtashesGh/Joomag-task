//
//  ViewController.swift
//  Joomag
//
//  Created by Artashes Noknok on 6/8/21.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var locManager: CLLocationManager!
    var displeyedElements:[DispleyedElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        tableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.displeyedElements = converttManagedObgectToDispleyObject(with: fetchDatafromeCoreData())
        tableView.reloadData()
    }
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displeyedElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"WeatherTableViewCell") as! WeatherTableViewCell
        let dispElement = displeyedElements[indexPath.row]
        cell.cityNameAndTemperatureLabel.text = (dispElement.name ?? "") + ", " + "\(dispElement.temperature ?? 0)" + "°C"
        cell.weatherConditionImageView.downloaded(from: dispElement.weatherIcons ?? "")
        cell.weatherConditionLabel.text = dispElement.weatherDescriptions ?? ""
        cell.windSpeedLabel.text = "\(dispElement.windSpeed ?? 0)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteObjectWithId(withIndex: indexPath.row + 1)
            self.displeyedElements = converttManagedObgectToDispleyObject(with: fetchDatafromeCoreData())
            tableView.reloadData()
        }
    }

     func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.displeyedElements[sourceIndexPath.row]
        displeyedElements.remove(at: sourceIndexPath.row)
        displeyedElements.insert(movedObject, at: destinationIndexPath.row)
    }
    
    
}

