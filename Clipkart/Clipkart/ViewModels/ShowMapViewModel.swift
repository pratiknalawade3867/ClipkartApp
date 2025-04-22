//
//  ShowMapViewModel.swift
//  Clipkart
//
//  Created by pratik.nalawade on 10/02/25.
//

import Foundation
import MapKit
import SwiftUI

@Observable class ShowMapViewModel: ObservableObject {
    
    // MARK:  All loaded locations
    var locations: [Location]
    
    // MARK:  Current location on map
    var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    
    // MARK:  Current region on map
    var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    // MARK:  Show list of locations
    var showLocationsList: Bool = false
    
    // MARK:  Show location detail via sheet
    var sheetLocation: Location? = nil
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        
        self.updateMapRegion(location: locations.first!)
    }
    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan)
        }
    }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList.toggle()
        }
    }
    
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
    }
    
    func nextButtonPressed() {
        // MARK:  Get the current index
        guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation }) else {
            print("Could not find current index in locations array! Should never happen.")
            return
        }
        
        // MARK:  Check if the currentIndex is valid
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            guard let firstLocation = locations.first else { return }
            showNextLocation(location: firstLocation)
            return
        }
        
        // MARK:  Next index IS valid
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
    
}

class LocationsDataService {
    static let locations: [Location] = [
        Location(
            name: "Central shop",
            cityName: "Delhi",
            coordinates: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090),
            description: "A popular retail store in the heart of Delhi, offering a wide range of fashion, accessories, and lifestyle products. The store attracts both local customers and tourists who wish to explore Indian fashion trends.",
            imageNames: [
                "3",
                "4"
            ],
            link: "https://en.wikipedia.org/wiki/Delhi"
        ),
        Location(
            name: "East shop",
            cityName: "Kolkata",
            coordinates: CLLocationCoordinate2D(latitude: 22.5726, longitude: 88.3639),
            description: "This retail store in Kolkata offers a variety of traditional and modern apparel, including sarees, suits, and casual wear, reflecting the rich cultural heritage of Bengal.",
            imageNames: [
                "1",
                "4"
            ],
            link: "https://en.wikipedia.org/wiki/Kolkata"
        ),
        Location(
            name: "West shop",
            cityName: "Mumbai",
            coordinates: CLLocationCoordinate2D(latitude: 19.0760, longitude: 72.8777),
            description: "Located in Mumbai, this retail store offers an eclectic mix of western and Indian fashion. It is one of the city's most visited shopping destinations, popular for its trendy collection and international brands.",
            imageNames: [
                "1",
                "2"
            ],
            link: "https://en.wikipedia.org/wiki/Mumbai"
        ),
        Location(
            name: "South shop",
            cityName: "Bengaluru",
            coordinates: CLLocationCoordinate2D(latitude: 12.9716, longitude: 77.5946),
            description: "This retail store in Bengaluru is known for its premium collection of tech gadgets, home decor, and fashion wear. It is a go-to spot for tech enthusiasts and fashion-conscious customers alike.",
            imageNames: [
                "2",
                "3"
            ],
            link: "https://en.wikipedia.org/wiki/Bangalore"
        )
    ]
}
