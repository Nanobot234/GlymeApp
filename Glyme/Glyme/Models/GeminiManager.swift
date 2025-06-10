////
////  GeminiManager.swift
////  Glyme
////
////  Created by Nana Bonsu on 5/25/25.
////
//
//import Foundation
////import FirebaseAI
//
//
//
//class GeminiManager {
//    
//    static let shared = GeminiManager()
//    
//    
//   
//    let ai: FirebaseAI // Declare FirebaseAI instance
//    let model: GenerativeModel // Declare GenerativeModel instance
//    
//    private init() {
//        self.ai = FirebaseAI.firebaseAI(backend: .googleAI()) // Initialize Firebase AI with Google AI backend
//        
//        self.model = ai.generativeModel(modelName: "gemini-2.0-flash") // Specify the model name that you want to use
//    }
//    
//
//    
//    func getGlycemicIndexDescription(for fruitLabel: String) async throws -> String {
//        let prompt = "Please provide an accurate glycemic index of \(fruitLabel) and its impact on blood levels: "
//        let response = try await model.generateContent(prompt)
//        return response.text ?? "No text in response."
//    }
//
//    func getCarbsDescription(for fruitLabel: String) async throws -> String {
//        let prompt = "Please provide an accurate description of the carbohydrate content in \(fruitLabel) and portion recommendations: "
//        let response = try await model.generateContent(prompt)
//        return response.text ?? "No text in response."
//    }
//    
//    func getFiberDescription(for fruitLabel: String) async throws -> String {
//     
//        let prompt = "Please provide an accurate description of the fiber content in \(fruitLabel) and its rol in regulating blood sugar: "
//        let response = try await model.generateContent(prompt)
//        return response.text ?? "No text in response."
//    }
//    
//    func getVitaminDescription(for fruitLabel: String) async throws -> String {
//        
//        let prompt = "Please provide an accurate description of the vitamin content in \(fruitLabel) and its benefits: "
//        let response = try await model.generateContent(prompt)
//        
//        return response.text ?? "No text in response."
//    }
//    
//    
//    func makeNutritionData(for fruitLabel: String) async throws -> NutritionData {
//        
//        let glycemicIndexDescription = try await getGlycemicIndexDescription(for: fruitLabel)
//        
//        let carbsDescription = try await getCarbsDescription(for: fruitLabel)
//        let fiberDescription = try await getFiberDescription(for: fruitLabel)
//        
//        let vitaminDescription = try await getVitaminDescription(for: fruitLabel)
//        
//        // Create and return the NutritionData object
//        let newNutritionData = NutritionData(foodName: fruitLabel, glycdemicIndexDescription: glycemicIndexDescription, carbsDescription: carbsDescription, fiberDescription: fiberDescription, vitaminDescription: vitaminDescription)
//        
//        return newNutritionData
//        
//        
//        
//        
//    }
//
//    
//    //will have a  fucntion somewhere here, to make nutritoon data object!
//    
//    
//    
//}
