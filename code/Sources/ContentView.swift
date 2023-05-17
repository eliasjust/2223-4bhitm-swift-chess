//
//  ContentView.swift
//  testapp
//
//  Created by Elias Just on 13.03.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewmodel : ViewModel
    @State private var rotationAngle: Angle = .zero
    var hStacksHeight = UIScreen.main.bounds.height * 0.1
    let boardHeight =  UIScreen.main.bounds.height * 0.8
    var body: some View {
      
        ZStack {
        VStack {
         
            BeatenPieces(pieces: viewmodel.blackBeatenPieces).frame( height: hStacksHeight)
            ChessBoardViewControllerWrapper(viewmodel: viewmodel)
            BeatenPieces(pieces: viewmodel.whiteBeatenPieces).frame(height: hStacksHeight)
            
            
        }.padding().blur(radius: viewmodel.gameIsEnded ? 10 : 0)
            viewForGameOver().padding().background(.yellow)       }
        
       
    };
        
    @ViewBuilder
    func viewForGameOver() -> some View {
        if viewmodel.gameIsEnded{
                VStack {
                    Text(viewmodel.whiteIsCheckMate ? "Black is Winner" : (viewmodel.blackIsCheckMate ?  "White is Winner" : "Its a Draw"))
                        .font(Font.largeTitle)
                        .bold()
                    
        
                    Button("Restart Game", action: viewmodel.restartGame).padding().buttonStyle(.bordered).font(Font.title)
                }.buttonBorderShape(.roundedRectangle)
            
            
        }
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
    let imageSize = UIScreen.main.bounds.width  / 10

    var body : some View  {
        
        ScrollView(.horizontal) {
            LazyHStack {
            ForEach(pieces, id: \.self) { piece in
                
                Image("\(piece.chessColor.rawValue)_\(piece.chessPiece.rawValue)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize)
                    .id(UUID())
                    
            }

        }
        }
    }
    
}




class BoardViewController: UIViewController {
    var chessboardView : BoardView
    var viewmodel: ViewModel
     init(viewmodel:ViewModel) {
        chessboardView =  BoardView(viewModel: viewmodel)
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(chessboardView)
        
        NotificationCenter.default.addObserver(self,selector: #selector(handleDeviceRotation(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func handleDeviceRotation(_ gesture: UIRotationGestureRecognizer) {
        let deviceOrientation = UIDevice.current.orientation
        
        let rotationAngleForEachOrientation: Dictionary<UIDeviceOrientation, CGFloat> = [
            .portrait:CGFloat.zero,
            .landscapeLeft: CGFloat.pi / 2,
            .landscapeRight: CGFloat.pi / -2,
            
                .portraitUpsideDown: CGFloat.pi
        ]
        let angle = rotationAngleForEachOrientation[deviceOrientation] ?? CGFloat.zero
        view.transform = CGAffineTransform(rotationAngle: angle )
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
  
    
    
   
}


struct ChessBoardViewControllerWrapper: UIViewControllerRepresentable {
    var viewmodel: ViewModel
    func makeUIViewController(context: Context) -> some UIViewController {
        BoardViewController(viewmodel: viewmodel)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    static var previews: some View {
        ContentView(viewmodel: viewModel)
    }
}
