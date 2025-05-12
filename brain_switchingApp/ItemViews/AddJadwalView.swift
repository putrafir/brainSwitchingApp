//
//  AddJadwalView.swift
//  brain_switchingApp
//
//  Created by MacBook on 12/05/25.
//
import SwiftUI

struct AddJadwalView: View {
    @Binding var showSheet: Bool
    @Binding var daftarJadwal: [Jadwal]
    var selectedDate:Date
    
    @State private var namaJadwal = ""

    @State private var waktuMulai = Date()
    @State private var waktuSelesai = Date()
    @State private var tipe = "Kerja"
    
    let tipeJadwal = ["Kerja", "Belajar"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Nama Pekerjaan", text: $namaJadwal)
               
                DatePicker("Waktu Mulai", selection: $waktuMulai, displayedComponents: .hourAndMinute)
                DatePicker("Waktu Selesai", selection: $waktuSelesai, displayedComponents: .hourAndMinute)
                
                Picker("Tipe Jadwal", selection: $tipe) {
                    ForEach(tipeJadwal, id: \.self) { tipe in
                        Text(tipe)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
         
                Button(action: {
                    let jadwalBaru = Jadwal(
                        namaJadwal: namaJadwal,
                        tanggal: selectedDate,
                        waktuMulai: waktuMulai,
                        waktuSelesai: waktuSelesai,
                        tipe: tipe
                    )
                    daftarJadwal.append(jadwalBaru)
                    showSheet = false
                }) {
                    Text("Simpan Jadwal")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("Purple"))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
            }
            .navigationTitle("Tambah Jadwal")
//            .toolbar{
//                ToolbarItem(placement: .navigationBarTrailing){
//                    Button("Simpan") {
//                        let jadwalBaru = Jadwal(
//                            namaJadwal: namaJadwal,
//                            tanggal: selectedDate,
//                            waktuMulai: waktuMulai,
//                            waktuSelesai: waktuSelesai,
//                            tipe: tipe
//                        )
//                        daftarJadwal.append(jadwalBaru)
//                    
//                      
//                        showSheet = false
//                    }
//                    
//                        
//                }
//            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

