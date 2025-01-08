//
//  RestaurantView.swift
//  reservas
//
//  Created by Yahir Lope on 07/01/25.
//

import SwiftUI

struct RestaurantView: View {
    @StateObject private var cart = CartModel()
    @EnvironmentObject var reservationModel: ReservationModel
    
    func totalItemCount() -> Int {
        return cart.items.reduce(0) { $0 + $1.quantity }
    }

    var body: some View {
        NavigationView {
            TabView {
                MainPageModel()
                    .tabItem {
                        Label("Página Principal", systemImage: "house")
                    }
                
                MenuView(cart: cart)
                    .tabItem {
                        Label("Menú", systemImage: "list.bullet")
                    }
                
                // Vista de las reservaciones
                ReservacionesView()
                    .environmentObject(reservationModel) // Pasa el modelo al entorno
                    .tabItem {
                        Label("Reservaciones", systemImage: "calendar")
                    }
                
                CartView(cart: cart)
                    .tabItem {
                        Label {
                            HStack {
                                Image(systemName: "cart")
                                Text("Carrito (\(totalItemCount()))")
                            }
                        } icon: {
                            Image(systemName: "cart")
                        }
                    }
            }
        }
    }
}

struct MainPageModel: View {
    @State private var selectedIndex = 0  // Índice de la imagen seleccionada
    private let images = ["pizza", "lasagna", "tortellini"]
    
    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()  // Timer para cambiar de imagen cada 2.5 segundos
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    Color.white // Establece el color de fondo
                        .edgesIgnoringSafeArea(.top)
                    Image("lemonlogo")
                        .scaledToFit()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 70)
                        .foregroundColor(.gray)
                }
                VStack{
                    // Sección de bienvenida con imagen
                    VStack {
                        Text("Bienvenido a Little Lemon")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.top, 10)
                        
                        Text("Disfruta de los mejores platillos italianos desde la comodidad de tu hogar.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 40)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        Text("Opciones que te pueden gustar")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 40)
                            .multilineTextAlignment(.center)

                    }
                    
                    // Carrusel de imágenes
                    TabView(selection: $selectedIndex) {
                        ForEach(0..<images.count, id: \.self) { index in
                            Image(images[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 400, height: 300)
                                .clipped()  // Recorta cualquier parte de la imagen que se salga del contenedor
                                .cornerRadius(10)
                                .tag(index)  // Asignamos un tag para identificar cada imagen
                        }
                    }
                    .frame(height: 300)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .onReceive(timer) { _ in
                        // Cambiar al siguiente índice automáticamente
                        withAnimation {
                            selectedIndex = (selectedIndex + 1) % images.count  // Cicla entre las imágenes
                        }
                    }
                    
                    // Sección de botón "Explorar Menú"
                    VStack {
                        Text("Explora nuestro menú")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.top, 30)

                        NavigationLink(destination: MenuView(cart: CartModel())) {
                            Text("Ver Menú")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.horizontal, 40)
                        }
                    }
                    
                    // Sección de testimonios o comentarios de clientes
                    VStack {
                        Text("Lo que dicen nuestros clientes")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 40)

                        HStack(spacing: 20) {
                            VStack {
                                Text("“Deliciosa comida, atención excelente!”")
                                    .font(.body)
                                    .italic()
                                    .foregroundColor(.gray)
                                Text("- Ana García")
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            
                            VStack {
                                Text("“Comer aquí es como estar en Italia.”")
                                    .font(.body)
                                    .italic()
                                    .foregroundColor(.gray)
                                Text("- Roberto Sánchez")
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        .padding([.leading, .trailing], 20)
                    }

                    // Sección de contacto
                    VStack {
                        Text("Contáctanos")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 40)

                        Text("¿Tienes alguna pregunta o sugerencia? ¡Estamos aquí para ayudarte!")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 40)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            // Acción para contactar
                        }) {
                            Text("Contáctanos Ahora")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.horizontal, 40)
                        }
                    }
                    
                    Spacer()
                }
                .background(Color(UIColor.systemGray6)) /
                .edgesIgnoringSafeArea(.top)
            }
        }
    }
}

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
    let price: Double
    var quantity: Int = 1
}

class CartModel: ObservableObject {
    @Published var items: [Item] = []

    // Modificado para manejar cantidades de ítems
    func addItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            // Si el ítem ya está en el carrito, incrementamos la cantidad
            items[index].quantity += 1
        } else {
            // Si el ítem no está en el carrito, lo agregamos con cantidad 1
            items.append(item)
        }
    }

    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }  // Modificado para considerar la cantidad
    }
}

