//
//  SelectCoritoViewController.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 5/12/20.
//  Copyright © 2020 Jose Pimentel. All rights reserved.
//

import UIKit

class HimnarioNuevoViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var selectTableView: UITableView!
    
    let coritos = HimnarioNuevoBrain()
    var index: Int = 0

    var indexRows: [Int] = []
    var isNotSearching = true
    var placeHolderStrn: String = ""
    
    var search = SearchBrain()
    var coritosView = [Himnos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectTableView.delegate = self
        selectTableView.dataSource = self
        searchBar.delegate = self
        //tabBar.delegate = self
        
        self.addDoneButtonOnKeyboard()
    }
}

extension HimnarioNuevoViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if(isNotSearching) {
            
            count = coritos.coritos.count
        }
            
        else {
            
            count = (coritosView.count)
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "identityCell", for: indexPath)
        
        if(isNotSearching) {
            
            cell.textLabel?.text = coritos.coritos[indexPath.row].title
            cell.detailTextLabel?.text = coritos.coritos[indexPath.row].himnos
        }
        
        else {
            
            cell.textLabel?.text = coritosView[indexPath.row].title
            cell.detailTextLabel?.text = coritosView[indexPath.row].himnos
        }
        
        return cell
    }
}

extension HimnarioNuevoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(isNotSearching) {
            
            index = indexPath.row
        }
        else {
            
            index = indexRows[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "Coritos", sender: self)
        self.dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "Coritos", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Coritos" {
            
            let destinationVC = segue.destination as! CoritosViewController
            
            destinationVC.getCoritoIndex(index: index, favoritos: coritos.coritos, checkWhichController: "Nuevo")
        }
    }
}

extension HimnarioNuevoViewController: UISearchBarDelegate {
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        print("here")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        searchBar.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {

        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarIf() {
        
        if(searchBar.text!.isEmpty) {
            searchBar.showsCancelButton = false
            isNotSearching = true
            //searchBar.endEditing(true)
            self.selectTableView.reloadData()
        }
            
        else {
            searchBar.showsCancelButton = true
            var search = SearchBrain()
            search.search(searchType: searchBar.text!)
            
            indexRows = search.getIndex()
            
            isNotSearching = false
            coritosView = search.getCoritos()
            self.selectTableView.reloadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBarIf()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBarIf()
        searchBar.showsCancelButton = false
        
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        isNotSearching = true
        searchBar.text = ""
        self.selectTableView.reloadData()
        
    }
}


