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
        NavigationView {
            MainPageView(locations: locations)
        }
    }
}

struct MainPageView: View {
    let locations: [(String, String)]  
    
    var body: some View {
        VStack {
            Image("lemonlogo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.top, 20)
            
            Spacer()
            
            Text("Seleccione una ubicación")
                .font(.headline)
                .padding()
            
            List(locations, id: \.1) { city, address in
                NavigationLink(destination: RestaurantView()) {
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

#Preview {
    ContentView()
        .environmentObject(ReservationModel())
}
