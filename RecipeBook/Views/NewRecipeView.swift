//
//  NewRecipeView.swift
//  RecipeBook
//
//  Created by Kainoa Jim on 12/5/22.
//

import SwiftUI
import PhotosUI

struct NewRecipeView: View {
    
    @State var recipe: Recipe
    @StateObject var recipesVM = RecipesViewModel()
    
    @State var selectedImage = Image(systemName: "photo")
    @State var selectedPhoto: PhotosPickerItem?
    @State private var imageURL: URL?
    @State private var selectedCategory: Category = .main
    
    @State private var name = ""
    @State private var time = ""
    
    @State private var ingredients = ""
    @State private var instructions = ""
    
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("name", text: $recipe.recipeName, axis: .vertical)
                }
                Section(header: Text("Time")) {
                    TextField("time", text: $recipe.time, axis: .vertical)
                }
                Section(header: Text("Category")) {
                    Picker("", selection: $recipe.category) {
                        ForEach(Category.allCases) { category in
                            Text(category.rawValue.capitalized)
                                .font(.largeTitle)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section(header: Text("Ingredients")) {
                    TextField("ingredients", text: $recipe.ingredients, axis: .vertical)
                }
                Section(header: Text("Instructions")) {
                    TextField("instructions", text: $recipe.instructions, axis: .vertical)
                }
                Section(header: Text("Photo")) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        Image(systemName: "photo.fill.on.rectangle.fill")
                    }
                    .onChange(of: selectedPhoto) { newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    
                                    if let uiImage = UIImage(data: data) {
                                        selectedImage = Image(uiImage: uiImage)
                                        imageURL = nil
                                    }
                                }
                            } catch {
                                print("😡 ERROR: loading failes \(error.localizedDescription)")
                            }
                        }
                    }
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
            }
            .task {
                if let id = recipe.id {
                    if let url = await recipesVM.getImageURL(id: id) {
                        imageURL = url
                    }
                }
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarBackButtonHidden()
            .toolbar {
                
                ToolbarItem (placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem (placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let success = await recipesVM.saveRecipe(recipe: recipe)
                            print("\(String(describing: recipe.id))")
                            if success {
                                if let id = recipe.id {
                                    let uiImage = ImageRenderer(content: selectedImage).uiImage ?? UIImage()
                                    
                                    let _ = print("Hello")
                                    
                                    await recipesVM.saveImage(id: id, image: uiImage)
                                }
                                print("Hello Dismiss")
                                dismiss()
                            } else {
                                print("😡 DANG! Could not save the recipe!")
                            }
                        }
                    }
                    
                }
                
            }
        }
        
        
        //        ScrollView {
        //            LazyVStack(alignment: .leading) {
        //                Group {
        //                    TextField("Recipe Name", text: $recipe.recipeName, axis: .vertical)
        //                        .font(.largeTitle)
        //                        .fontWeight(.bold)
        //                        .overlay {
        //                            RoundedRectangle(cornerRadius: 5)
        //                                .stroke(.gray.opacity(0.5), lineWidth: 2)
        //                        }
        //                        .padding(.bottom)
        //
        //
        //                    TextField("Time", text: $recipe.time)
        //                        .font(.title)
        //                        .fontWeight(.light)
        //                        .overlay {
        //                            RoundedRectangle(cornerRadius: 5)
        //                                .stroke(.gray.opacity(0.5), lineWidth: 2)
        //                        }
        //                }
        //
        //                HStack {
        //                    Text("Category")
        //                        .font(.title3)
        //
        //                    Picker("Category", selection: $recipe.category) {
        //                        ForEach(Category.allCases) { category in
        //                            Text(category.rawValue.capitalized)
        //                                .font(.largeTitle)
        //                        }
        //                    }
        //                    .pickerStyle(.automatic)
        //                }
        //
        //                Text("Ingredients")
        //                    .font(.title2)
        //                    .bold()
        //
        //                TextField("Ingredients", text: $recipe.ingredients, axis: .vertical)
        //                    .frame(maxHeight: .infinity, alignment: .topLeading)
        //                    .overlay {
        //                        RoundedRectangle(cornerRadius: 5)
        //                            .stroke(.gray.opacity(0.5), lineWidth: 2)
        //                    }
        //
        //                HStack {
        //                    Text("Recipe Image")
        //                        .bold()
        //
        //                    Spacer()
        //        //
        //                            PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
        //                                Image(systemName: "photo.fill.on.rectangle.fill")
        //                            }
        //                            .onChange(of: selectedPhoto) { newValue in
        //                                Task {
        //                                    do {
        //                                        if let data = try await newValue?.loadTransferable(type: Data.self) {
        //
        //                                            if let uiImage = UIImage(data: data) {
        //                                                selectedImage = Image(uiImage: uiImage)
        //                                                imageURL = nil
        //                                            }
        //                                        }
        //                                    } catch {
        //                                        print("😡 ERROR: loading failes \(error.localizedDescription)")
        //                                    }
        //                                }
        //                            }
        //                        }
        //                        if imageURL != nil {
        //                            AsyncImage(url: imageURL) { image in
        //                                image
        //                                    .resizable()
        //                                    .scaledToFit()
        //                            } placeholder: {
        //                                Image(systemName: "photo")
        //                                    .resizable()
        //                                    .scaledToFit()
        //                            }
        //
        //                        } else {
        //                            selectedImage
        //                                .resizable()
        //                                .scaledToFit()
        //                        }
        //                Spacer()
        //            }
        //            .navigationBarTitle("New Recipe")
        //        }
        //        .padding(.horizontal)
        //        .font(.title2)
        //                .toolbar {
        //                    ToolbarItem (placement: .cancellationAction) {
        //                        Button("Cancel") {
        //                            dismiss()
        //                        }
        //                    }
        //                    ToolbarItem (placement: .navigationBarTrailing) {
        //                        Button("Save") {
        //                            Task {
        //                                let success = await recipesVM.saveRecipe(recipe: recipe)
        //                                if success {
        //                                    if let id = recipe.id {
        //                                        let uiImage = ImageRenderer(content: selectedImage).uiImage ?? UIImage()
        //                                        await recipesVM.saveImage(id: id, image: uiImage)
        //                                    }
        //                                    dismiss()
        //                                } else {
        //                                    print("😡 DANG! Could not save the recipe!")
        //                                }
        //                            }
        //                        }
        //                    }
        //                }
    }
}

struct NewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewRecipeView(recipe: Recipe())
        }
    }
}
