//
//  StarsSelectionView.swift
//  RecipeBook
//
//  Created by Kainoa Jim on 12/5/22.
//

import SwiftUI

struct StarsSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var recipesVM = RecipesViewModel()
    @State var recipe: Recipe
    
    @Binding var rating: Int
    let highestRating = 5
    let unselected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    let font: Font = .title
    let fillColor: Color = .red
    let emptyColor: Color = .gray
    var body: some View {
        HStack {
            ForEach(1...highestRating, id: \.self) { number in
                showStar(for: number)
                    .foregroundColor(number <= rating ? fillColor : emptyColor)
                    .onTapGesture {
                        rating = number
                    }
            }
            .font(font)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task {
                        let success = await recipesVM.saveRecipe(recipe: recipe)
                        if success {
                            dismiss()
                        } else {
                            print("😡 ERROR saving data in ReviewView")
                        }
                    }
                }
            }
        }
    }
    func showStar(for number: Int) -> Image {
        if number > rating {
            return unselected
        } else {
            return selected
        }
    }
}

struct StarsSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StarsSelectionView(recipe: Recipe(), rating: .constant(4))
        }
    }
}
