//
//  FavoritosViewController.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 5/26/20.
//  Copyright © 2020 Jose Pimentel. All rights reserved.
//

import UIKit

class FavoritosViewController: UIViewController {
    
    @IBOutlet weak var favoritosSearch: UISearchBar!
    @IBOutlet weak var favoritosTableView: UITableView!
    @IBOutlet weak var favoritosTextView: UITableView!
    
    let coritos = HimnarioNuevoBrain()
    let coritosViejos = HimnarioViejoBrain()
    var index: Int = 0

    var indexRows: [Int] = []
    var favoritosLength: [String : [Int]] = [:]
    var isNotSearching = true
    
    let defaults = UserDefaults.standard
    
    var search = SearchBrain()
    var coritosView = [Himnos]()
    var favoritosArray = [Himnos]()
    
    func loadFavoritos() {
        
        self.favoritosTableView.reloadData()
        coritosFavoritos()
        coritosFavoritos()
        
        favoritosTableView.delegate = self
        favoritosTableView.dataSource = self
        favoritosSearch.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFavoritos()
    }
    
    func coritosFavoritos() {
        
        favoritosLength = defaults.dictionary(forKey: "Favoritos") as? [String : [Int]] ?? ["Nuevo" : [], "Viejo" : []]
        
        if favoritosLength["Nuevo"]!.count != 0 {
            
            var i = 0
            
            while i < favoritosLength["Nuevo"]!.count {
                //te quedaste aqui como cambiar coritos to coritosViejo
                favoritosArray.append(Himnos(title: coritos.coritos[favoritosLength["Nuevo"]![i]].title, himnos: coritos.coritos[favoritosLength["Nuevo"]![i]].himnos, himnoUrl: coritos.coritos[favoritosLength["Nuevo"]![i]].himnoUrl))
                
                i += 1
            }
        }
        
        if favoritosLength["Viejo"]!.count != 0 {
            
            var i = 0
            
            while i < favoritosLength["Viejo"]!.count {
                //te quedaste aqui como cambiar coritos to coritosViejo
                favoritosArray.append(Himnos(title: coritosViejos.antiguo[favoritosLength["Viejo"]![i]].title, himnos: coritosViejos.antiguo[favoritosLength["Viejo"]![i]].himnos, himnoUrl: coritosViejos.antiguo[favoritosLength["Viejo"]![i]].himnoUrl))
                
                i += 1
            }
        }
    }
}

extension FavoritosViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if(isNotSearching) {
            
            count = (favoritosArray.count / 2)
        }
            
        else {
            
            count = (coritosView.count / 2)
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        
        if(isNotSearching) {
            
            cell.textLabel?.text = favoritosArray[indexPath.row].title
            cell.detailTextLabel?.text = favoritosArray[indexPath.row].himnos
        }
        
        else {
            
            cell.textLabel?.text = coritosView[indexPath.row].title
            cell.detailTextLabel?.text = coritosView[indexPath.row].himnos
        }
        
        return cell
    }
}

extension FavoritosViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(isNotSearching) {
            
            index = indexPath.row
        }
        else {
            
            index = indexRows[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "CoritosFavoritos", sender: self)
        self.dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "Coritos", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CoritosFavoritos" {
            
            let destinationVC = segue.destination as! CoritosViewController
            
            destinationVC.getCoritoIndex(index: index, favoritos: favoritosArray, checkWhichController: "Favorito")
        }
    }
}

extension FavoritosViewController: UISearchBarDelegate {
    
    func searchBarIf() {
        
        if(favoritosSearch.text!.isEmpty) {
            favoritosSearch.showsCancelButton = false
            isNotSearching = true
            favoritosSearch.endEditing(true)
            self.favoritosTableView.reloadData()
        }
            
        else {
            favoritosSearch.showsCancelButton = true
            var search = SearchBrain()
            search.searchFavorito(searchType: favoritosSearch.text!, coritoFavoritos: favoritosArray)
            
            indexRows = search.getIndexFavoritos()
            
            isNotSearching = false
            coritosView = search.getCoritosFavoritos()
            self.favoritosTableView.reloadData()
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
        self.favoritosTableView.reloadData()
        
    }
}
