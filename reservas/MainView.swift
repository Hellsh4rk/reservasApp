//
//  MainView.swift
//  reservas
//
//  Created by Yahir Lope on 02/01/25.
//

import SwiftUI

struct MainView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                HStack(spacing: 2) {
                    Image("lemonlogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)


                }
                .padding()
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    MainView()
}
