//
//  ContentView.swift
//  Glyme
//
//  Created by Nana Bonsu on 4/11/25.
//
import SwiftUI
import AVFoundation
import Vision
import UIKit

struct CameraContentView: View {
    
    
    @EnvironmentObject var cameraViewModel: CameraViewModel
    @EnvironmentObject var openaiViewModel: OpenAIViewModel // Environment object for Gemini view model
    @State private var showMessage = true //shows a message for the user to point
    @State private var detectedFruit: String? = nil //shows the detected fruit
    @State private var showSheet = false //shows the sheet with the detected fruit
    
    
    var body: some View {
        
        ZStack {
            CameraPreview(session: cameraViewModel.session)
                .ignoresSafeArea(.all)
            
            VStack {
                if(showMessage) {
                    Text("Point the camera at an item to scan it")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.top, 50)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                            showMessage = false
                                                        }
                        }
                    
                }
            }
            Spacer()
            HStack {
                Spacer()
                PhotoLibraryFloatingButton()
                    .padding(.trailing, 20)
                    .padding(.bottom, 40)
            }
                
        }
            
            
            
                .onAppear {
                    cameraViewModel.onFruitDetected =  { fruit in
                        Task {
                            await handleDetectedFruit(fruit) // Call the async function to handle detected fruit
                        }
                        
                    } //this sets the closuyre to the right fucntion
                        
                    requestCameraPermission { granted in
                        if granted {
                            cameraViewModel.startSession()
                            print("Camera session started!")
                            if cameraViewModel.session.isRunning {
                                print("Camera session is running.")
                            } else {
                                print("Camera session is not running.")
                            }
                            
                        } else {
                            print("Camera access denied.")
                        }
                        
                        
                        //start the live video session, to scan the item??
                        
                    }
                }
                .onDisappear {
                    cameraViewModel.stopSession()
                }
                .sheet(isPresented: Binding(
                    get: { showSheet && (openaiViewModel.isLoading || openaiViewModel.currentNutritionData != nil) },
                    set: { showSheet = $0 }
                )) {
                    if openaiViewModel.isLoading || openaiViewModel.currentNutritionData == nil {
                        ProgressView("Loading nutrition data...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .presentationDetents([.medium, .large])
                    } else {
                        NutritionDetailView(nutritionData: openaiViewModel.currentNutritionData!)
                    }
                }

        }
        
    func handleDetectedFruit(_ fruit: String) async {
        
        // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        detectedFruit = fruit
           showSheet = true
        await openaiViewModel.getNutritionDataForFruit(for: fruit) // Fetch nutrition data for the detected fruit
        
//        await geminiViewModel.getNutritionDataForFruit(for: detectedFruit ?? "") // Fetch nutrition data for the detected fruit
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
    

    
    struct CameraPreview: UIViewRepresentable {
        let session: AVCaptureSession
        
        class VideoPreviewView: UIView {
            override class var layerClass: AnyClass {
                AVCaptureVideoPreviewLayer.self
            }
            
            var previewLayer: AVCaptureVideoPreviewLayer {
                return layer as! AVCaptureVideoPreviewLayer
            }
            
            func configure(session: AVCaptureSession) {
                previewLayer.session = session
                previewLayer.videoGravity = .resizeAspectFill
            }
        }
        
        func makeUIView(context: Context) -> VideoPreviewView {
            let view = VideoPreviewView()
            view.configure(session: session)
            return view
        }
        
        func updateUIView(_ uiView: VideoPreviewView, context: Context) {
            uiView.previewLayer.session = session
        }
    }


#Preview {
    
    
    CameraContentView()
        .environmentObject(CameraViewModel())
        
}



//struct CameraPreview: UIViewRepresentable {
//    let session: AVCaptureSession
//
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame = view.bounds
//
//        //need to check if its on the main layer here!!
//        view.layer.addSublayer(previewLayer)
//        context.coordinator.previewLayer = previewLayer
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        // Update the preview layer's frame if the view's size changes
//        context.coordinator.previewLayer?.frame = uiView.bounds
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//
//    class Coordinator {
//        var previewLayer: AVCaptureVideoPreviewLayer?
//    }
//}
 
//
//struct CameraPreview: UIViewRepresentable {
//    let session: AVCaptureSession
//
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame = view.bounds
//        view.layer.addSublayer(previewLayer)
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {}
//}
