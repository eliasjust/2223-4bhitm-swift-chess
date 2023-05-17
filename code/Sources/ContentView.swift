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
    let pawnPromotionOptions: [ViewModel.ChessPiece] = [.queen, .rook, .bishop, .knight]
    @State private var selectedPromotion: ViewModel.ChessPiece = .queen
    var body: some View {
      
        ZStack {
        VStack {
         
            BeatenPieces(pieces: viewmodel.blackBeatenPieces).frame( height: hStacksHeight)
            ChessBoardViewControllerWrapper(viewmodel: viewmodel)
            BeatenPieces(pieces: viewmodel.whiteBeatenPieces).frame(height: hStacksHeight)
            
            
        }.padding().blur(radius: viewmodel.gameIsEnded ? 10 : 0)
            viewForGameOver().background(.bar).cornerRadius(20).padding()
            
            
            if let _ = viewmodel.pawnPromotes {
                  pawnPromotionView()
              }

        }
        
       
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
    
    
    @ViewBuilder
    func pawnPromotionView() -> some View {
        VStack {
            Text("Choose Promotion")
                .font(Font.largeTitle)
                .bold()

            Picker("Promotion", selection: $selectedPromotion) {
                ForEach(pawnPromotionOptions, id: \.self) { option in
                    Text(option.rawValue.capitalized)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 200, height: 150)
            .clipped()

            Button("Confirm", action: {
                viewmodel.promoteSelectedPawn(chosenPiece: selectedPromotion)
            })
            .padding()
            .buttonStyle(.bordered)
            .font(Font.title)
        }
        .buttonBorderShape(.roundedRectangle)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
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
