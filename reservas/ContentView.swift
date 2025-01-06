import SwiftUI

struct ContentView: View {
    @StateObject private var reservationModel = ReservationModel()  // Crea la instancia del modelo de reserva
    
    // Lista de ubicaciones
    let locations = [
        ("Los Angeles", "123 Hollywood Blvd, Los Angeles, CA"),
        ("New York", "456 Broadway Ave, New York, NY"),
        ("Miami", "789 Ocean Dr, Miami, FL"),
        ("San Francisco", "101 Market St, San Francisco, CA")
    ]
    
    var body: some View {
        NavigationView {  // Solo un NavigationView que envuelve todo el TabView
            TabView {
                // Vista de la página principal
                MainPageView(locations: locations)
                    .tabItem {
                        Label("Página Principal", systemImage: "house")
                    }

                // Vista de las reservaciones
                ReservacionesView()
                    .environmentObject(reservationModel) // Pasa el modelo al entorno
                    .tabItem {
                        Label("Reservaciones", systemImage: "calendar")
                    }
            }
        }
    }
}

struct MainPageView: View {
    let locations: [(String, String)]  // Recibe la lista de ubicaciones
    
    var body: some View {
        VStack {
            Image("lemonlogo") // Asegúrate de tener esta imagen
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.top, 20)
            
            Spacer()
            
            Text("Seleccione una ubicación")
                .font(.headline)
                .padding()
            
            List(locations, id: \.1) { city, address in
                NavigationLink(destination: LocationDetailView(location: address)) {
                    VStack(alignment: .leading) {
                        Text(city)
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
            }
            .listStyle(PlainListStyle())
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct LocationDetailView: View {
    let location: String
    
    var body: some View {
        VStack {
            Text("Bienvenido a la sucursal:")
                .font(.headline)
                .padding(.top, 40)
            
            Text(location)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Spacer()
        }
        .navigationTitle("Detalles de ubicación")  // Esto activa el botón de retroceso
        .padding()
    }
}

struct ReservacionesView: View {
    @EnvironmentObject var reservationModel: ReservationModel

    var body: some View {
        VStack {
            if reservationModel.hasReservation {
                Text("Tienes una reservación activa:")
                    .font(.title)
                    .padding()
                
                Text(reservationModel.reservationDetails)
                    .font(.body)
                    .padding()
                
                Button(action: {
                    // Cancelar la reservación
                    reservationModel.hasReservation = false
                    reservationModel.reservationDetails = ""
                    print("Reservación cancelada")
                }) {
                    Text("Cancelar Reservación")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            } else {
                Text("No tienes una reservación activa.")
                    .font(.title)
                    .padding()
                
                NavigationLink(destination: ReservationView()) {
                    Text("Hacer una nueva reservación")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            }

            // Depuración: Verifica el estado y los detalles
            Text("Estado de la reservación: \(reservationModel.hasReservation ? "Sí" : "No")")
                .padding()
            Text("Detalles: \(reservationModel.reservationDetails)")
                .padding()
                .foregroundColor(.green)
        }
        .padding()
        .onAppear {
            print("Viendo los detalles de la reservación")
            print("Detalles actuales: \(reservationModel.reservationDetails)")
        }
        .onChange(of: reservationModel.hasReservation) { newValue in
            print("Cambio en el estado de la reservación: \(newValue ? "Sí" : "No")")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ReservationModel())  // Asegúrate de pasar el environmentObject aquí también
}
