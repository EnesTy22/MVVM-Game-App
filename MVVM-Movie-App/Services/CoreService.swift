//
//  CoreService.swift
//  MVVM-Movie-App
//
//  Created by Enes Talha Yılmaz on 17.04.2023.
//

import Foundation
import UIKit
import CoreData

struct CoreService{
    var managedContext:NSManagedObjectContext
    init?(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        managedContext = appDelegate.persistentContainer.viewContext
    }
    func getFavGameList()->[NSManagedObject]{
        
        var fetchItemResults:[NSManagedObject] = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        
        do{
            fetchItemResults = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
        }
        catch let error{
            print(error.localizedDescription)
        }
        return fetchItemResults
        
    }
    func checkIfItemExist(id: Int) -> Bool {

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "gameId == %d" ,id)

        do {
            let count = try managedContext.count(for: fetchRequest)
            if count > 0 {
                return true
            }else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    func deleteFavGame(gameId:Int){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "gameId == %d",gameId)
        do{
            let recordToDelete = try! managedContext.fetch(fetchRequest) as! [NSManagedObject]
            for item in recordToDelete{

                managedContext.delete(item)
            }
            try managedContext.save()
        }
        catch {
            print("Hata oluştu: \(error.localizedDescription)")
        }
        //managedContext.delete()
    }
    func addFavGame(id:Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        item.setValue(id, forKey: "gameId")
        do{try managedContext.save()}
        catch let error{
            print("Error while saving favorites")
        }
    }
}
