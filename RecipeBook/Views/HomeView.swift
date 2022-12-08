//
//  HomeView.swift
//  RecipeBook
//
//  Created by Kainoa Jim on 12/6/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct HomeView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
       
        TabBar()
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        
        HomeView()
        
    }
}
