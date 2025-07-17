//
//  NutrionalDetailSDataView.swift
//  Glyme
//
//  Created by Nana Bonsu on 7/13/25.
//

import SwiftUI

struct NutrionalDetailSDataView: View {
    
    @Environment(\.modelContext) private var modelContext // Use model context for SwiftData
    let nutritionData: NutritionData
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                summaryCard
                nutrientCard(
                    icon: "chart.bar.fill",
                    title: "Glycemic Index",
                    value: nutritionData.glycdemicIndexDescription,
                    color: .green
                )
                nutrientCard(
                    icon: "cube.box.fill",
                    title: "Carbohydrates",
                    value: nutritionData.carbsDescription,
                    color: .orange
                )
                nutrientCard(
                    icon: "leaf.fill",
                    title: "Fiber",
                    value: nutritionData.fiberDescription,
                    color: .blue
                )
                nutrientCard(
                    icon: "pills.fill",
                    title: "Vitamins",
                    value: nutritionData.vitaminDescription,
                    color: .purple
                )
            }
            .padding()
        }
        .navigationTitle(nutritionData.foodName)
        .onAppear {
            // Additional setup if needed
            
            // Speak the summary of nutrition data when the view appears
            
            // modelContext.insert(nutritionData) // Add nutrition data to the model context
            
            print("Carbs:\(nutritionData.carbsDescription)")
            
            
            Task {
                try await TextToSpeechManager.speak(OpenAiManager.shared.createSummaryofNutritionalInformation(for: nutritionData)) // try to speak nutritionaInfo summary
                
            }
        }
    }
    
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(nutritionData.foodName)
                .font(.title)
                .bold()
            Text(nutritionData.generalDiabeticFriendlyAssessment) //continue here!!!
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func nutrientCard(icon: String, title: String, value: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(value)
                    .font(.body)
                    .bold()
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

#Preview {
    NutritionDetailView(nutritionData:NutritionData(generalDiabeticFriendlyAssessment: "Its Diabetic Friendly", foodName: "Apple", glycdemicIndexDescription: "Low Glycemic Index", carbsDescription: "15g of Carbs", fiberDescription: "2.4g of Fiber", vitaminDescription: "Vitamin C and A"))
}

    


//#Preview {
//    NutrionalDetailSDataView(nutritionData: <#NutritionData#>)
//}
