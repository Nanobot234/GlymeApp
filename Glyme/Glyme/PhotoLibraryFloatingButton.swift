import SwiftUI
import PhotosUI

/// This view provides a floating button to open the photo library and detect fruits in selected images.
struct PhotoLibraryFloatingButton: View {
    
    @EnvironmentObject var cameraViewModel: CameraViewModel // Access the shared camera view model
    @State private var showPicker = false // Controls PhotosPicker presentation (not used here)
    @State private var selectedImage: UIImage? = nil // Holds the selected image from the picker
    @State private var selectedItem: PhotosPickerItem? = nil // Holds the selected PhotosPicker item
    @State private var detectedFruitLabel: String = "" // Stores the detected fruit label
    @State private var showResults = false // Controls the results sheet presentation
    @State private var isDetecting  = false // Indicates if fruit detection is in progress
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                // Floating button to open the photo picker
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
        // Handle changes to the selected photo picker item
        .onChange(of: selectedItem) { newItem in
            guard let newItem else { return }
            Task {
                // Load image data from the selected item
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                    isDetecting = true // Start detection
                    // Call fruit detection on the selected image
                    cameraViewModel.detectFruit(in: image) { fruitLabel in
                        DispatchQueue.main.async {
                            print("D fruit")
                            detectedFruitLabel = fruitLabel ?? "No fruit detected"
                        }
                        // Show results after a short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                            isDetecting = false
                            showResults = true
                        }
                    }
                }
            }
        }
        // Show a sheet with detection results or a loading indicator
        .sheet(isPresented: $showResults) {
            VStack {
                if(isDetecting) {
                    ProgressView("Detecting...") // Show while detection is running
                } else{
                    Text("Detected Fruits:")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Text(detectedFruitLabel)
                        .font(.body)
                }
            }
            .padding()
            .presentationDetents([.medium, .large]) // Allow user to resize the sheet
        }
    }
}

#Preview {
    PhotoLibraryFloatingButton()
        .environmentObject(CameraViewModel()) // Needed for preview to work
}
