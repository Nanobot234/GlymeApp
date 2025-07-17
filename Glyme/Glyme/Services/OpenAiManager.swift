//
//  OpenAiManager.swift
//  Glyme
//
//  Created by Nana Bonsu on 6/9/25.
//

import Foundation
import SwiftOpenAI



class OpenAiManager {
    static let shared = OpenAiManager()
    let service: OpenAIService

    private init() {
        
        guard let path = Bundle.main.path(forResource: "APIkeys", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let apiKey = dict["OpenAIAPIKey"] as? String else {
            fatalError("API key not found in APIkeys.plist")  // Ensure you have the APIkeys.plist file in your project
        }
        self.service = OpenAIServiceFactory.service(apiKey: apiKey) // Initialize the OpenAI service with the API key
    }
    
    func getGeneralDiabeticAssessmentDescription(for fruitLabel: String) async throws -> String {
        let prompt = "Please provide an accurate, concise, 1 sentence general diabetic friendly assessment of \(fruitLabel). This sentence should state whether the fruit is generally considered diabetic-friendly, or not based on its glycemic index, fiber, and carbohydrate content. If it is not diabetic-friendly, please provide a brief explanation of why it is not."
        
        let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .gpt4o)
        let chatCompletion = try await service.startChat(parameters: parameters)
        
        let response = chatCompletion.choices.first?.message
       
        return response?.content ?? "No text in response."
    }
            
            
        
        
    /// Fetches the glycemic index description for a given fruit label
        func getGlycemicIndexDescription(for fruitLabel: String) async throws -> String {
                let prompt = "Please provide an accurate, concise, 1 sentence description of the  glycemic index of \(fruitLabel) and its impact on blood levels: "
            let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .gpt4o)
            let chatCompletion = try await service.startChat(parameters: parameters)
            
            let response = chatCompletion.choices.first?.message
           
            return response?.content ?? "No text in response."
            }
        
        /// Returns a description of the fiber content in the specified fruit label.
        func getFiberDescription(for fruitLabel: String) async throws -> String {
            let prompt = "Please provide an accurate, concise, 1 sentence description of the fiber content in \(fruitLabel) and its rol in regulating blood sugar: "
            let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .gpt4o)
            let chatCompletion = try await service.startChat(parameters: parameters)
            
            let response = chatCompletion.choices.first?.message
           
            return response?.content ?? "No text in response."
            }
        
        
        /// Returns a description of the carbohydrate content in the specified fruit label.
        func getCarbsDescription(for fruitLabel: String) async throws -> String {
            let prompt = "Please provide an accurate, concise, 1 sentence description of the carbohydrate content in \(fruitLabel) and portion recommendations: "
            let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .gpt4o)
            let chatCompletion = try await service.startChat(parameters: parameters)
            
            let response = chatCompletion.choices.first?.message
           
            return response?.content ?? "No text in response."
            }
        
        
        func getVitaminDescription(for fruitLabel: String) async throws -> String {
            let prompt = "Please provide an accurate , concise, 1 sentence description of the vitamin and mineral content in \(fruitLabel) and the benefits of each: "
            let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .gpt4o)
            let chatCompletion = try await service.startChat(parameters: parameters)
            
            
            
            let response = chatCompletion.choices.first?.message
            
            return response?.content ?? "No text in response."
            }
        
        /// Creates and returns a NutritionData object for the specified fruit label.

    func makeNutritionData(for fruitLabel: String) async throws -> NutritionData {
        async let glycemicIndexDescription = getGlycemicIndexDescription(for: fruitLabel)
        async let carbsDescription = getCarbsDescription(for: fruitLabel)
        async let fiberDescription = getFiberDescription(for: fruitLabel)
        async let vitaminDescription = getVitaminDescription(for: fruitLabel)
        async let generalDiabeticFriendlyAssessmentDescription = getGeneralDiabeticAssessmentDescription(for: fruitLabel)

        let newNutritionData = NutritionData(
            generalDiabeticFriendlyAssessment: try await generalDiabeticFriendlyAssessmentDescription, foodName: fruitLabel, //
            glycdemicIndexDescription: try await glycemicIndexDescription,
            carbsDescription: try await carbsDescription,
            fiberDescription: try await fiberDescription,
            vitaminDescription: try await vitaminDescription
        )
        return newNutritionData
    }
    
    /// Creates a summary of the nutritional information for the given NutritionData object that will be read by apple TTS
    func createSummaryofNutritionalInformation(for nutritionData: NutritionData) async throws -> String {
        
        let prompt = "Please summarize the nutritional information for \(nutritionData.foodName) in a concise statement based on the following data \(nutritionData.summaryofNutritionData()). Dont repeat the data woerd fdor word, but summarize it in a way that is easy to understand and remember. The summary should be no longer than 3 sentences." 
        
        let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .gpt4o)
        
        let chatCompletion = try await service.startChat(parameters: parameters)
        
        
        
        let response = chatCompletion.choices.first?.message
        
        return response?.content ?? "No text in response."
        
    }
    
}
        
        
      




