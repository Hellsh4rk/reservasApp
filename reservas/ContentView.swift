import SwiftUI

struct ContentView: View {
    @StateObject private var cart = CartModel()

    var body: some View {
        TabView {
            MainPageView()
                .tabItem {
                    Label("Página Principal", systemImage: "house")
                }
            
            MenuView(cart: cart)
                .tabItem {
                    Label("Menú", systemImage: "list.bullet")
                }
            
            CartView(cart: cart)
                .tabItem {
                    Label {
                        HStack {
                            Image(systemName: "cart")
                            Text("Carrito (\(cart.items.count))")
                        }
                    } icon: {
                        Image(systemName: "cart")
                    }
                }
        }
    }
}

struct MainPageView: View {
    var body: some View {
        VStack {
                Image("lemonlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 20)
                    .padding(.leading, 0)
                Spacer()

        }
        .edgesIgnoringSafeArea(.top)
    }
}
struct Item: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
    let price: Double
}

class CartModel: ObservableObject {
    @Published var items: [Item] = []

    func addItem(_ item: Item) {
        items.append(item)
    }

    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price }
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

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Imagen del item
                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Rellena el espacio sin mantener la relación de aspecto
                    .frame(height: 300)
                    .clipped() // Asegura que no se salga del contenedor
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

                Spacer()
            }
            .padding()
        }
        .navigationTitle("")  // Oculta el título de la barra de navegación
        .navigationBarBackButtonHidden(false)  // Muestra el botón de regreso por defecto
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
                                Text(item.name)
                                Spacer()
                                Text("$\(item.price, specifier: "%.2f")")
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
            }
            .navigationTitle("Carrito")
            .toolbar {
                EditButton()
            }
        }
    }
}

#Preview {
    ContentView()
}
