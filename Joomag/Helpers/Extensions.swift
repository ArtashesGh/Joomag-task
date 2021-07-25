//
//  Extensions.swift
//  Joomag
//
//  Created by Artashes Noknok on 6/8/21.
//

import Foundation
import UIKit
import CoreData

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension UIViewController {
    func fetchDatafromeCoreData() -> [NSManagedObject] {
        var dispElements:[NSManagedObject] = []
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext =
            appDelegate!.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Weather")
        
        do {
            dispElements = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return dispElements
    }
    
    func deleteObjectWithId(withIndex:Int) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext =
            appDelegate!.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Weather")
        fetchRequest.predicate  = NSPredicate.init(format: "id==\(withIndex)")
        let objects = try! managedContext.fetch(fetchRequest)
        for obj in objects {
            managedContext.delete(obj)
        }

        do {
            try managedContext.save() // <- remember to put this :)
        } catch {
            // Do something... fatalerror
        }
    }
    
    func updateCoreDataElement(withIndex:Int)  {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext =
            appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")

        fetchRequest.predicate = NSPredicate(format: "id==\(withIndex)")

        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { 
                results?[0].setValue(withIndex, forKey: "id")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }

        do {
            try managedContext.save()
           }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    func converttManagedObgectToDispleyObject(with userManaged:[NSManagedObject]) -> [DispleyedElement] {
        var getedElements:[DispleyedElement] = []
        for element in userManaged {
            let userElement:DispleyedElement = DispleyedElement(temperature: element.value(forKey: "temperature") as? Int,
                                                                weatherIcons: element.value(forKey: "weathericons") as? String,
                                                                weatherDescriptions: element.value(forKey: "weatherdescriptions") as? String,
                                                                windSpeed: element.value(forKey: "windspeed") as?  Int,
                                                                name: element.value(forKey: "name") as? String)

            getedElements.append(userElement)
        }
        
        return getedElements
    }
}
