//
//  Camera.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 11.10.2021.
//

import Foundation
import AVFoundation

enum CaptureError: Error {
    case badInput, badOutput, unknown(error: Error)
}

class Camera {
    static let shared = Camera()
    
    var captureSession = AVCaptureSession()
    private var torchOn = false
    private var isFrontCameraActive = false
    
    private init() { }
    
    //  MARK:- Open and Close Flashlight
    func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                torchOn.toggle()
                device.torchMode = torchOn ? .on : .off
                device.unlockForConfiguration()
                
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Torch is not available")
        }
    }
    
    // MARK:- Rotate Camera to Front or Back
    func flipCamera() {
        captureSession.inputs.forEach { captureSession.removeInput($0) }
        
        if !isFrontCameraActive {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video,
                                                       position: .front) else { return }
            setInput(device)
            isFrontCameraActive = true
            torchOn = false
        } else {
            guard let device = AVCaptureDevice.default(for: .video) else { return }
            setInput(device)
            isFrontCameraActive = false
        }
    }
    
    // MARK:- Methods for Setting Input and Output
    typealias CaptureResults = (CaptureError?) -> Void
    
    func setInput(_ videoCaptureDevice: AVCaptureDevice, completion: @escaping CaptureResults = { _ in }) {
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                completion(.badInput)
            }
            
        } catch {
            completion(.unknown(error: error))
        }
    }
    
    func setOutput(target: AVCaptureMetadataOutputObjectsDelegate?, completion: @escaping CaptureResults = { _ in }) {
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(target, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            completion(.badOutput)
        }
    }
}
