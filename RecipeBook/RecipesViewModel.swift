//
//  RecipeViewModel.swift
//  RecipeBook
//
//  Created by Kainoa Jim on 11/29/22.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class RecipesViewModel: ObservableObject {
    @Published var recipesArray: [Recipe] = []
    
    func saveRecipe(recipe: Recipe) async -> Bool {
        let db = Firestore.firestore()
        
        if let id = recipe.id { // have current recipe
            do {
                let _ = try await db.collection("recipes").document(id).setData(recipe.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update date in recipes \(error.localizedDescription)")
                return false
            }
        } else { // add a new recipe
            do {
                let _ = try await db.collection("recipes").addDocument(data: recipe.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update date in recipes \(error.localizedDescription)")
                return false
            }
        }
        
    }
    
    func saveImage(id: String, image: UIImage) async {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id)/image.jpeg")
        
        let resizedImage = image.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        if let resizedImage = resizedImage {
            do {
                let result = try await storageRef.putDataAsync(resizedImage)
                print("Metadata = \(result)")
                print("📸 Image Saved!")
            } catch {
                print("😡 ERROR: uploading image to FirebaseStorage \(error.localizedDescription)")
            }
        }
    }
    
    func getImageURL(id: String) async -> URL? {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id)/image.jpeg")
        
        do {
            let url = try await storageRef.downloadURL()
            return url
        } catch {
            print("😡 ERROR: Could not get a downloadURL")
            return nil
        }
    }
    
    func deleteRecipe(recipe: Recipe) async {
        let db = Firestore.firestore()
        guard let id = recipe.id else {
            print("😡 ERROR: Could not delete document \(recipe.id ?? "No ID!")")
            return
        }
        do {
            let _ = try await db.collection("recipes").document(id).delete()
            print("🗑 Document successfully removed!")
        } catch {
            print("😡 ERROR: removing document \(error.localizedDescription)")
        }
    }
    
}


