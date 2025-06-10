////
////  GeminiViewModel.swift
////  Glyme
////
////  Created by Nana Bonsu on 5/23/25.
////
//
//import SwiftUI
//
////View mocdel
//class GeminiViewModel:ObservableObject {
//    
//    @Published var currentNutritionData: NutritionData? // Holds the nutrition data for the currently scanned fruit
//    @Published var isLoading: Bool = false // Indicates whether the app is currently loading data
//    
//    static let shared = GeminiViewModel() // Singleton instance for easy access throughout the app
//    init() {
//    }
//    
//    /// Fetches nutrition data for a given fruit label using GeminiManager
//    func getNutritionDataForFruit(for fruitLabel: String) async  {
//        
//        DispatchQueue.main.async {
//            self.isLoading = true // Set loading state to true when starting to fetch data
//        }
//        
//        do {
//            let nutritionData = try await GeminiManager.shared.makeNutritionData(for: fruitLabel)
//            
//            DispatchQueue.main.async {
//                self.currentNutritionData = nutritionData
//            }
//        } catch {
//            
//            print("Error fetching Gemini response: \(error)")
//            DispatchQueue.main.async {
//                self.currentNutritionData = nil // Reset currentNutritionData on error
//                self.isLoading = false // Set loading state to false on error
//            }
//            
//            
//        }
//        
//        
//        
//        
//        
//        
//    }
//}
//
//
