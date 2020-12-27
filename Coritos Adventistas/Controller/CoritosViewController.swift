//
//  CoritosViewController.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 5/12/20.
//  Copyright © 2020 Jose Pimentel. All rights reserved.
//

import UIKit
import AVFoundation
import Network

class CoritosViewController: UIViewController {

    @IBOutlet weak var coritoTitle: UINavigationItem!
    @IBOutlet weak var fontView: UIView!
    @IBOutlet weak var fontSlider: UISlider!
    @IBOutlet weak var textDisplay: UITextView!
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var reproducirItem: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var favoritoBtn: UITabBarItem!
    
    var coritos = HimnarioNuevoBrain()
    var coritosViejos = HimnarioViejoBrain()
    var indexCorito = 1
    var slider = SliderFont()
    
    var favoritosDictionary: [String : [Int]] = [:]
    var coritosDisplay = [Himnos]()
    
    var coritoFavorito: String = ""
    var highlight: UIColor = #colorLiteral(red: 0.09795290977, green: 0.2151759565, blue: 0.3877361715, alpha: 1)
    var favoritoTitle: String = ""
    var audioPlayer: AVPlayer?
    
    var coritoRate: Float = 0.0
    
    let monitor = NWPathMonitor()
    
    let defaults = UserDefaults.standard
    
    func getCoritoIndex(index: Int, favoritos: [Himnos], checkWhichController: String) {
        
        indexCorito = index
        coritosDisplay = favoritos
        coritoFavorito = checkWhichController
    }
    
    func loadCorito() {
        
        textDisplay.text = coritosDisplay[indexCorito].himnos
        coritoTitle.title = "#" + coritosDisplay[indexCorito].title
        
        favoritosDictionary = defaults.dictionary(forKey: "Favoritos") as? [String : [Int]] ?? ["Nuevo" : [], "Viejo" : []]

        if let font = defaults.string(forKey: "FontSize") {
            
            slider.fontChange(value: font, textDisplay: textDisplay, fontLabel: fontLabel)
            fontSlider.value = Float(font) ?? 1.5
        }
        
        tabBar.delegate = self
        
        //to swipe left or right
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        textDisplay.addGestureRecognizer(leftSwipe)
        textDisplay.addGestureRecognizer(rightSwipe)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCorito()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if coritoRate == 1.0 {
            audioPlayer!.pause()
            
            reproducirItem.title = "Reproducir"
            coritoRate = 0.0
        }
    }
    
    @IBAction func fontActionSlider(_ sender: Any) {
        
        let values = (String(format: "%.1f", fontSlider.value))
        
        slider.fontChange(value: values, textDisplay: textDisplay, fontLabel: fontLabel)
    
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if coritoRate == 1.0 {
            
            audioPlayer!.pause()
            
            coritoRate = 0.0
        }
        
        if (sender.direction == .left) {
            
             if indexCorito < (coritosDisplay.count - 1) {
                
                indexCorito += 1
                
                loadView()
                loadCorito()
            }
            
        }
        
        if (sender.direction == .right) {
            
             if indexCorito != 0{
                
                indexCorito -= 1
                
                loadView()
                loadCorito()
            }
            
        }
        
    }
}
    
extension CoritosViewController: UITabBarDelegate {
    
    //for when you are inside favoritos view controller
    func addFavorite() {
       
        for i in favoritosDictionary["Nuevo"]! {
             
            if coritos.coritos[i].title == coritosDisplay[indexCorito].title {
            
                favoritosDictionary["Nuevo"]!.remove(at: (indexCorito))
            }
        }
        
        for i in favoritosDictionary["Viejo"]! {
            
            if coritosViejos.antiguo[i].title == coritosDisplay[indexCorito].title {
                
                favoritosDictionary["Viejo"]!.remove(at: (indexCorito - favoritosDictionary["Nuevo"]!.count))
            }
        }
    }
    
    //for when you are inside himnario viejo o nuevo
    func deleteFavorite() {
        
        //algorithm to find the hymn that has to be delete
        if favoritosDictionary[coritoFavorito]!.contains(indexCorito) {
            
            var indexFavorito = 0
            
            for i in favoritosDictionary[coritoFavorito]! {
                
                if i == indexCorito {
                    
                    favoritosDictionary[coritoFavorito]!.remove(at: (indexFavorito))
                }
                
                indexFavorito += 1
            }
        }
        
        else {
            
            favoritosDictionary[coritoFavorito]!.append(indexCorito)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if(item.tag == 1) {
            
            if(coritoFavorito == "Favorito") {
                
                addFavorite()
            }
            
            else {
                
                deleteFavorite()
            }
            
            self.defaults.set(favoritosDictionary, forKey: "Favoritos")
        }
            
        else if(item.tag == 2) {
           
            if fontView.isHidden {
                
                fontView.isHidden = false
            }
            
            else {
                
                fontView.isHidden = true
            }
        }
        
        else if(item.tag == 3) {
            
            if coritosDisplay[indexCorito].himnoUrl != "" {
                
                let urlString: String?
                urlString = coritosDisplay[indexCorito].himnoUrl
                
                guard let url = URL(string: urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    
                else {return}
                
                audioPlayer = AVPlayer(url: url)
                audioPlayer!.automaticallyWaitsToMinimizeStalling = false
                
//                var internetConnection = true
//                
//                //check if there is internet conection
//                monitor.pathUpdateHandler = { path in
//                    if path.status == .satisfied {
//                        
//                        internetConnection = true
//                        
//                    } else {
//                        
//                        let alert = UIAlertController(title: "No tienes conecion a internet", message: "Nesecitas internet para poder reproducir los himnos", preferredStyle: .alert)
//                        
//                        //                            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//                        //                            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//                        internetConnection = false
//                        self.present(alert, animated: true)
//                    }
//                    print("here")
//                    print(path.isExpensive)
//                }
                
                if coritoRate == 1.0 {
                    audioPlayer!.pause()
                    
                    reproducirItem.title = "Reproducir"
                    coritoRate = 0.0
                }
                
                else if audioPlayer!.rate == 0.0 { //&& internetConnection {
                    
                    audioPlayer!.play()
                    reproducirItem.title = "Pausar"
                    
                    //allow the device play music when the phone is in silent mode
                    do {
                          try AVAudioSession.sharedInstance().setCategory(.playback)
                       } catch(let error) {
                           print(error.localizedDescription)
                       }
                }
                
                coritoRate = audioPlayer!.rate
            }
            
            else {
                
                reproducirItem.title = "No Audio"
            }
            
        }
    }
}


