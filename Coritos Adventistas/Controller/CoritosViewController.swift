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
    @IBOutlet var audioView: UIView!
    @IBOutlet weak var himnoPlayerName: UILabel!
    @IBOutlet weak var playerBar: UIProgressView!
    @IBOutlet weak var playPauseImage: UIButton!
    @IBOutlet weak var PlayerTimer: UILabel!
    @IBOutlet weak var TextDisplayView: UIView!
    
    var coritos = HimnarioNuevoBrain()
    var coritosViejos = HimnarioViejoBrain()
    var indexCorito = 0
    static var indexCoritoApi = 0
    var slider = SliderFont()
    
    var favoritosDictionary: [String : [Int]] = [:]
    var coritosDisplay = [Himnos]()
    
    var coritoFavorito: String = ""
    var highlight: UIColor = #colorLiteral(red: 0.09795290977, green: 0.2151759565, blue: 0.3877361715, alpha: 1)
    var favoritoTitle: String = ""
    var songPlaying: String = ""
    var isChangeHimnoName = false
    
    static var audioPlayer: AVPlayer?
    static var launchBefore = false
    static var indexCoritoPlaying = 1
    static var progressBarCount: Int = 0
    static var timer = Timer()
    static var progressBarProgress: Float = 0.0
    static var trackTime = ""
    static var trackDuration = 0
    static var cualHimnarioNuevoOAntiguo: String?
    
    var coritoRate: Float = 0.0
    var duration: Int = 0
    
    let monitor = NWPathMonitor()
    
    let defaults = UserDefaults.standard
    var data = ManagerAPI()
    
    
    func getCoritoIndex(index: Int, favoritos: [Himnos], checkWhichController: String) {
        
        indexCorito = index
        CoritosViewController.indexCoritoApi = index
        coritosDisplay = favoritos
        coritoFavorito = checkWhichController
    }
    
    // MAKE THIS FUNCTION GLOBAL AND PUT IT IN ANOTHER CLASS THAT WAY YOU WILL BE ABLE TO PAUSE AND RESUME ANYWHERE
    func audioReproduction() {
        apiHimnoSelection()
        audioPlayerView()
        //check if the same song is playing
        if playerBar.progress == 0.0 && !CoritosViewController.launchBefore { //coritosDisplay[indexCorito].himnoUrl != songPlaying && coritoRate == 0.0 {//&& CoritosViewController.launchBefore == 1 {
            CoritosViewController.progressBarProgress = 0.0
            
            let urlString: String?
            if coritoFavorito == "Nuevo" {
                
                urlString = "https://discoveryprovider.audius7.prod-us-west-2.staked.cloud/v1/tracks/\(data.trackName)/stream?app_name=HimnarioViejo"
            }
            
            else {
                
                urlString = coritosDisplay[indexCorito].himnoUrl
            }
            
            
            
            songPlaying = coritosDisplay[indexCorito].himnoUrl
            
            guard let url = URL(string: urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                
            else {return}
            
            CoritosViewController.audioPlayer = AVPlayer(url: url)
            CoritosViewController.audioPlayer!.automaticallyWaitsToMinimizeStalling = false
            
            CoritosViewController.launchBefore = true
            CoritosViewController.indexCoritoPlaying = indexCorito
            
        }
        print(playPauseImage == #imageLiteral(resourceName: "pause-svgrepo-com-1"))
        //I HAVE TO THINK OF A BOOL comparation to be able to pause after the view disapper
        if CoritosViewController.audioPlayer!.timeControlStatus == AVPlayer.TimeControlStatus.playing { //coritoRate >= 1.0 && playerBar.progress > 0.0 {//|| playPauseImage.isEqual(#imageLiteral(resourceName: "pause-svgrepo-com-1")) {
            
            CoritosViewController.audioPlayer!.pause()
            
            CoritosViewController.timer.invalidate()
            reproducirItem.title = "Reproducir"
            coritoRate = 0.0
            
            
            playPauseImage.setImage(#imageLiteral(resourceName: "play-button-svgrepo-com-1"), for: .normal)
        }
        
        else if CoritosViewController.audioPlayer!.timeControlStatus == AVPlayer.TimeControlStatus.paused { //CoritosViewController.audioPlayer!.rate == 0.0 { //&& internetConnection {
            
            CoritosViewController.audioPlayer!.play()
            print(CoritosViewController.audioPlayer!.currentTime().seconds)
            //reproducirItem.title = "Pausar"
            
            
            //put this func here so the himno name gets updated when you hit play maybe it can be remove after
            if CoritosViewController.launchBefore == false {
                audioPlayerView()
            }
            
//            if progressBarCount > 1 {
//
//                timer.fire()
//            }
//            else {
            //this timer is to count the song playing time
            CoritosViewController.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(progressBarTimer), userInfo: nil, repeats: true)
            
            //}
            playPauseImage.setImage(#imageLiteral(resourceName: "pause-svgrepo-com-1"), for: .normal)
            
            
            //allow the device play music when the phone is in silent mode
            do {
                  try AVAudioSession.sharedInstance().setCategory(.playback)
               } catch(let error) {
                   print(error.localizedDescription)
               }
        }
        
        coritoRate = CoritosViewController.audioPlayer!.rate
    }
    
    func audioPlayerView() {

        //necito poner un OR aqui
        if coritoRate == 0.0 || isChangeHimnoName {

            isChangeHimnoName = false

            // cut the himno name show in the player so it doesn't overlap
            if CoritosViewController.launchBefore == false {

                himnoPlayerName.text = coritosDisplay[indexCorito].title
                CoritosViewController.trackTime = data.trackTime
                CoritosViewController.trackDuration = data.trackDuration
                PlayerTimer.text = CoritosViewController.trackTime
                //CHANGE THIS
                PlayerTimer.isHidden = true
            }

            else {

                himnoPlayerName.text = coritosDisplay[CoritosViewController.indexCoritoPlaying].title
            }

            if himnoPlayerName.text!.count > 35 {

                himnoPlayerName.text = String(himnoPlayerName.text!.dropLast(16))
                himnoPlayerName.text?.append("...")

            }

            else if himnoPlayerName.text!.count > 30 {

                himnoPlayerName.text = String(himnoPlayerName.text!.dropLast(9))
                himnoPlayerName.text?.append("...")
            }

            //PlayerTimer.text = String(format: PlayerTimer.text?, //CoritosViewController.audioPlayer?.currentItem!.duration as CVarArg)
            //PlayerTimer.text = String(CoritosViewController.audioPlayer!.currentTime().seconds)



        }
        //self.TextDisplayView.addSubview(audioView)
        self.view.addSubview(audioView)

        audioView.layer.cornerRadius = 15
        playPauseImage.layer.cornerRadius = 15
        //playPauseImage.layer.borderColor =
        playPauseImage.layer.borderWidth = 1
        audioView.translatesAutoresizingMaskIntoConstraints = false

        audioView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 600).isActive = true
        audioView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        audioView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        audioView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

//        audioView.widthAnchor.constraint(equalToConstant: 249).isActive = true
//        audioView.heightAnchor.constraint(equalToConstant: 90).isActive = true

        audioView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    //REVISA SI PUEDES DARTE CUENTA SI LA MUSICA PARO PARA DEJAR DE AGREGAR 1 A PROGRESS BAR
    @objc func progressBarTimer() {
        
//        if CoritosViewController.launchBefore == false {
//
//        }
        
        //apiHimnoSelection()
        
        if CoritosViewController.progressBarProgress == 1.0 {
            
            CoritosViewController.progressBarProgress = 0.0
            CoritosViewController.progressBarCount = 0
            playPauseImage.setImage(#imageLiteral(resourceName: "play-button-svgrepo-com-1"), for: .normal)
            coritoRate = 0.0
            CoritosViewController.launchBefore = false
            audioPlayerView()
            CoritosViewController.timer.invalidate()
        }
            
        else {
            
            CoritosViewController.progressBarProgress = Float(CoritosViewController.progressBarCount) / Float(CoritosViewController.trackDuration)
            print(playerBar.progress)
            print(CoritosViewController.progressBarCount)
            CoritosViewController.progressBarCount += 1
            
        }
        
        playerBar.progress = CoritosViewController.progressBarProgress
        //guarda esta variable y cuando alguien le quiera reproducir otro himno la setea a 0 en el boton repoducir
        
    }
    
    func apiHimnoSelection() {
        
        let playlist1 = "ezPGw"
        let playlist2 = "L5oP1"
        let playlist3 = "DyYrZ"
        let playlist4 = "n1mw3"
        
        if indexCorito >= 0 && indexCorito <= 200 {
            
            CoritosViewController.indexCoritoApi = indexCorito
            
            
            data.performRequest(apiURL: "https://dn2.monophonic.digital/v1/playlists/\(playlist1)/tracks?app_name=HimnarioViejo")
            
            coritos.coritos[indexCorito].himnoUrl = "https://discoveryprovider.audius7.prod-us-west-2.staked.cloud/v1/tracks/\(data.trackName)/stream?app_name=HimnarioViejo"
        }
        
        else if indexCorito > 200 && indexCorito <= 400 {
            
            CoritosViewController.indexCoritoApi = indexCorito - 201
            
            data.performRequest(apiURL: "https://dn2.monophonic.digital/v1/playlists/\(playlist2)/tracks?app_name=HimnarioViejo")
    
        }
        
        else if indexCorito > 400 && indexCorito < 602 {
            
            if indexCorito >= 590 {
               
                CoritosViewController.indexCoritoApi = indexCorito - 402
            }
            else {
                CoritosViewController.indexCoritoApi = indexCorito - 401
            }
            
            data.performRequest(apiURL: "https://dn2.monophonic.digital/v1/playlists/\(playlist3)/tracks?app_name=HimnarioViejo")
        }
        
        else if indexCorito >= 601 {
            
            CoritosViewController.indexCoritoApi = indexCorito - 602
            
            data.performRequest(apiURL: "https://dn2.monophonic.digital/v1/playlists/\(playlist4)/tracks?app_name=HimnarioViejo")
        }
        
    }
    
    func loadCorito() {
        apiHimnoSelection()
        
        textDisplay.text = coritosDisplay[indexCorito].himnos + "\n"
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
        audioPlayerView()
        
//        var i = 0
//        while i <= coritos.coritos.count {
//
//            coritos.coritos[i].himnoUrl = "https://discoveryprovider.audius7.prod-us-west-2.staked.cloud/v1/tracks/\(data.trackName)/stream?app_name=HimnarioViejo"
//            i += 1
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        apiHimnoSelection()
        
        PlayerTimer.text = CoritosViewController.trackTime
        
        if CoritosViewController.progressBarCount > 0 {
            
            playerBar.progress = CoritosViewController.progressBarProgress
            
            //check if the music is playing and if it is start the timer because I only can start the timer if the music is playing
            if CoritosViewController.audioPlayer!.timeControlStatus == AVPlayer.TimeControlStatus.playing {
                CoritosViewController.timer.invalidate()
                
                playPauseImage.setImage(#imageLiteral(resourceName: "pause-svgrepo-com-1"), for: .normal)
                
                CoritosViewController.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(progressBarTimer), userInfo: nil, repeats: true)
            }
            
            
        }
        
//        if CoritosViewController.audioPlayer?.rate == 0.0 {
//            timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(progressBarTimer), userInfo: nil, repeats: true)
//        }
        
//        if CoritosViewController.launchBefore == 2 && CoritosViewController.audioPlayer!.rate > 0.0 {
//
//            playPauseImage.setImage(#imageLiteral(resourceName: "pause-svgrepo-com-1"), for: .normal)
//        }
//
//        else if CoritosViewController.launchBefore == 2 {
//
//            playPauseImage.setImage(#imageLiteral(resourceName: "play-button-svgrepo-com-1"), for: .normal)
//        }
        
        if defaults.bool(forKey: "DarkMode") !=  true{
            
            overrideUserInterfaceStyle = .dark
            tabBar.overrideUserInterfaceStyle = .dark
            tabBarController!.overrideUserInterfaceStyle = .dark
        }
        
        else {
            
            overrideUserInterfaceStyle = .light
            tabBar.overrideUserInterfaceStyle = .light
            tabBarController!.overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        //timer.invalidate()
        //timer.invalidate()
//        if coritoRate == 1.0 {
//            audioPlayer!.pause()
//
//            reproducirItem.title = "Reproducir"
//            coritoRate = 0.0
        }
    //}
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        
        audioReproduction()
        
    }
    
    
    @IBAction func fontActionSlider(_ sender: Any) {
        
        let values = (String(format: "%.1f", fontSlider.value))
        
        slider.fontChange(value: values, textDisplay: textDisplay, fontLabel: fontLabel)
    
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
//        if coritoRate == 1.0 {
//
//            CoritosViewController.audioPlayer!.pause()
//
//            coritoRate = 0.0
//        }
        
        
        if (sender.direction == .left) {
            
             if indexCorito < (coritosDisplay.count - 1) {
                
                indexCorito += 1
                CoritosViewController.indexCoritoApi += 1
                apiHimnoSelection()
                
                loadView()
                loadCorito()
            }
            
        }
        
        if (sender.direction == .right) {
            
             if indexCorito != 0{
                
                indexCorito -= 1
                CoritosViewController.indexCoritoApi -= 1
                apiHimnoSelection()
                
                loadView()
                loadCorito()
            }
            
        }
        audioPlayerView()
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
        
        //Make an option so people can chose to play instrumental or play also the voice and if the himno is already playing and you move to another himno you can chose to play that other himno
        else if(item.tag == 3) {
            
            CoritosViewController.timer.invalidate()
            CoritosViewController.progressBarCount = 0
            coritoRate = 0.0
            playerBar.progress = 0.0
            CoritosViewController.launchBefore = false
            audioReproduction()
            audioPlayerView()
            
        }
        
        else if (item.tag == 4) {
            
            if (defaults.bool(forKey: "DarkMode") == false) {
             
                overrideUserInterfaceStyle = .light
                tabBar.overrideUserInterfaceStyle = .light
                tabBarController!.overrideUserInterfaceStyle = .light
                tabBarController!.tabBar.barTintColor = UIColor.white
                
                defaults.removeObject(forKey: "DarkMode")
                defaults.set(true, forKey: "DarkMode")
            }
            
            else {
                
                overrideUserInterfaceStyle = .dark
                tabBar.overrideUserInterfaceStyle = .dark
                tabBarController!.overrideUserInterfaceStyle = .dark
                tabBarController!.tabBar.barTintColor = UIColor.black
                
                
                defaults.removeObject(forKey: "DarkMode")
                defaults.set(false, forKey: "DarkMode")
            }
        }
    }
}


