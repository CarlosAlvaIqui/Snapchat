//
//  CrearUsuarioViewController.swift
//  Snapchat
//
//  Created by MAC11 on 21/05/19.
//  Copyright © 2019 Carlos Alvarez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CrearUsuarioViewController: UIViewController {
    @IBOutlet weak var txtuser: UITextField!
    @IBOutlet weak var txtcontraseña: UITextField!
    
    @IBAction func btnreturn(_ sender: Any) {
        performSegue(withIdentifier: "segueregresar", sender: nil)
    }
    @IBAction func btnCrearUsuario(_ sender: Any) {
//        Auth.auth().signIn(withEmail: txtuser.text!, password: txtcontraseña.text!){ (user, error) in
//            print("Intentamos iniciar sesion")
//            if error != nil {
//                print("Error en la logueo \(error)")
//            }else{
//                print("logueo exitoso bien echo muchacho")
//            }
//        }
        Auth.auth().createUser(withEmail: self.txtuser.text!, password: self.txtcontraseña.text!, completion: { (user,error) in
            print("intentemos crear  un nuevo usaurio")
            if error != nil {
                print("se presento el siguiente error al crear el usuario: \(error)")
            }else{
                print("El usuario fue creado exitosamente")
            Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                
                let alerta = UIAlertController(title: "Desea crear este usuario?", message: "Usuario: \(self.txtuser.text!) Se creo correctamente.", preferredStyle: .alert)
                
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
                    self.performSegue(withIdentifier: "seguesiguiente", sender: nil)
                })
                
                let btnCancelation = UIAlertAction(title: "Cancelar", style: .cancel)
                
                alerta.addAction(btnOK)
                alerta.addAction(btnCancelation)

                self.present(alerta, animated: true)
            }
        })

    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
