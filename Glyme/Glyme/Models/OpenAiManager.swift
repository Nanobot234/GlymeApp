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
        
        
        func getGlycemicIndexDescription(for fruitLabel: String) async throws -> String {
                let prompt = "Please provide an accurate glycemic index of \(fruitLabel) and its impact on blood levels: "
            let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .gpt4o)
            let chatCompletion = try await service.startChat(parameters: parameters)
            
            let response = chatCompletion.choices.first?.message
           
            return response?.content ?? "No text in response."
            }
        
        func getFiberDescription(for fruitLabel: String) async throws -> String {
            let prompt = "Please provide an accurate description of the fiber content in \(fruitLabel) and its rol in regulating blood sugar: "
            let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .gpt4o)
            let chatCompletion = try await service.startChat(parameters: parameters)
            
            let response = chatCompletion.choices.first?.message
           
            return response?.content ?? "No text in response."
            }
        
        
        
        func getCarbsDescription(for fruitLabel: String) async throws -> String {
            let prompt = "Please provide an accurate description of the carbohydrate content in \(fruitLabel) and portion recommendations: "
            let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .gpt4o)
            let chatCompletion = try await service.startChat(parameters: parameters)
            
            let response = chatCompletion.choices.first?.message
           
            return response?.content ?? "No text in response."
            }
        
        
        func getVitaminDescription(for fruitLabel: String) async throws -> String {
            let prompt = "Please provide an accurate description of the vitamin content in \(fruitLabel) and its benefits: "
            let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .gpt4o)
            let chatCompletion = try await service.startChat(parameters: parameters)
            
            let response = chatCompletion.choices.first?.message
           
            return response?.content ?? "No text in response."
            }
        
        
        func makeNutritionData(for fruitLabel: String) async throws -> NutritionData {
            
            let glycemicIndexDescription = try await getGlycemicIndexDescription(for: fruitLabel)
            
            let carbsDescription = try await getCarbsDescription(for: fruitLabel)
            let fiberDescription = try await getFiberDescription(for: fruitLabel)
            
            let vitaminDescription = try await getVitaminDescription(for: fruitLabel)
            
            // Create and return the NutritionData object
            let newNutritionData = NutritionData(foodName: fruitLabel, glycdemicIndexDescription: glycemicIndexDescription, carbsDescription: carbsDescription, fiberDescription: fiberDescription, vitaminDescription: vitaminDescription)
            
            return newNutritionData
        }
                
    
}
        
        
      




