//
//  NutritionDetailView.swift
//  Glyme
//
//  Created by Nana Bonsu on 5/28/25.
//

import SwiftUI

struct NutritionDetailView: View {
    
    let nutritionData: NutritionData
        
    var body: some View {
    
//       NavigationView {
        Form {
                   Section(header: sectionHeader("Glycemic Index")) {
                       styledText(nutritionData.glycdemicIndexDescription)
                   }
                   Section(header: sectionHeader("Carbohydrates")) {
                       styledText(nutritionData.carbsDescription)
                   }
                   Section(header: sectionHeader("Fiber")) {
                       styledText(nutritionData.fiberDescription)
                   }
                   Section(header: sectionHeader("Vitamins")) {
                       styledText(nutritionData.vitaminDescription)
                   }
               }
               .navigationTitle(nutritionData.foodName)
               .background(Color(.systemGroupedBackground))
           }

    // the header
           private func sectionHeader(_ title: String) -> some View {
               Text(title)
                   .font(.headline)
                   .foregroundColor(.accentColor)
                   .padding(.vertical, 4)
           }

    // the text in the section that is styled
           private func styledText(_ text: String) -> some View {
               Text(text)
                   .font(.body)
                   .foregroundColor(.primary)
                   .padding(8)
                   .background(Color(.secondarySystemBackground))
                   .cornerRadius(8)
           }
    
}

#Preview {
    NutritionDetailView(nutritionData:NutritionData(foodName: "Apple", glycdemicIndexDescription: "Low Glycemic Index", carbsDescription: "15g of Carbs", fiberDescription: "2.4g of Fiber", vitaminDescription: "Vitamin C and A"))
    }
