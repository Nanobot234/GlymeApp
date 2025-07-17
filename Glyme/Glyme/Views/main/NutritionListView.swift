//
//  NutritionDataHistoryView.swift
//  Glyme
//
//  Created by Nana Bonsu on 7/10/25.
//

import SwiftUI
import SwiftData
/// A view to display a list of nutrition data history
struct NutritionListView: View {
    
    
    @Query var scannedFruitItems: [NutritionData] // Query to fetch all NutritionData objects from the database
    var body: some View {
        NavigationStack {
            List(scannedFruitItems) { item in
                NavigationLink(value: item) {
                    VStack(alignment: .leading) {
                        Text(item.foodName)
                            .font(.headline)
                        Text(item.generalDiabeticFriendlyAssessment)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Your Fruit History")
            .navigationDestination(for: NutritionData.self) { item in
                
                
                NutritionDetailView(nutritionData: item)
                //can continue from here and test too!
            }
            
        }
    }
}

//#Preview {
//    NutritionListView(_destinations: NutritionData.all()) // Preview with all NutritionData objects
//}






