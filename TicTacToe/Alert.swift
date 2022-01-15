//
//  Alert.swift
//  TicTacToe
//
//  Created by Dalibor Lipovac on 14.1.22..
//

import SwiftUI


struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(
        title: Text("You won"),
        message: Text("Congratz! 🎉"),
        buttonTitle: Text("Start over"))
    
    static let computerWin = AlertItem(
        title: Text("You lost"),
        message: Text("Loser! 🤣"),
        buttonTitle: Text("Start over"))
    
    static let draw = AlertItem(
        title: Text("It's a draw!"),
        message: Text("I don't know what to tell you..."),
        buttonTitle: Text("Start over"))
}
