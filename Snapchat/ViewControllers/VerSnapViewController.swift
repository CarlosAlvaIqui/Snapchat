//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by MAC11 on 23/05/19.
//  Copyright © 2019 Carlos Alvarez. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class VerSnapViewController: UIViewController {

    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var imagenView: UIImageView!
    
    var snap = Snap()
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete{
            (error) in
            print("Se elimino la imagen correctamente")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensaje: " + snap.descrip
        imagenView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
