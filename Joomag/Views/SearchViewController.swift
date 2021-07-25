//
//  SearchViewController.swift
//  Joomag
//
//  Created by Artashes Noknok on 6/8/21.
//

import UIKit
import RxSwift
import CoreData


class SearchViewController: UIViewController {
    let bag = DisposeBag()
    let dispossible = CompositeDisposable()
    
    var dispElement = DispleyedElement(temperature: 0, weatherIcons: "", weatherDescriptions: "", windSpeed: 0, name: "")
    
    let searchController = UISearchController()
    @IBOutlet weak var tableView: UITableView!
    var worker: Worker?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        navigationItem.searchController = searchController
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        tableView.tableFooterView = UIView()
    }
    
    func save(weather: DispleyedElement) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Weather",
                                       in: managedContext)!
        
        let weatherEntiti = NSManagedObject(entity: entity,
                                            insertInto: managedContext)
        let index = fetchDatafromeCoreData().count + 1
        
        weatherEntiti.setValue(weather.name, forKeyPath: "name")
        weatherEntiti.setValue(weather.temperature, forKeyPath: "temperature")
        weatherEntiti.setValue(weather.weatherDescriptions, forKeyPath: "weatherdescriptions")
        weatherEntiti.setValue(weather.windSpeed, forKeyPath: "windspeed")
        weatherEntiti.setValue(weather.weatherIcons, forKeyPath: "weathericons")
        weatherEntiti.setValue(index, forKey: "id")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
extension SearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 0 else { return  }
        worker = Worker()
        _ = worker?.doGetWeather(query: text)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (weatherElement) in
                guard let strongSelf = self else { return }
                strongSelf.dispElement = weatherElement
                strongSelf.tableView.reloadData()
                print("suucess")
            }, onError: { [weak self] (error) in
                guard self != nil else { return }
                
                
            })
    }
}
extension SearchViewController : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dispElement.name != "" {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"WeatherTableViewCell") as! WeatherTableViewCell
        cell.selectionStyle = .none
        cell.cityNameAndTemperatureLabel.text = (self.dispElement.name ?? "") + ", " + "\(self.dispElement.temperature ?? 0)" + "°C"
        cell.weatherConditionImageView.downloaded(from: self.dispElement.weatherIcons ?? "")
        cell.weatherConditionLabel.text = self.dispElement.weatherDescriptions ?? ""
        cell.windSpeedLabel.text = "\(self.dispElement.windSpeed ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        save(weather: dispElement)
        self.dismiss(animated: true, completion: nil)
    }
    
}
