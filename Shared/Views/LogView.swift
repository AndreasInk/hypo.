//
//  LogVoew.swift
//  Hypo
//
//  Created by Andreas Ink on 4/3/22.
//

import SwiftUI

struct LogView: View {
    @Binding var log: Log
    @FocusState private var focusedField: String?
    @ObservedObject var health: Health
    
    
    var body: some View {
        
        List {
           // VStack(spacing: 5) {
                ForEach(Array(zip($log.componets, log.componets.indices)), id: \.0.id) { $log, i in
                    switch($log.wrappedValue.type) {
                case .None:
                        HStack {
                    TextField("", text: $log.text)
                        
                        .listRowSeparator(.hidden)
                        .lineSpacing(5)
                        .focused($focusedField, equals: $log.wrappedValue.id)
                        .onChange(of: $log.wrappedValue.text, perform: { newValue in
                            if newValue.isEmpty {
                                if self.log.componets.indices.contains(i - 1) {
                                    focusedField = self.log.componets[i - 1].id
                                    
                                }
                            }
                        })
                        
                        .onSubmit {
                            let text = $log.wrappedValue.text
                            if text.contains("/") {
                                
                                let type = getClosestCommand(text)
                                print(type)
                                $log.wrappedValue = Componet(type: type)
                                
                            } else {
                            if self.log.componets.indices.contains(i + 1) {
                                focusedField = self.log.componets[i + 1].id
                            } else {
                                self.log.componets.append(Componet())
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                  
                                focusedField = self.log.componets.last?.id
                                }
                            }
                        }
                            
                        }
                           
                              
                        }   .swipeActions(content: {
                            Button {
                                
                            } label: {
                                Label("", systemSymbol: .trash)
                            }
                            .tint(.red)
                        })
                case .Chart:
                    LineChartView(data: log.data.map{$0.data}, title: "", rateValue: 0)
                    case .Table:
                        EmptyView()
                default:
                    EmptyView()
                }
            }
           // }
            
        } .listRowBackground(Color.clear)
            
           
        
}
    func getClosestCommand(_ text: String) -> ComponetType {
    
        for command in ComponetType.allCases {
            if command.rawValue.contains(text) {
                return command
            }
        }
        return .None
    }
}

