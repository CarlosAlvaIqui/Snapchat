//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by MAC11 on 16/05/19.
//  Copyright © 2019 Carlos Alvarez. All rights reserved.
//

import UIKit
import AVFoundation

import Firebase

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    var audioID = NSUUID().uuidString
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descripcionTextField: UITextField!
    
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    
    @IBAction func mediaTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var grabarButton: UIButton!
    @IBAction func btnGrabarAudio(_ sender: Any) {
        if grabarAudio!.isRecording{
            grabarAudio?.stop()
            grabarButton.setTitle("GRABAR", for: .normal)
            reproducirButton.isEnabled = true
            
        }else{
            grabarAudio?.record()
            grabarButton.setTitle("Detender", for: .normal)
            reproducirButton.isEnabled = false
            
        }
    }
    
    @IBOutlet weak var reproducirButton: UIButton!
    @IBAction func btnReproducir(_ sender: Any) {
        do{
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("reproduciendo")
        }catch{
        }
    }
    
    func configurarGrabacion(){
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            
            print("g*******************")
            print(audioURL!)
            print("a*******************")
            
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
            
        }catch let error as NSError{
            print(error)
        }
        
    }
    
    
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let audioFolder = Storage.storage().reference().child("audios_odebrech")

        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let audioData = NSData(contentsOf: audioURL!)! as Data?
        
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
        let cargarAudio = audioFolder.child("\(audioID).m4a")
        
        cargarAudio.putData(audioData!, metadata: nil) {
            (metadata, error) in
            if error != nil {
                self.mostrarAlerta(titulo: "error", mensaje: "Se produjo un error al tratar de subir una imagen verifique su conxion a internet y vuelva a intentarlo", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                print("ocurrio un error al subir la imagen \(error)")
            }else{
                cargarAudio.downloadURL(completion: { (url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo algun error al intentar obtener informacion de imagen", accion: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        print("Ocurrio un error al obtener informacion de imagen  \(error)  ")
                        return
                    }
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                    print("correcto")
                })
            }
        }
        /*
        let alertaCarga = UIAlertController(title: "Cargando Imagen ...", message: "0%", preferredStyle: .alert)
        let progresoCarga : UIProgressView = UIProgressView(progressViewStyle: .default)
        cargarImagen.observe(.progress) { (snapshot) in
            let porcentaje = Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
            print(porcentaje)
        progresoCarga.setProgress(Float(porcentaje), animated: true)
            progresoCarga.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
            alertaCarga.message = String(round(porcentaje*100.0)) + " %"
            if porcentaje>=1.0{
                alertaCarga.dismiss(animated: true, completion: nil)
            }
        }
        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertaCarga.addAction(btnOK)
        alertaCarga.view.addSubview(progresoCarga)
        present(alertaCarga, animated: true, completion: nil)
 */
    }
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        
        configurarGrabacion()
        reproducirButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID

    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        imagenesFolder.child("imagenes.jpg").putData(imagenData!, metadata: nil) {
            (metadata, error) in
            if error != nil {
                print("ocurrio un error arreglalo nose pero este es tu erro \(error)")
            }else{
                print("correcto")
            }
        }
    }*/
    
    func mostrarAlerta(titulo: String, mensaje: String, accion:String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
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
