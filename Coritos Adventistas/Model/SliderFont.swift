//
//  SliderFont.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 5/25/20.
//  Copyright © 2020 Jose Pimentel. All rights reserved.
//

import UIKit

struct SliderFont {
    let defaults = UserDefaults.standard
    func fontChange(value: String, textDisplay: UITextView, fontLabel: UILabel) {
        
        switch value {
        case "0.0":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 10.0)
            fontLabel.text = "10"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("0.0", forKey: "FontSize")
        case "0.1":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 11.0)
            fontLabel.text = "11"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("0.1", forKey: "FontSize")
        case "0.2":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 12.0)
            fontLabel.text = "12"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("0.2", forKey: "FontSize")
        case "0.3":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 13.0)
            fontLabel.text = "13"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("0.3", forKey: "FontSize")
        case "0.4":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 14.0)
            fontLabel.text = "14"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("0.4", forKey: "FontSize")
        case "0.5":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 15.0)
            fontLabel.text = "15"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("0.5", forKey: "FontSize")
        case "0.6":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 16.0)
            fontLabel.text = "16"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("0.6", forKey: "FontSize")
        case "0.7":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 17.0)
            fontLabel.text = "17"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("0.7", forKey: "FontSize")
        case "0.8":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 18.0)
            fontLabel.text = "18"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("0.8", forKey: "FontSize")
        case "0.9":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 19.0)
            fontLabel.text = "19"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("0.9", forKey: "FontSize")
        case "1.0":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 20.0)
            fontLabel.text = "20"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("1.0", forKey: "FontSize")
        case "1.1":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 21.0)
            fontLabel.text = "21"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("1.1", forKey: "FontSize")
        case "1.2":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 22.0)
            fontLabel.text = "22"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("1.2", forKey: "FontSize")
        case "1.3":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 23.0)
            fontLabel.text = "23"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("1.3", forKey: "FontSize")
        case "1.4":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 24.0)
            fontLabel.text = "24"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("1.4", forKey: "FontSize")
        case "1.5":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 25.0)
            fontLabel.text = "25"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("1.5", forKey: "FontSize")
        case "1.6":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 26.0)
            fontLabel.text = "26"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("1.6", forKey: "FontSize")
        case "1.7":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 27.0)
            fontLabel.text = "27"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("1.7", forKey: "FontSize")
        case "1.8":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 28.0)
            fontLabel.text = "28"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("1.8", forKey: "FontSize")
        case "1.9":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 29.0)
            fontLabel.text = "29"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("1.9", forKey: "FontSize")
        case "2.0":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 30.0)
            fontLabel.text = "30"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("2.0", forKey: "FontSize")
         
        case "2.1":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 31.0)
            fontLabel.text = "31"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("2.1", forKey: "FontSize")
        case "2.2":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 32.0)
            fontLabel.text = "32"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("2.2", forKey: "FontSize")
        case "2.3":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 33.0)
            fontLabel.text = "33"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("2.3", forKey: "FontSize")
        case "2.4":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 34.0)
            fontLabel.text = "34"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("2.4", forKey: "FontSize")
        case "2.5":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 35.0)
            fontLabel.text = "35"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("2.5", forKey: "FontSize")
        case "2.6":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 36.0)
            fontLabel.text = "36"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("2.6", forKey: "FontSize")
        case "2.7":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 37.0)
            fontLabel.text = "37"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("2.7", forKey: "FontSize")
        case "2.8":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 38.0)
            fontLabel.text = "38"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("2.8", forKey: "FontSize")
        case "2.9":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 39.0)
            fontLabel.text = "39"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("2.9", forKey: "FontSize")
        case "3.0":
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 40.0)
            fontLabel.text = "40"
            defaults.removeObject(forKey: "FontSize")
            defaults.set("3.0", forKey: "FontSize")
        default:
            textDisplay.font = UIFont(name: "Helvetica Neue", size: 25.0)
            fontLabel.text = "25"
        }
    }
}
