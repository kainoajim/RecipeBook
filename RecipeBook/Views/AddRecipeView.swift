//
//  AddRecipeView.swift
//  RecipeBook
//
//  Created by Kainoa Jim on 12/7/22.
//

import SwiftUI

struct AddRecipeView: View {
    var body: some View {
        NavigationStack {
            NavigationLink {
                NewRecipeView(recipe: Recipe())
            } label: {
                Text("Add a Recipe!")
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("RecipeColor"))
            .font(.title)

        }
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
