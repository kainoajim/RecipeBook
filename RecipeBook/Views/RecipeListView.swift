//
//  RecipeView.swift
//  RecipeBook
//
//  Created by Kainoa Jim on 11/29/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct RecipeListView: View {
    @StateObject var recipesVM: RecipesViewModel
    @FirestoreQuery(collectionPath: "recipes") var recipes: [Recipe]
    
    @State var categoryRecipes: [Recipe]
    @State var isCategory: Bool
    
    @Environment(\.dismiss) private var dismiss
    @State private var sheetIsPresented = false
    
    var body: some View {
        NavigationStack {
            List {
                if isCategory {
                    ForEach(categoryRecipes) { recipe in
                        NavigationLink {
                            RecipeView(recipesVM: RecipesViewModel(), recipe: recipe)
                        } label: {
                            Text(recipe.recipeName)
                                .font(.title2)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        guard let index = indexSet.first else {return}
                        Task {
                            await recipesVM.deleteRecipe(recipe: recipes[index])
                        }
                    })
                } else {
                    ForEach(recipes) { recipe in
                        NavigationLink {
                            RecipeView(recipesVM: RecipesViewModel(), recipe: recipe)
                        } label: {
                            Text(recipe.recipeName)
                                .font(.title2)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        guard let index = indexSet.first else {return}
                        Task {
                            let _ = print("\(String(describing: recipes[index].id))")
                            await recipesVM.deleteRecipe(recipe: recipes[index])
                        }
                    })
                }
            }
            .navigationTitle("Recipes")
            .listStyle(.plain)
            .toolbar {
                if !isCategory {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Sign Out") {
                            do {
                                try Auth.auth().signOut()
                                print("🪵➡️ Log out successful")
                                dismiss()
                            } catch {
                                print("😡 ERROR: Could not sign out")
                            }
                        }
                    }
                }
            }
            
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        sheetIsPresented.toggle()
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//
//                }
//            }
//            .sheet(isPresented: $sheetIsPresented) {
//                NavigationStack {
//                    RecipeView(recipe: Recipe())
//                }
//            }
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeListView(recipesVM: RecipesViewModel(), categoryRecipes: [Recipe()], isCategory: false)
        }
    }
}
