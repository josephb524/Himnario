//
//  ManagerAPI.swift
//  Himnario Adventista
//
//  Created by Jose Pimentel on 4/30/21.
//  Copyright © 2021 Jose Pimentel. All rights reserved.
//

import Foundation

class ManagerAPI {
    
    var trackTime: String = ""
    var trackDuration = 0
    let apiURL = "https://dn2.monophonic.digital/v1/tracks/XO2wy?app_name=himnarioViejo"
    
    
    //performRequest(apiURL)
    
    func performRequest(apiURL: String) {
        
        if let url = URL(string: apiURL) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    
                    self.parseJSON(apiData: safeData)
                    //let dataString = String(data: safeData, encoding: .utf8)
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(apiData: Data)  {
        
        let decoder = JSONDecoder()
        do {
            
            let decoderData = try decoder.decode(DataAPI.self, from: apiData)
            
            //convert the time
            //let hours = Int(decoderData.data[1].duration) / 3600
            let minutes = Int(decoderData.data[CoritosViewController.indexCoritoApi].duration) / 60 % 60
            let seconds = Int(decoderData.data[1].duration) % 60
            
            //print(decoderData.data[1].duration)
            
            //print(String(format:"%02i:%02i", minutes, seconds))
            print(decoderData.data[CoritosViewController.indexCoritoApi].title)
            
            trackTime = String(format:"%02i:%02i", minutes, seconds)
            //print(trackTime)
            trackDuration = decoderData.data[CoritosViewController.indexCoritoApi].duration
            
        } catch {
            
            print(error)
        }
        
        
    }
    
//    func getHimnoTime() -> String {
//
//
//        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
//    }
}
