import SwiftUI

struct OrderConfirmationView: View {
    var product: Product
    @State private var selectedPaymentMethod: String = "Credit Card"
    @State private var address: String = ""
    @State private var showAlert: Bool = false  // To show the confirmation alert
    @State private var showSheet: Bool = false  // To show the success sheet
    @State private var orderConfirmed: Bool = false  // To track if the order is confirmed
    @State private var isNavigating: Bool = false  // To handle navigation to MainView after sheet dismiss
    @State private var quantity: Int = 1  // To track the quantity of the product
    @State private var checkmarkScale: CGFloat = 1.0  // To animate the checkmark scale
    
    let paymentOptions = ["Credit Card", "PayPal", "Cash on Delivery"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Product Image and Information
            HStack {
                if let url = URL(string: product.image) {
                    productImage(url: url)
                }
                   
                VStack(alignment: .leading) {
                    Text(product.title)
                        .font(.headline)
                    Text(product.price.currencyFormat())
                        .font(.subheadline)
                    // Stepper for quantity adjustment
                    Stepper(value: $quantity, in: 1...99, step: 1) {
                        Text("Quantity: \(quantity)")
                            .font(.subheadline)
                    }
                    .padding(.top, 8)
                }
                Spacer()
            }
            .padding()
            
            // Payment Method Picker
            VStack(alignment: .leading) {
                Text("Select Payment Method")
                    .font(.headline)
                    .padding(.bottom, 5)
                Picker("Payment Method", selection: $selectedPaymentMethod) {
                    ForEach(paymentOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.horizontal)
            
            // Address Input
            VStack(alignment: .leading) {
                Text("Enter Shipping Address Pin Code")
                    .font(.headline)
                    .padding(.bottom, 5)
                TextField("Enter Pin Code", text: $address)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            // Confirm Button
            Button(action: {
                // Show confirmation alert
                showAlert = true
            }) {
                Text("Confirm Order")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                // Alert to confirm the order
                Alert(
                    title: Text("Confirm Order"),
                    message: Text("\(ViewStrings.orderConfirmPermission.getText())"),
                    primaryButton: .destructive(Text("Confirm")) {
                        // Simulate order confirmation
                        orderConfirmed = true
                        showAlert = false
                        showSheet = true  // Show success sheet after confirmation
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Spacer()
        }
        .navigationTitle("Order Confirmation")
        .sheet(isPresented: $showSheet, onDismiss: {
            // Automatically navigate to MainView after dismissing the sheet
            isNavigating = true
        }) {
            // Confirmation Success Sheet
            VStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .padding(15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(Circle())
                    .shadow(color: .green.opacity(0.6), radius: 10, x: 0, y: 10)
                    .scaleEffect(checkmarkScale)
                    .animation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true), value: checkmarkScale)
                
                Text("\(ViewStrings.orderPlacedTxt.getText())")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                Text("Your order will be processed shortly.")
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                Button(action: {
                    // Close the sheet after a short delay or user action
                    showSheet = false
                }) {
                    Text("Close")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .frame(width: 300, height: 300)
        }
        .background(
            NavigationLink(destination: MainView(), isActive: $isNavigating) {
                EmptyView()
            }
                .hidden()
        )
    }
    
    func productImage(url: URL) -> some View {
        AsyncImage(url: url) { image in
            image.resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    OrderConfirmationView(product: Product(id: 1, title: "Sample Product", description: "This is a product description", category: "Category", image: "image_url", price: 99.99, rating: Rate(rate: 4.5, count: 100)))
}
