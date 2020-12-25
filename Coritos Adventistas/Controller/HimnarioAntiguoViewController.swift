//
//  HimnarioAntiguoViewController.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 6/15/20.
//  Copyright © 2020 Jose Pimentel. All rights reserved.
//

import UIKit

class HimnarioAntiguoViewController: UIViewController {

    @IBOutlet weak var antiguoSearch: UISearchBar!
    @IBOutlet weak var antiguoTableView: UITableView!
    
    let coritos = HimnarioViejoBrain()
        var index: Int = 0

        var indexRows: [Int] = []
        var isNotSearching = true
        var placeHolderStrn: String = ""


        var search = SearchBrain()
        var coritosView = [Himnos]()

        override func viewDidLoad() {
            super.viewDidLoad()

            antiguoTableView.delegate = self
            antiguoTableView.dataSource = self
            antiguoSearch.delegate = self
            //tabBar.delegate = self
            
            self.addDoneButtonOnKeyboard()
        }
    }

    extension HimnarioAntiguoViewController: UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            var count = 0

            if(isNotSearching) {

                count = coritos.antiguo.count
            }

            else {

                count = (coritosView.count)
            }

            return count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "identityCell", for: indexPath)

            if(isNotSearching) {

                cell.textLabel?.text = coritos.antiguo[indexPath.row].title
                cell.detailTextLabel?.text = coritos.antiguo[indexPath.row].himnos
            }

            else {

                cell.textLabel?.text = coritosView[indexPath.row].title
                cell.detailTextLabel?.text = coritosView[indexPath.row].himnos
            }

            return cell
        }
    }

    extension HimnarioAntiguoViewController: UITableViewDelegate {

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

                destinationVC.getCoritoIndex(index: index, favoritos: coritos.antiguo, checkWhichController: "Viejo")
            }
        }
    }

    extension HimnarioAntiguoViewController: UISearchBarDelegate {

        func addDoneButtonOnKeyboard() {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default
            print("here")
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()

            antiguoSearch.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction() {

            antiguoSearch.endEditing(true)
            antiguoSearch.showsCancelButton = false
        }
        
        func searchBarIf() {

            if(antiguoSearch.text!.isEmpty) {
                antiguoSearch.showsCancelButton = false
                isNotSearching = true
                
                self.antiguoTableView.reloadData()
            }

            else {
                antiguoSearch.showsCancelButton = true
                var search = SearchBrain()
                search.search(searchViejo: antiguoSearch.text!)

                indexRows = search.getHimnoViejoIndex()

                isNotSearching = false
                coritosView = search.getHimnoViejo()
                self.antiguoTableView.reloadData()
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
            self.antiguoTableView.reloadData()

        }
    }

    

    
