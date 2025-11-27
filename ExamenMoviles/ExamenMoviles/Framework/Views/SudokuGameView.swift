//
//  CountryDetailView.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import SwiftUI

struct SudokuGameView: View {
    let startMode: SudokuGameStartMode
    
    @StateObject private var viewModel = SudokuGameViewModel()
    @State private var showVerifyAlert = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            switch viewModel.viewState {
            case .loading:
                ProgressView("Cargando puzzle...")
                    .padding()
                
            case .error(let message):
                VStack(spacing: 12) {
                    Text(message)
                        .multilineTextAlignment(.center)
                    Button("Reintentar") {
                        Task {
                            await viewModel.start(mode: startMode)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                
            default:
                if viewModel.board.isEmpty {
                    Text("No se pudo cargar el sudoku.")
                } else {
                    Text("\(viewModel.pattern.blockTitle) (\(viewModel.pattern.boardSize)x\(viewModel.pattern.boardSize)) • \(viewModel.difficulty.displayName)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
//                    let dimension = viewModel.boardDimension
//                    let columns = Array(
//                        repeating: GridItem(.flexible(minimum: 30), spacing: 2),
//                        count: dimension
//                    )
                    
                    VStack(spacing: 2) {
                        ForEach(0..<viewModel.board.count, id: \.self) { row in
                            HStack(spacing: 2) {
                                ForEach(0..<viewModel.board[row].count, id: \.self) { col in
                                    cellView(row: row, col: col)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Button {
                                viewModel.enterNumber(0)
                            } label: {
                                Text("Borrar")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            
                            ForEach(1...viewModel.boardDimension, id: \.self) { num in
                                Button {
                                    viewModel.enterNumber(num)
                                } label: {
                                    Text("\(num)")
                                        .frame(width: 32, height: 32)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack(spacing: 12) {
                        Button("Reiniciar puzzle") {
                            viewModel.resetPuzzle()
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(8)
                        
                        Button("Verificar solución") {
                            viewModel.verifySolution()
                            showVerifyAlert = true
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Button("Nuevo puzzle") {
                        Task {
                            await viewModel.loadNewGame(
                                pattern: viewModel.pattern,
                                difficulty: viewModel.difficulty
                            )
                        }
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
            }
        }
        .padding(.vertical)
        .navigationTitle("Sudoku")
        .onAppear {
            Task {
                await viewModel.start(mode: startMode)
            }
        }
        .alert(isPresented: $showVerifyAlert) {
            if let success = viewModel.verificationSuccess {
                if success {
                    return Alert(
                        title: Text("Correcto"),
                        message: Text(viewModel.verificationMessage),
                        dismissButton: .default(Text("Seguir jugando")) {
                        }
                    )
                } else {
                    return Alert(
                        title: Text("Revisa tu solución"),
                        message: Text(viewModel.verificationMessage),
                        dismissButton: .default(Text("Seguir jugando")) {
                        }
                    )
                }
            } else {
                return Alert(
                    title: Text(""),
                    message: Text(""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    @ViewBuilder
    private func cellView(row: Int, col: Int) -> some View {
        let isSelected = (row == viewModel.selectedRow && col == viewModel.selectedCol)
        let isInitial = viewModel.initialBoard[row][col] != nil
        let value = viewModel.board[row][col]
        
        Button {
            viewModel.selectCell(row: row, col: col)
        } label: {
            ZStack {
                Rectangle()
                    .fill(isInitial ? Color.gray.opacity(0.3) : Color.white)
                    .overlay(
                        Rectangle()
                            .stroke(isSelected ? Color.blue : Color.gray,
                                    lineWidth: isSelected ? 2 : 1)
                    )
                
                Text(value != nil ? "\(value!)" : "")
                    .font(.system(size: 18, weight: isInitial ? .bold : .regular))
                    .foregroundColor(isInitial ? .black : .blue)
            }
        }
        .frame(width: 40, height: 40)
    }
}

#Preview {
    SudokuGameView(startMode: .new(pattern: .twoByTwo, difficulty: .easy))
}
