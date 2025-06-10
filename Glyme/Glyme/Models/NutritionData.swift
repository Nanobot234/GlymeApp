//
//  NutritionData.swift
//  Glyme
//
//  Created by Nana Bonsu on 5/25/25.
//

import Foundation


// NutritionData model to hold nutritional information about food items that are scanned or selected
struct NutritionData: Identifiable {
    var id: UUID = UUID() // Unique identifier for each nutrition data instance
    
    
    
    var foodName: String
    var glycdemicIndexDescription: String // Glycemic Index Description and imp[act on bloodlevels
    var carbsDescription: String // Carbs Description
    var fiberDescription: String // Fiber Description
    var vitaminDescription: String // Vitamin Description
    
}
