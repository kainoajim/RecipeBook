//
//  RecipeView.swift
//  RecipeBook
//
//  Created by Kainoa Jim on 11/29/22.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestoreSwift

struct RecipeView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var recipesVM: RecipesViewModel
    
    @State var recipe: Recipe
    @State var selectedImage = Image(systemName: "photo")
    @State var selectedPhoto: PhotosPickerItem?
    @State private var imageURL: URL?
    @State private var showRatingViewSheet = false
    @State private var categorySelection: Category = .breakfast
    @State private var isSheetPresented = false
    
    var body: some View {
        ScrollView {
            LazyVStack (alignment: .leading) {
                //shows recipe category and time
                Group {
                    
                    Text("Category - \(recipe.category.capitalized)")
                        .font(.title2)
                        .bold()

                    Text("Time - \(recipe.time)")
                        .font(.title2)
                        .fontWeight(.light)
                }
                Text("Ingredients")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                //shows the recipe ingredients
                Text(recipe.ingredients)
                    .padding(.top, 1)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                
                Text("Instructions")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                //shows the recipe instructions
                Text(recipe.instructions)
                    .font(.title2)
                    .padding(.top, 1)
                
                
                Text("Recipe Image:")
                    .font(.title)
                    .bold()
                    .padding(.top)

                //this shows the image
                if imageURL != nil {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    }
                } else {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                }
            }
            .toolbar {
                if Auth.auth().currentUser?.uid == recipe.userID {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Edit") {
                            isSheetPresented.toggle()
                        }
                    }
                }
            }
        }
        .task {
            if let id = recipe.id {
                if let url = await recipesVM.getImageURL(id: id) {
                    imageURL = url
                }
            }
        }
        .navigationBarTitle(recipe.recipeName)
        .padding(.horizontal)
        .sheet(isPresented: $showRatingViewSheet) {
            NavigationStack {
                StarsSelectionView(recipe: recipe, rating: $recipe.rating)
            }
        }
        .fullScreenCover(isPresented: $isSheetPresented) {
            NavigationStack {
                NewRecipeView(recipe: recipe)
            }
        }
        
    }
}



struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeView(recipesVM: RecipesViewModel(), recipe: Recipe(id: UUID().uuidString, recipeName: "Chicken Parmesan", ingredients: "Chicken, Breading, Parmesan Cheese, Tomato Sauce", instructions: "Slice the chicken into thin pieces. Break 2 eggs. Get your bread crumbs. Dip the pieces in the egg mix then into the bread crumbs.", time: "45 Minutes", rating: 4))
                .environmentObject(RecipesViewModel())
        }
    }
}

