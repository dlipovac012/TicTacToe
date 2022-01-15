//
//  ContentView.swift
//  TicTacToe
//
//  Created by Dalibor Lipovac on 14.1.22..
//

import SwiftUI




struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameFieldView(proxy: geometry)
                            GameFieldMark(proxy: geometry, imageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                
                Spacer()
            }
            .disabled(viewModel.isBoardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {
                    viewModel.resetGame()
                }))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameFieldView: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundColor(.red).opacity(0.5)
            .frame(width: proxy.size.width / 3 - 15, height: proxy.size.width / 3 - 15)
    }
}

struct GameFieldMark: View {
    var proxy: GeometryProxy
    var imageName: String
    
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .frame(width: proxy.size.width / 3 - 90, height: proxy.size.width / 3 - 90)
            .foregroundColor(.white)
    }
}
