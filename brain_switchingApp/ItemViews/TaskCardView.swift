//
//  TaskCardView.swift
//  brain_switchingApp
//
//  Created by MacBook on 12/05/25.
//

import SwiftUI

//struct TaskItem {
//    let time: String
//    let title: String
//    let subtitle: String
//    let color: Color
//}

struct TaskCardView: View {
    
    let jadwal:Jadwal
    @State private var showAddSheet = false
    @State private var showDetailPopup = false
    @State var selectedDate = Date()
    @State private var daftarJadwal: [Jadwal] = []
    
    //    let time: String
    //    let task: TaskItem
    //    let daftarJadwal: Jadwal
    //
    
    
    var body: some View {
        HStack(alignment: .top) {
            VStack{
                Text(jadwal.waktuMulai.formatted(.dateTime.hour().minute()))
                    .font(.subheadline)
                    .frame(width: 50, alignment: .leading)
                    .foregroundColor(.gray)
                Spacer()
                Text(jadwal.waktuSelesai.formatted(.dateTime.hour().minute()))
                    .font(.subheadline)
                    .frame(width: 50, alignment: .leading)
                    .foregroundColor(.gray)
                
            }
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text(jadwal.namaJadwal)
                    .font(.subheadline)
                    .bold()
                HStack{
                    Text(jadwal.tipe)
                        .foregroundColor(jadwal.tipe == "Kerja" ? Color.red : Color.blue)
                    
                    Text("Detail")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .onTapGesture {
                            print("Di Klik Detail")
                            daftarJadwal.append(jadwal)
                            showAddSheet = false
                            showDetailPopup=true
                            print(daftarJadwal)
                            
                        }
                        .sheet(isPresented: $showDetailPopup, content: {
                            ModalView(jadwaldiklik: jadwal)
                        })
                }
                
            }
            .padding()
            .background(Color(.white))
            .cornerRadius(12)
            .sheet(isPresented: $showAddSheet) {
                AddJadwalView(
                    showSheet: $showAddSheet,
                    daftarJadwal: $daftarJadwal,
                    selectedDate: selectedDate
                )
                .presentationDetents([.fraction(0.5), .medium])
            }
        }
    }
    
    struct ModalView: View {
        @Environment(\.dismiss) private var dismiss
        let dateFormatter = DateFormatter()
        
        //        @Binding var showDetailPopup:Bool
        let jadwaldiklik : Jadwal
        private var dateString: String {
            let fmt = DateFormatter()
            fmt.dateFormat = "EEEE, MMM d, yyyy"    // e.g. "Friday, May 16, 2025"
            return fmt.string(from: jadwaldiklik.tanggal)
        }
        private var startString: String {
            let fmt = DateFormatter()
            fmt.dateFormat = "HH:mm:ss"    // e.g. "Friday, May 16, 2025"
            return fmt.string(from: jadwaldiklik.waktuMulai)
        }
        private var endString: String {
            let fmt = DateFormatter()
            fmt.dateFormat = "HH:mm:ss"    // e.g. "Friday, May 16, 2025"
            return fmt.string(from: jadwaldiklik.waktuSelesai)
        }
        
        var body: some View {
            NavigationStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(jadwaldiklik.namaJadwal).bold().font(.title2)
                    Text("\(dateString)").font(.body)
                    Text("\(startString) -\(endString)").font(.body)
                    
                    Spacer()
                    
                    Text(jadwaldiklik.tipe)
                        .fontWeight(.semibold)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                    //                         .padding()
                    //                         .background(jadwaldiklik.tipe == "Kerja" ? Color.red : Color.blue)
                    
                    
                }
                .padding()
                .background(.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                .frame(width: 340, height: 180)
                //                     .padding()
                //                     .ignoresSafeArea(edges: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
                .navigationTitle("Details")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            //                                showDetailPopup = false
                            dismiss()
                            
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button("Edit") {
                            // save or something…
                            //                                showDetailPopup = false
                            //                                showAddSheet = true
                            print(jadwaldiklik)
                        }
                    }
                }
                // If you want deeper pushes:
                .navigationDestination(for: String.self) { item in
                    Text("Detail for \(item)")
                        .navigationTitle(item)
                    //                    }
                }
                
            }
        }
        
    }
    
}
