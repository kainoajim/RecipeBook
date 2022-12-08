//
//  CategoryView.swift
//  RecipeBook
//
//  Created by Kainoa Jim on 12/6/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct CategoryView: View {
    
    @FirestoreQuery(collectionPath: "recipes") var recipes: [Recipe]
    
    //    @State var recipes: [Recipe]
    //    @State private var category: Categories
    
    var body: some View {
        ZStack {
            Color("RecipeColor")
                .ignoresSafeArea()
            NavigationStack {
                List {
                    ForEach(Category.allCases) { category in
                        NavigationLink {
                            let _ = print(recipes.filter( {$0.category == category.rawValue} ))
                            //                        ScrollView {
                            RecipeListView(recipesVM: RecipesViewModel(), categoryRecipes: recipes.filter( {$0.category == category.rawValue} ), isCategory: true)
                            //                        }
                        } label: {
                            HStack {
                                Image(systemName: "fork.knife.circle")
                                    .font(.title)
                                Text(category.rawValue.capitalized)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                            }
                            
                            
                            
                        }
//                        .foregroundColor(Color("RecipeColor"))
                        
                    }
                }
//                .scrollContentBackground(.hidden)
//                .background(Color("RecipeColor"))
                .navigationTitle("Categories")
                .listStyle(.plain)
            }
        }
        
        
        
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
