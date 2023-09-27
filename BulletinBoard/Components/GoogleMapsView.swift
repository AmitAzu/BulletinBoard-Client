//
//  GoogleMapsView.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 25/09/2023.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    @Binding var userLocation: CLLocation?
    @Binding var bulletinList: [Bulletin]
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: userLocation?.coordinate.latitude ?? 0.0, longitude: userLocation?.coordinate.longitude ?? 0.0, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        updateMarkers(mapView: mapView)
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        updateMarkers(mapView: uiView)
    }
    
    private func updateMarkers(mapView: GMSMapView) {
        mapView.clear()
        
        for bulletin in bulletinList {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(bulletin.geo.lat) ?? 0.0, longitude: Double(bulletin.geo.lng) ?? 0.0)
            marker.title = bulletin.title
            marker.map = mapView
        }
    }
}

struct SelectedLocationGoogleMapView: UIViewRepresentable {
    @Binding var userLocation: CLLocation?
    @Binding var selectedLongitude: Double?
    @Binding var selectedLatitude: Double?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: userLocation?.coordinate.latitude ?? 0.0, longitude: userLocation?.coordinate.longitude ?? 0.0, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: SelectedLocationGoogleMapView
        
        init(_ parent: SelectedLocationGoogleMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            parent.selectedLatitude = coordinate.latitude
            parent.selectedLongitude = coordinate.longitude
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
