//
//  SudokuContentView.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import SwiftUI

struct SudokuContentView: View {
    @StateObject var viewModel = SudokuContentViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Sudoku")
                    .font(.largeTitle)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tamaño")
                        .font(.headline)
                    
                    let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                    
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(SudokuBoardPattern.allCases, id: \.self) { pattern in
                            Button {
                                viewModel.selectedPattern = pattern
                            } label: {
                                VStack {
                                    Text(pattern.blockTitle)
                                        .font(.headline)
                                    Text("\(pattern.boardSize)x\(pattern.boardSize)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(
                                    viewModel.selectedPattern == pattern
                                    ? Color.blue.opacity(0.2)
                                    : Color.gray.opacity(0.1)
                                )
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dificultad")
                        .font(.headline)
                    Picker("Dificultad", selection: $viewModel.selectedDifficulty) {
                        ForEach(SudokuDifficulty.allCases, id: \.self) { diff in
                            Text(diff.displayName).tag(diff)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)
                
                NavigationLink {
                    SudokuGameView(
                        startMode: .new(
                            pattern: viewModel.selectedPattern,
                            difficulty: viewModel.selectedDifficulty
                        )
                    )
                } label: {
                    Text("Nuevo puzzle")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                if viewModel.hasSavedGame {
                    NavigationLink {
                        SudokuGameView(startMode: .resume)
                    } label: {
                        Text("Continuar partida guardada")
                            .font(.subheadline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .onAppear {
                viewModel.refreshSavedGameStatus()
            }
        }
    }
}
#Preview {
    SudokuContentView()
}
