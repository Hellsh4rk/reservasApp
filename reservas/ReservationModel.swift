//
//  ReservationModel.swift
//  reservas
//
//  Created by Yahir Lope on 06/01/25.
//


import SwiftUI

// Modelo que maneja el estado global de la reservación
class ReservationModel: ObservableObject {
    @Published var hasReservation: Bool = false
    @Published var reservationDetails: String = ""
}