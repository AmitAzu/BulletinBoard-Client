//
//  CreateNewBulletinView.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 24/09/2023.
//

import SwiftUI
import GoogleMaps
import SDWebImageSwiftUI

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
                TextField("Body", text: $bodyText)
                TextField("User Name", text: $userName)
            }
            
            Button("Save") {
                if !title.isEmpty && !bodyText.isEmpty && !userName.isEmpty && selectedImage != nil && selectedLatitude != nil {
                    let lat = String(selectedLatitude ?? 0.0)
                    let lng = String(selectedLongitude ?? 0.0)
                    let bulletin = BulletinData(url: selectedImageURL?.absoluteString ?? "",
                                                geo: Geo(lat: lat, lng: lng),
                                                title: title,
                                                body: bodyText,
                                                userName: userName)
                    viewModel.addNewBulletin(bulletin)
                    selectedTab = 0
                } else {
                    isShowingAlert = true
                }
                //                let lat = String(selectedLatitude ?? 0.0)
                //                let lng = String(selectedLongitude ?? 0.0)
                //                let bulletin = BulletinData(url: selectedImageURL?.absoluteString ?? "",
                //                                            geo: Geo(lat: lat, lng:lng ),
                //                                            title: title,
                //                                            body: bodyText,
                //                                            userName: userName)
                //                viewModel.addNewBulletin(bulletin)
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

//struct CreateBulletinView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateBulletinView()
//    }
//}
