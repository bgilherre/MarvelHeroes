//
//  MasterViewController.swift
//  Heroes Marvel
//
//  Created by Borja Gil Herrero on 27/11/2018.
//  Copyright © 2018 Alsis GHE. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        DispatchQueue.global().async {
            
        
            self.cargarHeroes()
        }
    }
    
    func cargarHeroes(){
        if !UserDefaults.standard.bool(forKey: "carga"){
            let limit = 25
            var offset = 0
            var continuar:Bool =  true
            while continuar && offset < 300{
                print("entro")
           
                continuar = MarvelRed.llamadaPersonajes(limit: String(limit), offset: String(offset))

                offset = offset + limit
            }
            UserDefaults.standard.setValue(true, forKey: "carga")
        }
    }
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalleHeroe" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> HeroeTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroeCell", for: indexPath) as! HeroeTableViewCell
        let heroe = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withHeroe: heroe)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func configureCell(_ cell: HeroeTableViewCell, withHeroe heroe: Heroe) {
        if heroe.nombre != nil && heroe.nombre != ""{
            cell.nombreLabel.text = heroe.nombre!.description
        }
        if heroe.imagen != nil{
            cell.fotoHeroeImageView?.image = UIImage(data: heroe.imagen! as Data)
        }
       
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<Heroe> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Heroe> = Heroe.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "nombre", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<Heroe>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                DispatchQueue.main.async {
                    self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
                }
            case .delete:
                DispatchQueue.main.async {
                    self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
                }
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                DispatchQueue.main.async {
                    self.tableView.insertRows(at: [newIndexPath!], with: .fade)
                }
            case .delete:
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath!], with: .fade)
                }
            case .update:
                
                configureCell(tableView.cellForRow(at: indexPath!)! as! HeroeTableViewCell, withHeroe: anObject as! Heroe)
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)! as! HeroeTableViewCell, withHeroe: anObject as! Heroe)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.tableView.endUpdates()
        }
    }



}
