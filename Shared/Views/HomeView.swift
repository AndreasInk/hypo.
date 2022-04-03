//
//  ContentView.swift
//  Hypo
//
//  Created by Erik Schnell on 02.04.22.
//

import SwiftUI


struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        HomeScreenDataView(
                            title: "Steps",
                            information: "This is some nice information about Walking. I like walking like I do talking and drinking water.",
                            data: "",
                            dataToExport: .constant("")
                        )

                        HomeScreenDataView(
                            title: "Heart Rate",
                            information: "PLEASE GO TO THE DOCTOR",
                            data: "",
                            dataToExport: .constant("")
                        )
                    }
                }
            }
//            .fullScreenCover(isPresented: .constant(true)) {
//                ExportDataView(data: "data", dataToExport: .constant(""), isPresented: .constant(true))
//            }
            .navigationTitle("hypo.")
        }
    }
}


struct HomeScreenDataView: View {
    var title: String
    var information: String
    var data: String //for now
    @Binding var dataToExport: String?
    var body: some View {
        NavigationLink {
            List {
                Section {
                    Text(information)
                        .padding(8)
                        .font(.system(size: 16, weight: .light, design: .monospaced))
                } header: {
                    Label("Information", systemImage: "info")
                }
                
                Section {
                    LineView(data: [8,23,54,32,12,37,7,23,43], title: "Last week", legend: "Steps Data")
                        .frame(height: 380)
                    
                    NavigationLink {
                        List {
                            HStack {
                                Text("Date")
                                    .fontWeight(.bold)
                                Spacer()
                                Text("3987")
                            }
                        }
                        .navigationTitle("Raw \(title) Data")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Export Data") {
                                    dataToExport = data
                                }
                            }
                        }
                    } label: {
                        Label("View Raw Data", systemImage: "ladybug.fill")
                    }
                    
                    
                } header: {
                    Label("Data", systemImage: "tablecells")
                }
                
            }
            .navigationTitle(title)
        } label: {
            MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: title)
                .padding()
        }
    }
}

struct ExportDataView: View {
    var data: String
    @Binding var dataToExport: String? //default selection
    @Binding var isPresented: Bool
    @State private var isExporting = false
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<50) { number in
                    Text("ABC")
                }
                Section {
                    Spacer(minLength: 32)
                        .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Export Data")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                         isPresented = false
                    }
                }
            }
            .overlay(
                Button(action: {
                    isExporting = true
                }, label: {
                    ZStack {
                    Text("Export")
                            .opacity(!isExporting ? 1 : 0)
                    ProgressView()
                            .opacity(isExporting ? 1 : 0)
                    }
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                })
                    .buttonStyle(.borderedProminent)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding()
            )
        }
    }
}
