import SwiftUI

struct ReservationView: View {
    @EnvironmentObject var reservationModel: ReservationModel
    @Environment(\.presentationMode) var presentationMode  // Controla el modo de presentación
    @Environment(\.dismiss) private var dismiss  // Variable para cerrar la vista actual

    
    @State private var customerName: String = ""
    @State private var personCount: Int = 0
    @State private var selectedDate: Date = Date()
    
    // Estado para controlar la alerta
    @State private var showingAlert = false

    // Formato de la fecha y hora
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "es_MX")
        
        let dateStr = dateFormatter.string(from: selectedDate)
        let dateParts = dateStr.split(separator: ",")
        let dateOnly = dateParts.first ?? ""
        let timeOnly = dateParts.last?.trimmingCharacters(in: .whitespaces) ?? ""
        
        return "el \(dateOnly) a las \(timeOnly)"
    }

    var body: some View {
        VStack {
            
            Text("Reservación")
                .font(.title)
                .fontDesign(.monospaced)
                .italic(true)
                .bold(true)
            
            DatePicker("Fecha de reserva", selection: $selectedDate, in: Date()...)
                .padding()
                .foregroundColor(.accentColor)
                .font(.headline)
                .fontWeight(.bold)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                .environment(\.locale, Locale(identifier: "es_MX"))

            Form {
                TextField("Ingrese su nombre", text: $customerName)
                    .onSubmit {
                        print("Submitted")
                    }
                    .onChange(of: customerName) { newValue in
                        print(newValue)
                    }
            }
            .padding(.vertical)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            
            Stepper(value: $personCount, in: 0...15, step: 1) {
                HStack {
                    Text("Reservación para:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("\(personCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            
            if !customerName.isEmpty && personCount > 0 {
                Text("Reservación a nombre de: \(customerName) para \(personCount) \(personCount == 1 ? "persona" : "personas") \(formattedDate)")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }

            Spacer()

            Button(action: {
                // Verificamos si la reservación tiene los datos completos
                if !customerName.isEmpty && personCount > 0 {
                    // Actualizamos los detalles de la reservación en el modelo
                    reservationModel.hasReservation = true
                    reservationModel.reservationDetails = "Reservación a nombre de: \(customerName), para \(personCount) persona(s) \(formattedDate)"
                    print("Reservación confirmada: \(reservationModel.reservationDetails)")
                    
                    // Esta es una forma de hacer que la vista se actualice correctamente
                    showingAlert = true
                } else {
                    // Si faltan datos, no hacemos nada o mostramos un mensaje de error
                    print("Por favor complete todos los campos")
                }
            }) {
                Text("Confirmar Reservación")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .disabled(personCount == 0 || customerName.isEmpty)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .padding()
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Confirmación de Reservación"),
                message: Text(reservationModel.reservationDetails),
                dismissButton: .default(Text("OK"), action: {
                    dismiss()
                })
            )
        }
    }
}

#Preview {
    ReservationView()
        .environmentObject(ReservationModel())  
}
