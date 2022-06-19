//
//  ContentView.swift
//  SWIFTUIQRCodeGeneratorPractice
//
//  Created by Apple New on 2022-06-19.
//

import SwiftUI

struct ContentView: View {
    
    @State private var urlInput: String = ""
    
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
                            
                        }
                        .disabled(urlInput.isEmpty)
                        .padding(.leading)
                    }
                    
                    Spacer()
                    
                    EmptyStateView(width: geometry.size.width)
                    
                    Spacer()
                    
                }
                .padding(0)
                .navigationBarTitle("QR Code")
            }
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
