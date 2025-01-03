//
//  ReservationForm.swift
//  reservas
//
//  Created by Yahir Lope on 02/01/25.
//

import SwiftUI


struct ReservationForm: View {
    @State var customerName: String = ""
    @State var personCount: Int = 1
    var body: some View {
        VStack {
            Text("Reservación")
                .font(.title)
                .fontDesign(.monospaced)
                .italic(true)
                .bold(true)
            
            Form {
                TextField("Ingrese su nombre", text: $customerName)
                    }
                    .onSubmit {
                        print("Submitted")
                    }
                    .onChange(of: customerName) { newValue in
                        print(newValue)
            }
            Stepper {
                HStack {
                    Text("Reservación para:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("\(personCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                }
            } onIncrement: {
                personCount += 1
            } onDecrement: {
                personCount = max(1, personCount - 1)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .padding()
    }
}


#Preview {
    ReservationForm()
}
