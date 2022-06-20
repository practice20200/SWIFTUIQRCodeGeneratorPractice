//
//  ContentView.swift
//  SWIFTUIQRCodeGeneratorPractice
//
//  Created by Apple New on 2022-06-19.
//

import SwiftUI

struct ContentView: View {
    
    @State private var urlInput: String = ""
    @State private var qrCode: QRCode?
    @ObservedObject private var imageSaver = ImageSaver()
    private let qrCodeGenerator = QRCodeGenerator()
    
    var body: some View {
        NavigationView{
            GeometryReader{ geometry in
                VStack{
                    HStack{
                        TextField("Enter url: ", text: $urlInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.URL)
                            .keyboardType(.URL)
                        
                        Button("Generate") {
                            UIApplication.shared.windows.first { $0.isKeyWindow}?.endEditing(true)
                            qrCode = qrCodeGenerator.generateQRCode(forURLString: urlInput)
                            urlInput = ""
                        }
                        .disabled(urlInput.isEmpty)
                        .padding(.leading)
                    }
                    
                    Spacer()
                    
                    if qrCode == nil {
                        EmptyStateView(width: geometry.size.width)
                    }else {
                        QRCodeView(qrCode: qrCode!, width: geometry.size.width)
                    }
                    
                    Spacer()
                    
                } 
                .padding(0)
                .navigationBarTitle("QR Code")
                .navigationBarItems(trailing: Button(action: {
                    assert(qrCode != nil, "Cannot save nil QR code image")
                    imageSaver.saveImage(image: qrCode!.uiImage)
                }) {
                    Image(systemName: "square.and.arrow.down")
                }
                    .disabled(qrCode == nil))
                .alert(item: $imageSaver.saveResult) { saveResult in
                    return alert(forSaveStatus: saveResult.saveStatus)
                }
            }
        }
    }
    private func alert(forSaveStatus saveStatus: ImageSaveStatus) -> Alert {
        switch saveStatus {
        case .success:
            return Alert(title: Text("Success"), message: Text("The QR code was saved to your library."))
        case .error:
            return Alert(title: Text("Oops"), message:Text("An error occured while saving your QRcode."))
        case .libraryPermissionDenied:
            return Alert(title: Text("Oops"), message: Text("this app needs permission to add photos to your library."), primaryButton: .cancel(Text("OK")), secondaryButton: .default(Text("Open settings."), action: {
                guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settingURL)
            }))
        }
    }
}

struct QRCodeView: View {
    let qrCode: QRCode
    let width: CGFloat
    
    var body: some View {
        VStack{
            Label("QR code for \(qrCode.urlString):", systemImage: "qrcode.viewfinder")
            
            Image(uiImage: qrCode.uiImage)
                .resizable()
                .frame(width: width * 2/3, height:  width * 2/3)
        }
    }
}


struct EmptyStateView: View {
    let width: CGFloat
    
    private var imageLength: CGFloat {
        width / 2.5
    }
    
    var body: some View {
        VStack{
            Image(systemName: "qrcode")
                .resizable()
                .frame(width: imageLength, height: imageLength)
            
            Text("Create your own QR code")
                .padding(.top)
        }
        
        .foregroundColor(Color(uiColor: .systemGray))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
