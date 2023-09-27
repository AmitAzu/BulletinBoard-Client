//
//  CreateNewBulletinView.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 24/09/2023.
//

import SwiftUI
import GoogleMaps

struct CreateNewBulletinView: View {
    @ObservedObject var viewModel: BulletinViewModel
    @Binding var selectedTab: Int
    @State private var selectedImageURL: URL? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var selectedLongitude: Double? = nil
    @State private var selectedLatitude: Double? = nil
    @State private var title: String = ""
    @State private var bodyText: String = ""
    @State private var userName: String = ""
    @State private var isImagePickerPresented: Bool = false
    @State private var isMapViewPresented: Bool = false
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Image")) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                
                Button("Select Image from Gallery") {
                    isImagePickerPresented = true
                }
            }
            
            Section(header: Text("Location")) {
                if let selectedLatitude = selectedLatitude,
                   let selectedLongitude = selectedLongitude {
                    VStack(alignment: .leading) {
                        Text("longitude: \(selectedLatitude)")
                        Text("latitude: \(selectedLongitude)")
                    }
                }
                
                Button("Select Location on Map") {
                    isMapViewPresented = true
                }
            }
            
            Section(header: Text("Details")) {
                TextField("Title", text: $title)
                TextField("User Name", text: $userName)
                TextField("Body", text: $bodyText)
            }
            
            Button("Save") {
                if !title.isEmpty && !userName.isEmpty && selectedImage != nil && selectedLatitude != nil {
                    let lat = String(selectedLatitude ?? 0.0)
                    let lng = String(selectedLongitude ?? 0.0)
                    let id = UniqueIDGenerator.shared.generateUniqueID()
                    let bulletin = Bulletin(
                        id: id,
                        url: selectedImageURL?.absoluteString ?? "",
                        geo: .init(lat: lat, lng: lng),
                        title: title,
                        userName: userName,
                        body: bodyText)
                    viewModel.addNewBulletin(bulletin)
                    selectedTab = 0
                } else {
                    isShowingAlert = true
                }
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(
                selectedImage: $selectedImage,
                selectedImageURL: $selectedImageURL)
        }
        .sheet(isPresented: $isMapViewPresented) {
            SelectedLocationGoogleMapView(
                userLocation: $viewModel.locationService.userLocation,
                selectedLongitude: $selectedLongitude,
                selectedLatitude: $selectedLatitude)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Validation Error"),
                message: Text("Please fill in all fields"),
                dismissButton: .default(Text("OK")))
        }
    }
}
