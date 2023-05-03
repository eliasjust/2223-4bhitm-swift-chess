//
//  ContentView.swift
//  testapp
//
//  Created by Elias Just on 13.03.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewmodel : ViewModel
    
    var body: some View {
      
        VStack {
            BoardViewWrapper(viewmodel: viewmodel).padding()
            
        }.padding()
        
    }
}




struct BoardViewWrapper: UIViewRepresentable {
    var viewmodel: ViewModel
    func makeUIView(context: Context) -> some UIView {
        let myUiView = BoardView(viewModel: viewmodel)
        return myUiView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
    







struct ContentView_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    static var previews: some View {
        ContentView(viewmodel: viewModel)
    }
}
