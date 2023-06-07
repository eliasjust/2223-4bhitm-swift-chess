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
    @State private var orientation = UIDeviceOrientation.unknown
    var body: some View {
        
        
        ZStack {
            if viewmodel.initialGameState {
                StartView(viewModel: viewmodel)
            } else {
                if orientation.isLandscape {
                    
                    HStack {
                        
                        ChessBoardViewControllerWrapper(viewmodel: viewmodel).aspectRatio(1, contentMode: .fit)
                        
                        VStack{
                            BeatenPieces(pieces: viewmodel.whiteBeatenPieces).frame(height: hStacksHeight * 0.85)
                            BeatenPieces(pieces: viewmodel.blackBeatenPieces).frame( height: hStacksHeight * 0.85)
                        }
                        
                    }.padding().blur(radius: viewmodel.gameIsEnded ? 10 : 0)
                    
                    
                } else {
                    
                    VStack {
                        
                        BeatenPieces(pieces: viewmodel.whiteBeatenPieces).frame(height: hStacksHeight * 0.85)

                        ChessBoardViewControllerWrapper(viewmodel: viewmodel) .aspectRatio(1, contentMode: .fit)
                        BeatenPieces(pieces: viewmodel.blackBeatenPieces).frame( height: hStacksHeight * 0.85)

                        Spacer()
                        
                        
                    }.padding().blur(radius: viewmodel.gameIsEnded ? 10 : 0)


                }
                
            }
 
            
            viewForGameOver().background(.bar).cornerRadius(20).padding()
            if let _ = viewmodel.pawnPromotes {
                pawnPromotionView()
            }
            
            /*
            if let _ = viewmodel.initialGameState {
                initialGameView(
            }
            */
            
        }.onRotate{ newOrientation in
            orientation = newOrientation
            
        }
        
        
        
    };
    
    
    
    @ViewBuilder
    func viewForGameOver() -> some View {
        if viewmodel.gameIsEnded {

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
            .frame(width: 200, height: 100)
            .clipped()
            
            Button("Confirm", action: {
                viewmodel.promoteSelectedPawn(chosenPiece: selectedPromotion)
            })
            .padding()
            .buttonStyle(.bordered)
            .font(Font.title2)
        }
        .buttonBorderShape(.roundedRectangle)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
}



/*
 struct BoardViewWrapper: UIViewRepresentable {
 var viewmodel: ViewModel
 func makeUIView(context: Context) -> some UIView {
 let myUiView = BoardView(viewModel: viewmodel)
 return myUiView
 }
 
 func updateUIView(_ uiView: UIViewType, context: Context) {
 
 }
 
 }
 */
struct BeatenPieces: View {
    var pieces: [ViewModel.Piece]
    
    var body: some View {
        GeometryReader { geometry in
            let imageSize = (geometry.size.height)

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
        
        // Remember to set this property to false when adding constraints programmatically
        chessboardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints
        NSLayoutConstraint.activate([
            
            // Attach the board view's top edge to the superview's top edge
            chessboardView.topAnchor.constraint(equalTo: view.topAnchor),
            
            /*
             // Attach the board view's bottom edge to the superview's bottom edge
             chessboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),*/
            
            // Attach the board view's leading edge to the superview's leading edge
            chessboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            // Attach the board view's trailing edge to the superview's trailing edge
            chessboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // If you want the board to be square (width = height), add this:
            chessboardView.widthAnchor.constraint(equalTo: chessboardView.heightAnchor)
        ])
        
        if viewmodel.playerIsColor == .black {
            view.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
        }
        

        /*
         NotificationCenter.default.addObserver(self,selector: #selector(handleDeviceRotation(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)*/
    }
    
    private func handleDeviceRotation() {
    // let deviceOrientation = UIDevice.current.orientation
     
        
        /*
     let rotationAngleForEachOrientation: Dictionary<UIDeviceOrientation, CGFloat> = [
     .portrait:CGFloat.zero,
     .landscapeLeft: CGFloat.pi / 2,
     .landscapeRight: CGFloat.pi / -2,
     
     .portraitUpsideDown: CGFloat.pi
     ]
     let angle = rotationAngleForEachOrientation[deviceOrientation] ?? CGFloat.zero*/
     view.transform = CGAffineTransform(rotationAngle: 180 )
     
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
        if let vc = uiViewController as? BoardViewController {
            vc.viewmodel = viewmodel
        }
    }
}




struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct ContentView_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    static var previews: some View {
        ContentView(viewmodel: viewModel)
    }
}
