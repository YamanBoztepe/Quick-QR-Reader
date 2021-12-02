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
    
    @Binding var startScanning: Bool
    var completion: ScannerResult
    
    init(startScanning: Binding<Bool>, completion: @escaping ScannerResult) {
        self._startScanning = startScanning
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
            guard parent.startScanning == true,
                  let metadataObject = metadataObjects.first,
                  let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { return }
            
            parent.startScanning = false
            
            let result = QRModel(content: stringValue, createdDate: Date())
            
            Documents.shared.append(result, in: .qrDataPath)
            Ads.shared.present {
                self.parent.completion(.success(result))
            }
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
            startCapturing()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            stopCapturing()
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
        
        // Methods for capturing
        private func startCapturing() {
            if !captureSession.isRunning {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.captureSession.startRunning()
                }
            }
        }
        
        private func stopCapturing() {
            if captureSession.isRunning {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.captureSession.stopRunning()
                }
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
