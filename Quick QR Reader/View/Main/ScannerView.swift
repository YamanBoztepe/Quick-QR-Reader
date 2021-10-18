//
//  ScannerView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 17.10.2021.
//

import SwiftUI
import AVFoundation

struct ScannerView: UIViewControllerRepresentable {
    typealias ScannerResult = (Result<QRModel, CaptureError>) -> Void
    
    var completion: ScannerResult
    
    init(completion: @escaping ScannerResult) {
        self.completion = completion
    }
    
    // MARK:- Required Methods
    func makeCoordinator() -> ScannerCoordinator {
        ScannerCoordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let vc = ScannerViewController()
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) { }
    
    // MARK:- Coordinator Object
    class ScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: ScannerView
        
        init(parent: ScannerView) {
            self.parent = parent
        }
        
        // Handling Output
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            guard let metadataObject = metadataObjects.first,
                  let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { return }
            
            if Camera.shared.captureSession.isRunning {
                Camera.shared.captureSession.stopRunning()
            }
            
            let result = QRModel(content: stringValue, createdDate: Date())
            parent.completion(.success(result))
        }
        
        // Helper Methods
        func didFail(reason: CaptureError) {
            parent.completion(.failure(reason))
        }
        
    }
    
    // MARK:- ScannerViewController
    class ScannerViewController: UIViewController {
        var delegate: ScannerCoordinator?
        var captureSession: AVCaptureSession {
            Camera.shared.captureSession
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setInput()
            setPreviewLayer()
            setMetadataOutput()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            if captureSession.isRunning {
                captureSession.stopRunning()
            }
        }
        
        // Methods for Setting Input and Output
        private func setInput() {
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            Camera.shared.setInput(videoCaptureDevice) { error in
                guard let error = error else { return }
                self.delegate?.didFail(reason: error)
            }
        }
        
        private func setMetadataOutput() {
            Camera.shared.setOutput(target: delegate) { error in
                guard let error = error else { return }
                self.delegate?.didFail(reason: error)
            }
        }
        
        // Layout
        private func setPreviewLayer() {
            let vieoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            vieoPreviewLayer.frame = view.layer.bounds
            vieoPreviewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(vieoPreviewLayer)
        }
    }
}
