//
//  MainView.swift
//  Clipkart
//
//  Created by pratik.nalawade on 25/10/24.
//
import SwiftUI

struct MainView: View {
    @StateObject var viewModel = ProductViewModel()
    @State private var isMenuOpen = false
    @State private var isCart = false
    @State private var searchText = ""
    @EnvironmentObject var cartManager: CartManager
    
    // Computed property to filter products based on title or description
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return viewModel.products // If no search query, show all products
        } else {
            return viewModel.products.filter { product in
                product.title.lowercased().contains(searchText.lowercased()) ||
                product.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),  // First column
        GridItem(.flexible(), spacing: 16)   // Second column
    ]
    
    var body: some View {
        ZStack {
            VStack {
                // Search Bar
                if !viewModel.isLoading && !isMenuOpen {
                    TextField("Search by title or description", text: $searchText)
                        .padding(.leading, 40)  // Adds extra padding to the left for the icon
                        .padding(.vertical, 10)  // Adds vertical padding to give space within the bracket
                        .background(
                            RoundedRectangle(cornerRadius: 35)  // Rounded corners for the search bar
                                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 2)  // Bracket outline
                        )
                        .padding(.horizontal)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, -10)  // Add space between icon and left edge
                                Spacer()
                            }
                        )
                        .padding(.horizontal)  // Ensures the search bar has horizontal padding
                }
                
                // ScrollView for vertical scrolling of products
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(filteredProducts.enumerated()), id: \.element.id) { index, product in
                            if NetworkMonitor.shared.netOn {
                                NavigationLink {
                                    ProductDetailsView(products: viewModel.products, index: index)
                                } label: {
                                    VStack(spacing: 8) {
                                        // Product Image
                                        AsyncImage(url: URL(string: product.image)) { image in
                                            image.resizable()
                                                .scaledToFill() // Ensures the image fills the frame
                                                .frame(width: 150, height: 150) // Fixed size for the image
                                                .cornerRadius(8)
                                                .clipped() // Ensures image does not overflow the frame
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 150, height: 150)
                                        }
                                        
                                        // Product Name
                                        Text(product.title)
                                            .font(.subheadline)
                                            .lineLimit(2)  // Ensures the title doesn't overflow
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity)
                                        
                                        // Prices (both original and discounted)
                                        HStack {
                                            Text("₹\(String(format: "%.2f", product.price))")
                                                .strikethrough()
                                                .foregroundColor(.red)
                                                .font(.caption)
                                            
                                            Text("₹\(String(format: "%.2f", product.price * 1.1))") // Price after 10% discount
                                                .foregroundColor(.green)
                                                .font(.caption)
                                        }
                                    }
                                    .padding(8)
                                    .frame(width: 170, height: 250) // Fixed size for the product card
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                                    .shadow(radius: 5)
                                }
                                .onAppear {
                                    if index == viewModel.displayedProducts.count - 1 {
                                        viewModel.loadNextPage()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .animation(.easeInOut)  // Smooth transition when data changes
                    
                    // List of filtered products -> if list view
                    //                List {
                    //                    ForEach(Array(filteredProducts.enumerated()), id: \.element.id) { index, product in
                    //                        if NetworkMonitor.shared.netOn {
                    //                            NavigationLink {
                    //                                ProductDetailsView(products: viewModel.products, index: index)
                    //                            } label: {
                    //                                ProductRowView(product: product)
                    //                            }
                    //                        }
                    //                    }
                    //                }
                    //                .listStyle(.plain)
                    
                    .navigationTitle("Products")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .alert("Please turn on your internet!", isPresented: $viewModel.isNetClosed) {}
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                isMenuOpen.toggle() // Toggle the menu when tapped
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .font(.title2)
                                    .foregroundColor(.primary) // Icon color adapts to dark/light mode
                                    .foregroundColor(.black)
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                isCart = true // Toggle the CartView when tapped
                            }) {
                                Image(systemName: "cart")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .background(
                        NavigationLink(destination: CartView().environmentObject(cartManager), isActive: $isCart) {
                            EmptyView()
                        }
                            .hidden())} // Hide the navigation link)
                
                // Side menu
                if isMenuOpen {
                    SideMenu(isMenuOpen: $isMenuOpen)
                        .transition(.move(edge: .leading))
                        .zIndex(1) // Ensure the side menu is above the tab view
                        .offset(x: -50) // Adjust this value to move the menu further left
                }
                
                // ProgressView while loading
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5) // Make the spinner larger
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                }
            }
            .onDisappear{
                isMenuOpen = false
            }
            .animation(.easeInOut, value: isMenuOpen)
            .task {
               await viewModel.fetchProducts()
            }
        }
    }
    
    struct SideMenu: View {
        @Binding var isMenuOpen: Bool
        @State private var isLogOut:Bool = false
        @State private var isExplore:Bool = false
        @State private var isShowMap:Bool = false
        
        // List of menu items with icons, labels, and actions
        var menuItems: [(icon: String, label: String, action: () -> Void)] {
            // Define the menu items in the body, so you can safely use `isExplore` and `isLogOut`
            return [
                ("location.circle", "Locate us!", { isShowMap = true}),
                ("magnifyingglass", "Explore", { isExplore = true}),
                ("dollarsign.circle.fill", "Sell on Flipkart", { }),
                ("bubble.left.fill", "Order History", { }),
                ("questionmark.circle.fill", "Help", { }),
                ("xmark.circle.fill", "Logout", { isLogOut = true})
            ]
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                Spacer()
                // Profile or Logo section - Center the "Hi Pratik!" text
                HStack {
                    Spacer()
                    Text("Hi \(SessionManager.shared.currentUser?.fullName ?? "Buddy")!") // Replace with user's name
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                    Spacer()
                }
                .padding(.top, 30) // Optional: adjust padding to suit your design
                ForEach(menuItems, id: \.label) { item in
                    SideMenuButton(icon: item.icon, label: item.label, action: item.action)
                }
                .padding() // Outer padding to separate from other views
                .frame(maxWidth: .infinity, alignment: .leading) // Align to the leading edge
                Spacer()
            }
            .frame(width: 290)
            .background(LinearGradient(gradient: Gradient(colors: [Color.gray]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(30)
            .shadow(radius: 10)
            .edgesIgnoringSafeArea(.vertical)
            .onTapGesture {
                isMenuOpen = false // Close menu on tap outside
            }
            .offset(x: isMenuOpen ? 0 : -290) // Off-screen when closed
            .animation(.easeInOut(duration: 0.3), value: isMenuOpen)
            
            // Handle Navigation based on selected item
            NavigationLink(destination: ProfileView(), isActive: $isExplore) { EmptyView() }
            NavigationLink(destination: LoginView(), isActive: $isLogOut) { EmptyView() }
            NavigationLink(destination: ShowMapView(), isActive: $isShowMap) { EmptyView() }
        }
    }
}

struct SideMenuButton: View {
    var icon: String
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white) // Icon color
                
                Text(label)
                    .font(.headline)
                    .foregroundColor(.white) // Text color
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.black)
            .cornerRadius(120)
            .padding(.horizontal)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .scaleEffect(1.05)
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.3))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MainView()
}
