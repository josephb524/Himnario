//
//  ContactanosViewController.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 6/8/20.
//  Copyright © 2020 Jose Pimentel. All rights reserved.
//

import UIKit

class ContactanosViewController: UIViewController {

    @IBOutlet weak var contactanosText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .light
        
        contactanosText.isUserInteractionEnabled = true
        contactanosText.isSelectable = true
        contactanosText.isEditable = false
        contactanosText.dataDetectorTypes = UIDataDetectorTypes.link
        contactanosText.tintColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        
        contactanosText.text = contactanos()
    }
    
    func contactanos() -> String{
        
        let text = "CONTACTANOS \n\nSi tienes alguna pregunta, queja o comentario acerca de como mejorar este aplicacion por favor escribanos a nuestro correo electronico oficial: josephb401@hotmail.com "
        
        return text
    }
}
