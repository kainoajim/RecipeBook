//
//  Recipe.swift
//  RecipeBook
//
//  Created by Kainoa Jim on 11/29/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


enum Category: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case breakfast = "breakfast"
    case soup = "soup"
    case salad = "salad"
    case appetizer = "appetizer"
    case main = "main"
    case side = "side"
    case dessert = "dessert"
    case snack = "snack"
    case lunch = "lunch"
    case drink = "drink"
}


struct Recipe: Identifiable, Codable {
    @DocumentID var id: String?
    
    var recipeName = ""
    var ingredients = ""
    var instructions = ""
    var time = ""
    var rating = 0
    var category: Category.RawValue = Category.main.rawValue
    var userID = Auth.auth().currentUser?.uid
    
//    var selectedImage = Image(systemName: "photo")
//    var image = ""
    
    var dictionary: [String: Any] {
        return ["recipeName": recipeName, "ingredients": ingredients, "instructions": instructions, "time": time, "rating": rating, "category": category, "userID": userID!]
    }
    
}
