//
//  ViewController.swift
//  Snapchat
//
//  Created by MAC11 on 9/05/19.
//  Copyright © 2019 Carlos Alvarez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
            print("Intentamos iniciar sesion")
            if error != nil {
                print("Se presento el siguiente error: \(error)")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user,error) in
                    print("intentemos crear  un nuevo usaurio")
                    if error != nil {
                        print("se presento el siguiente error al crear el usuario: \(error)")
                    }else{
                        print("El usuario fue creado exitosamente")
                    }
                })
            }else{
                print(" Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    
    @IBAction func btnlogfacebook(_ sender: Any) {
        //1.
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            //2.
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            //2.
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            //3.
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            //4.
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                
                //5.
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                //6.
                self.performSegue(withIdentifier: "pruebiña", sender: nil)
                
            })
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