class Model: ObservableObject {
    @Published var menuItems: [Item]

    init() {
        menuItems = Model.menuItems()
    }

    static func menuItems() -> [Item] {
        return [
            Item(name: "Lasaña", description: "Deliciosa lasaña italiana con salsa boloñesa.", imageName: "lasagna", price: 15.99),
            Item(name: "Fettuccini Alfredo", description: "Pasta cremosa con una rica salsa Alfredo.", imageName: "fettuccini", price: 13.49),
            Item(name: "Espaguetis", description: "Espaguetis al dente con salsa marinara.", imageName: "spaghetti", price: 12.99),
            Item(name: "Tostada de aguacate", description: "Pan tostado con aguacate fresco y especias.", imageName: "avocado_toast", price: 9.99),
            Item(name: "Tortellini", description: "Pasta rellena con queso y bañada en salsa pesto.", imageName: "tortellini", price: 14.49),
            Item(name: "Pizza", description: "Clásica pizza margarita con albahaca fresca.", imageName: "pizza", price: 17.99)
        ]
    }
}

struct MenuView: View {
    @StateObject private var model = Model()
    @ObservedObject var cart: CartModel

    var body: some View {
        NavigationView {
            List(model.menuItems) { item in
                NavigationLink(destination: ItemDetailView(item: item, cart: cart)) {
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("$\(item.price, specifier: "%.2f")")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Menú")
        }
    }
}

struct ItemDetailView: View {
    let item: Item
    @ObservedObject var cart: CartModel
    @State private var showToast = false  // Estado para mostrar el mensaje


    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Imagen del item
                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)  // Esto llenará el contenedor, pero recortará la imagen si es necesario
                    .frame(width: 400, height: 300)  // Establece un tamaño fijo para todas las imágenes
                    .clipped()  // Recorta cualquier parte de la imagen que se salga del contenedor
                    .cornerRadius(10)

                // Nombre del item
                Text(item.name)
                    .font(.largeTitle)
                    .padding(.top)

                // Descripción del item
                Text(item.description)
                    .font(.body)
                    .padding()

                // Precio del item
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.headline)
                    .padding()

                // Botón para agregar al carrito
                Button(action: {
                    cart.addItem(item)
                    showToast = true  // Mostrar el mensaje cuando se presiona el botón
                    // Ocultar el mensaje después de 2 segundos
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showToast = false
                    }
                }) {
                    Text("Agregar al carrito")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.bottom)

                // Mostrar el Toast si el estado showToast es verdadero
                if showToast {
                    Text("¡Item agregado al carrito!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.5))  // Animación suave para la transición
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(false)
    }
}



struct CartView: View {
    @ObservedObject var cart: CartModel

    var body: some View {
        NavigationView {
            VStack {
                if cart.items.isEmpty {
                    Text("Tu carrito está vacío.")
                        .font(.title2)
                        .padding()
                } else {
                    List {
                        ForEach(cart.items) { item in
                            HStack {
                                // Muestra el nombre del ítem con la cantidad
                                Text("\(item.name) (\(item.quantity))")
                                Spacer()
                                // Muestra el precio total por ítem (cantidad * precio)
                                Text("$\(item.price * Double(item.quantity), specifier: "%.2f")")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete(perform: cart.removeItem)
                    }
                    HStack {
                        Text("Total:")
                            .font(.headline)
                        Spacer()
                        Text("$\(cart.totalPrice, specifier: "%.2f")")
                            .font(.headline)
                    }
                    .padding()
                }

                // Botón para vaciar el carrito
                Button(action: {
                    cart.items.removeAll()  // Vaciar el carrito
                }) {
                    Text("Vaciar carrito")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
                .opacity(cart.items.isEmpty ? 0 : 1)  // Hacerlo invisible si no hay ítems
                .disabled(cart.items.isEmpty)  // Deshabilitar el botón si el carrito está vacío
            }
            .navigationTitle("Carrito")
            .toolbar {
                EditButton()
            }
        }
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
        }
        .padding()
        .onAppear {
            print("Estado actual de la reservación: \(reservationModel.hasReservation ? "Activa" : "Inactiva")")
            print("Detalles actuales: \(reservationModel.reservationDetails)")
        }
        .onChange(of: reservationModel.hasReservation) { newValue in
            print("Cambio en el estado de la reservación: \(newValue ? "Sí" : "No")")
        }
    }
}


#Preview {
    RestaurantView()
        .environmentObject(ReservationModel())

}
