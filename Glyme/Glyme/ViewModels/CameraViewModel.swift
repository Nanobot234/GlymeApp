//
//  CameraViewModel.swift
//  Glyme
//
//  Created by Nana Bonsu on 4/15/25.
//

import Foundation
import AVFoundation
import Vision


class CameraViewModel: NSObject, ObservableObject {
    let session = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput() //
    let visionQueue = DispatchQueue(label: "visionQueue")
    @Published var detectedObject: String? = nil
    
    var onFruitDetected: ((String) -> Void)? //closure to handle detected fruit

    
    override init() {
        super.init()
        configureSession() //This is used to start the whole thing here man!!
    }
    
    
    private func configureSession() {
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
                print("Failed to access the camera or failed to create video inour")
                return
            }

            session.beginConfiguration()
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
                print("Video input added successfully.")
            } else {
                print("Failed to add video input")
                }
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
                videoOutput.videoSettings = [:]
                videoOutput.alwaysDiscardsLateVideoFrames = true
                videoOutput.setSampleBufferDelegate(self, queue: visionQueue)
            }
            session.commitConfiguration()
        }
    
    
    //this is async fucntion, starts running later!!
    func startSession() {
           if !session.isRunning {
               DispatchQueue.global(qos: .background).async {
                   self.session.startRunning()
               }
           }
       }

       func stopSession() {
           if session.isRunning {
               DispatchQueue.global(qos: .background).async {
                   self.session.stopRunning()
               }
           }
       }

       private func handleDetection(_ observations: [VNRecognizedObjectObservation]) {
           guard let bestObservation = observations.first else { return }
           let label = bestObservation.labels.first?.identifier ?? "Unknown"
           DispatchQueue.main.async {
               self.detectedObject = label
               self.onFruitDetected?(label) // Call the closure when a fruit is detected
           }
       }
    
    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .denied, .restricted:
            
            completion(false)
            print("Camera access denied or restricted.")
        @unknown default:
            completion(false)
        }
    }
        
}
extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let request = VNCoreMLRequest(model: try! VNCoreMLModel(for: GlymeFoodDetectionModelUpdated(configuration: MLModelConfiguration()).model)) { request, _ in
            if let results = request.results as? [VNRecognizedObjectObservation] {
                for result in results {
                    if let topLabel = result.labels.first {
                        print("Detected object: \(topLabel.identifier) with confidence: \(topLabel.confidence)")
                    }
                }
                self.handleDetection(results)
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
}


