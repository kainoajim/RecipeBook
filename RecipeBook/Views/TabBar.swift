//
//  TabView.swift
//  RecipeBook
//
//  Created by Kainoa Jim on 12/6/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct TabBar: View {
    
//    @FirestoreQuery(collectionPath: "recipes") var recipes: [Recipe]
    
    var body: some View {
        
        TabView {
            RecipeListView(recipesVM: RecipesViewModel(), categoryRecipes: [Recipe()], isCategory: false)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            CategoryView()
                .tabItem {
                    Label("Categories", systemImage: "square.fill.text.grid.1x2")
                }
            
            AddRecipeView()
                .tabItem {
                    Label("New", systemImage: "plus")
                }
        }
        
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
