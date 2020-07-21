//
//  MangaparkCache.swift
//  manga_comic
//
//  Created by gem on 7/10/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MangaParkCache {
    public func savaMangaToCoreData(mangaItem: MangaItem, nameEntity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let mangaparkEntity = NSEntityDescription.entity(forEntityName: nameEntity, in: managedContext)!
        let mangaparkInDataCore = NSManagedObject(entity: mangaparkEntity, insertInto: managedContext)
        mangaparkInDataCore.setValue(mangaItem.name, forKey: "name")
        mangaparkInDataCore.setValue(mangaItem.imageUrl, forKey: "imageUrl")
        mangaparkInDataCore.setValue(mangaItem.url, forKey: "url")
        do{
            try managedContext.save()
        } catch {
            debugPrint("ERR on save core data \(error)")
        }
    }
    
    public func getMangaparkCoreData(nameEntity: String) -> [MangaItem] {
        var arrManga = [MangaItem]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return arrManga }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: nameEntity)
        do {
            let result = try managedContext.fetch(fetchRequest)
            for manga in result as! [NSManagedObject] {
                let name = manga.value(forKey: "name") as! String
                let imageUrl = manga.value(forKey: "imageUrl") as! String
                let url = manga.value(forKey: "url") as! String
                arrManga.append(MangaItem.init(name: name, url: url, imageUrl: imageUrl, newChap: ""))
            }
        } catch {
            debugPrint(error)
        }
        return arrManga
    }
    
    public func deleteItem(nameManga: String, nameEntity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: nameEntity)
        fetchRequest.predicate = NSPredicate(format: "name == %@" ,nameManga)
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
                try managedContext.save()
            }
        } catch let error {
            print("Detele all data in \(Contains.BOOKMARK_CORE_DATA) error :", error)
        }
    }
    
    public func checkExitItem(nameManga: String, nameEntity: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: nameEntity)
        fetchRequest.predicate = NSPredicate(format: "name == %@" ,nameManga)
        var results: [NSManagedObject] = []
        do {
            results = try managedContext.fetch(fetchRequest)
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return results.count > 0
    }
}
