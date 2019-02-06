//
//  ScannQRCode.swift
//  A2L
//
//  Created by Nathan on 09/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import AVFoundation
import UIKit

// Cette classe gère à elle toute seule la caméra et la reconnaissance du QR code (code source trouvé sur : https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code)
// ATTENTION : ne pas oublier de demander la permission à l'utilisateur via Info.plist

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    func alert(_ title: String, message: String) {
        dismiss(animated: true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { (_) in
            self.captureSession.startRunning()
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scann impossible", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        } else {
            dismiss(animated: true)
        }
        
        
        
    }
    
    var timer = Timer() // COmme partout on lance le compteur pour verifier les réponses
    func found(code: String) { // code est la String contenu dans le QR code
        print("code QR = \(code)")
        
        if code.contains("#") { // sert a délimité les parties du QRCode
            let codePortion = code.split(separator: "#")
            if codePortion.count == 3  {
                let nom = String(codePortion[0])
                let dateNaissance = String(codePortion[1])
                let key = String(codePortion[2])
                
                //On verifie d'abord si la clé est correcte :
                let qrCode = generateQRcode()
                let keyCalculated = qrCode.securityKey(withDate: dateNaissance)
                if keyCalculated == Int(key) { // La clé est correcte
                    let api = APIConnexion()
                    api.otherAdherentData(nom: nom, dateNaissance: dateNaissance) // Tous est déjà en hexa pour le QR code donc pas besoin de reconvertir
                    
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
                } else { // elle ne l'est pas
                    alert("QR Code falsifié", message: "Si c'est volontaire il faut savoir qu'on ne me trompe pas comme ça .... ;)")
                }
            } else {
                alert("QR Code falsifié", message: "Bien tenté mais ça manque d'observation tout ça .. ")
            }
            
        } else {
            alert("Impossible de lire le QR code", message:"Je peux pas tout faire hein ... ")
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc private func verificationReponse() { // check les réponses du serveur
        var reponse = "nil"
        do {// On regarde l'erreur qui est actuellement enregistrée dans les fichiers
            reponse = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(reponseServeur), encoding: .utf8)
        } catch {
            print("Fichier introuvable. ERREUR GRAVE")
        }
        if reponse != "nil" { // on detecte une réponse
            timer.invalidate() // on desactive le compteur il ne sert plus à rien
            
             if reponse == "success" {
                //On a réussi, on transmet les données et on change de view
                performSegue(withIdentifier: "afficheAdherentFiche", sender: self)
            } else { // Une erreur est survenue
                self.alert("Erreur lors de la connexion au serveur", message: reponse)
            }
            let file = FileManager.default
            file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(reponseServeur).path, contents: "nil".data(using: String.Encoding.utf8), attributes: nil)
        }
    }
}
