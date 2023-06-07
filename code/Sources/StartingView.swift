
import SwiftUI

struct StartView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var selectedColor: ViewModel.ChessColor?

    var body: some View {
        VStack {
            Text("Choose your color")
                .font(.largeTitle)
                .padding()

            HStack {
                Button(action: {
                    self.viewModel.setPlayerColor(color: .white)
                    selectedColor = .white
                }) {
                    Text("White")
                        .font(.title)
                        .padding()
                        .background(selectedColor == .white ? Color.gray : Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .shadow(radius: 10)

                Button(action: {
                    self.viewModel.setPlayerColor(color: .black)
                    selectedColor = .black
                }) {
                    Text("Black")
                        .font(.title)
                        .padding()
                        .background(selectedColor == .black ? Color.gray : Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .shadow(radius: 10)
            }
            .padding()

            Button(action: {
                self.viewModel.startGame()
            }) {
                Text("Start Game")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .shadow(radius: 10)
        }
    }
}
