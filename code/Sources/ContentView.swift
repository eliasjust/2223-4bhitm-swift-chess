//
//  ContentView.swift
//  testapp
//
//  Created by Elias Just on 13.03.23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    let layer = CALayer()
    var body: some View {
        VStack {
            Text("Hello, world!")
            Board()
        }
        .padding()
    }
}


struct Board:UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {

        print("hello")
    }
    
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: CGRect(x:0,y:0,width: 200,height: 200))
        let layer = CALayer()
        layer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        layer.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(layer)
        return view
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
