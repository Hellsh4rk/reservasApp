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
                        .frame(width: 80, height: 80)

                    Text("Little Lemon")
                        .font(.system(size: 20))
                        .frame(width: 120, height: 120, alignment: .center)
                        .multilineTextAlignment(.center)
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
