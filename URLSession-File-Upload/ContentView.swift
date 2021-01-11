//
//  ContentView.swift
//  URLSession-File-Upload
//
//  Created by Touhid on 7/1/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var showImagePicker: Bool = false
    @State var image: Image? = nil
    @State var uiImage: UIImage? = nil
    
    var body: some View {
        VStack {
            
            Text("Upload Test").padding()
            
            image?.resizable()
                .scaledToFit()
                .frame(width: 250.0, height: 250.0)
            
            Button(action: {
                
                print("Picker Tapped")
                self.showImagePicker.toggle()
                
            }) {
                
                Text("Pick Image").padding().accentColor(.white).background(Color.red)
                
            }
            
            Button(action: {
                
                print("Upload Tapped")
                
                // Multiple file upload need multiple imageData & imageDataFieldName (param)
                // Below will upload single file
                
                let a = FileUploadManager()
                a.uploadRequest(urlPath: "http://192.168.0.104/upImage/my_upload.php", imageData: [self.uiImage?.jpegData(compressionQuality: 1.0)], imageDataFieldName: ["upfile"], formFields: ["title":"jdfa"])
                
            }) {
                
                Text("Upload Image").padding().accentColor(.white).background(Color.red)
                
            }
            
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { mUiImage in
                print("Path \(mUiImage)")
                self.uiImage = mUiImage
                self.image = Image(uiImage: mUiImage)
                
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
