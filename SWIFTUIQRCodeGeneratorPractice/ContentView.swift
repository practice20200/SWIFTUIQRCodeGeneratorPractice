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
            }
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
