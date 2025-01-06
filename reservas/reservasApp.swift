//
//  reservasApp.swift
//  reservas
//
//  Created by Yahir Lope on 30/12/24.
//

import SwiftUI

@main
struct MyApp: App {
    @StateObject private var reservationModel = ReservationModel()  // Creación de la instancia del modelo

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(reservationModel)  // Pasa el modelo al entorno aquí
        }
    }
}
