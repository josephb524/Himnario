//
//  SearchBrain.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 5/18/20.
//  Copyright © 2020 Jose Pimentel. All rights reserved.
//

import Foundation

struct SearchBrain { 
    
    var coritos = HimnarioNuevoBrain()
    var searchCoritos = [Himnos]()
    var searchResults: [Int] = []
    
    var himnoViejo = HimnarioViejoBrain()
    var searchHimno = [Himnos]()
    var searchResultsHimno: [Int] = []
    
    var searchCoritosFavoritos = [Himnos]()
    var searchResultsFavoritos: [Int] = []
    
    mutating func search(searchType: String)   {
        
        var i = 0
        var e = 0
        
        while i < coritos.coritos.count {
            
            if(coritos.coritos[i].title.lowercased().contains(searchType.lowercased()))  {
                
                searchCoritos.append(Himnos(title: coritos.coritos[i].title, himnos: coritos.coritos[i].himnos, himnoUrl: coritos.coritos[i].himnoUrl))
                
                searchResults.append(1)
                searchResults[e] = i
                
                e += 1
            }
            
            i += 1
        }
    }
    
    func getCoritos() -> [Himnos] {
        
        return searchCoritos
    }
    
    func getIndex() -> [Int] {
        
        return searchResults
    }
    
//  <--------------------------------Himnario Viejo Search-------------------------------->
    
    
    mutating func search(searchViejo: String)   {
        
        var i = 0
        var e = 0
        
        while i < himnoViejo.antiguo.count {
            
            if himnoViejo.antiguo [i].title.lowercased().contains(searchViejo.lowercased()) {
                
                searchCoritos.append(Himnos(title: himnoViejo.antiguo[i].title, himnos: himnoViejo.antiguo[i].himnos, himnoUrl: himnoViejo.antiguo[i].himnoUrl))
                
                searchResults.append(1)
                searchResults[e] = i
                
                e += 1
            }
            
            i += 1
        }
    }
    
    func getHimnoViejo() -> [Himnos] {
        
        return searchCoritos
    }
    
    func getHimnoViejoIndex() -> [Int] {
        
        return searchResults
    }
    
    
    
    
//  <--------------------------------Favoritos Search-------------------------------->
    
    
    mutating func searchFavorito(searchType: String, coritoFavoritos: [Himnos])   {
        
        var i = 0
        var e = 0
        
        while i < coritoFavoritos.count {
            
            if(coritoFavoritos[i].title.lowercased().contains(searchType.lowercased()))  {
                
                searchCoritosFavoritos.append(Himnos(title: coritoFavoritos[i].title, himnos: coritoFavoritos[i].himnos, himnoUrl: coritoFavoritos[i].himnoUrl))
                
                searchResultsFavoritos.append(1)
                searchResultsFavoritos[e] = i
                
                e += 1
            }
            
            i += 1
        }
    }
    
    func getCoritosFavoritos() -> [Himnos] {
        
        return searchCoritosFavoritos
    }
    
    func getIndexFavoritos() -> [Int] {
        
        return searchResultsFavoritos
    }
}
