//
//  PhotoLibraryFloatingButton.swift
//  Glyme
//
//  Created by Nana Bonsu on 5/7/25.
//

import SwiftUI
import PhotosUI

struct PhotoLibraryFloatingButton: View {
    
    @EnvironmentObject var cameraViewModel: CameraViewModel
    @State private var showPicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var detectedFruitLabel: String = ""
    @State private var showResults = false
    @State private var isDetecting  = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(24)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.leading, 20)
                .padding(.bottom, 40)
                Spacer()
            }
        }
        .onChange(of: selectedItem) { newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                    isDetecting = true
                    cameraViewModel.detectFruit(in: image) { fruitLabel in
                        DispatchQueue.main.async {
                            print("D fruit")
                            detectedFruitLabel = fruitLabel ?? "No fruit detected"
                            
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                            isDetecting = false
                            showResults = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showResults) {
            VStack {
                if(isDetecting) {
                    ProgressView("Detecting...")
                } else{
                    Text("Detected Fruits:")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Text(detectedFruitLabel)
                        .font(.body)
                }
            }
            .padding()
            .presentationDetents([.medium, .large]) // Allows for medium and large sheets, the user can swipe up to see more
        
    }
    }
}

#Preview {
    PhotoLibraryFloatingButton()
        .environmentObject(CameraViewModel()) // Needed for preview to work
}

