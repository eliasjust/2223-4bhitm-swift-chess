//
//  ContentView.swift
//  testapp
//
//  Created by Elias Just on 13.03.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewmodel : ViewModel
    var hStacksHeight = UIScreen.main.bounds.height * 0.1
    let boardHeight =  UIScreen.main.bounds.height * 0.8
    var body: some View {
      
        VStack {
         
            BeatenPieces(pieces: viewmodel.blackBeatenPieces).frame(height: hStacksHeight)
            BoardViewWrapper(viewmodel: viewmodel).frame(height: boardHeight)
            BeatenPieces(pieces: viewmodel.whiteBeatenPieces).frame(height: hStacksHeight)
            
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

struct BeatenPieces: View {
    var pieces: [ViewModel.Piece]
    var body : some View  {
        HStack(spacing:0) {
            ForEach(pieces, id: \.self) { piece in
             
                GeometryReader { geometry in
                Image(
                    "\(piece.chessColor.rawValue)_\(piece.chessPiece.rawValue)"
                    
                ).resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width  , height: geometry.size.height )
                }
                
                 
                
            }.padding(.horizontal,0).background(.yellow)
            
            
            
            
        }
    }
    
}











struct ContentView_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    static var previews: some View {
        ContentView(viewmodel: viewModel)
    }
}
