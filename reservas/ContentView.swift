//
//  ContentView.swift
//  reservas
//
//  Created by Yahir Lope on 30/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // Pestaña de Página Principal
            MainPageView()
                .tabItem {
                    Label("Página Principal", systemImage: "house")
                }
            
            // Pestaña de Menú
            MenuView()
                .tabItem {
                    Label("Menú", systemImage: "list.bullet")
                }
        }
    }
}

struct MainPageView: View {
    var body: some View {
        VStack {
            Text("Little Lemon")
                .font(.largeTitle)
                .padding()
            
            Text("Página Principal")
                .font(.title2)
                .padding()
        }
    }
}

struct MenuView: View {
    var body: some View {
        VStack {
            Text("Menú")
                .font(.largeTitle)
                .padding()
            
            Text("Aquí va el contenido del menú.")
                .font(.title2)
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
