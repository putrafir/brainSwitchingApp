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
    @State var showAllert = false {
        didSet {
            print("showAllert = \(showAllert)")
        }
    }
    var selectedDate:Date
    
    @State private var namaJadwal = ""
    
    //add last

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
                    if(daftarJadwal.isEmpty){
                        print("array kosong")
                        let jadwalBaru = Jadwal(
                            namaJadwal: namaJadwal,
                            tanggal: selectedDate,
                            waktuMulai: waktuMulai,
                            waktuSelesai: waktuSelesai,
                            tipe: tipe
                        )
                        daftarJadwal.append(jadwalBaru)
                        showSheet=false
                    }else{
                        print("array ada isinya \(daftarJadwal)")
                        for jadwalCheck in daftarJadwal {
                            //cek jadwal start apabila terjadi bentrok
                            if(cekJadwalCrush(timeStart: jadwalCheck.waktuMulai, timeEnd: jadwalCheck.waktuSelesai, timeInput: waktuMulai)){
                                print("jadwal bentrok \(cekJadwalCrush(timeStart: jadwalCheck.waktuMulai, timeEnd: jadwalCheck.waktuSelesai, timeInput: waktuMulai)))")
                                showAllert = true
                                //                                print("allert if 1 \(showAllert)")
                            }
                            else if(cekJadwalCrush(timeStart: jadwalCheck.waktuMulai, timeEnd: jadwalCheck.waktuSelesai, timeInput: waktuSelesai)){
                                print("jadwal bentrok \(cekJadwalCrush(timeStart: jadwalCheck.waktuMulai, timeEnd: jadwalCheck.waktuSelesai, timeInput: waktuMulai)))")
                                showAllert = true
                                //                                    print("allert if 2 \(showAllert)")
                            }
                            else if (cekJadwalCrush(timeStart: jadwalCheck.waktuMulai, timeEnd: jadwalCheck.waktuSelesai, timeInput: waktuMulai) && cekJadwalCrush(timeStart: jadwalCheck.waktuMulai, timeEnd: jadwalCheck.waktuSelesai, timeInput: waktuSelesai)){
                                print("jadwal bentrok \(cekJadwalCrush(timeStart: jadwalCheck.waktuMulai, timeEnd: jadwalCheck.waktuSelesai, timeInput: waktuMulai)))")
                                showAllert = true
                                //                                    print("allert if 2 \(showAllert)")
                            }
                            else{
                                let jadwalBaru = Jadwal(
                                    namaJadwal: namaJadwal,
                                    tanggal: selectedDate,
                                    waktuMulai: waktuMulai,
                                    waktuSelesai: waktuSelesai,
                                    tipe: tipe
                                )
                                daftarJadwal.append(jadwalBaru)
                                //                                    print(daftarJadwal)
                                showSheet = false
                            }
                            
                        }
                    }
                        
                    print("allert bawah \(showAllert)")
//                    showSheet = false
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
                .alert(isPresented: $showAllert) {
                               Alert(
                                   title: Text("Jadwal bentrok"),
                                   message: Text("Cek Kembali Jadwal Anda"),
                                   dismissButton: .default(Text("OK")){
                                     showAllert = false
                                    print("allert \(showAllert)")
                                   }
                               )
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
    func isDateInRange(startDate: Date, endDate: Date, checkDate: Date) -> Bool {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm"
        let startDateChange = dateFormater.string(from: startDate)
        let endDateChange = dateFormater.string(from: endDate)
        let checkDateChange = dateFormater.string(from: checkDate)
        let newCheckDate = dateFormater.date(from: checkDateChange)!
        let newStartDate = dateFormater.date(from: startDateChange)!
        let newEndDate = dateFormater.date(from: endDateChange)!
        print("Tanggal Setelah dirubah \(startDateChange) ")
        return newCheckDate >= newStartDate && newCheckDate <= newEndDate
    }
    func cekJadwalCrush(timeStart: Date,timeEnd: Date, timeInput: Date) -> Bool{
            // Check if the checkDate is between startDate and endDate
        if isDateInRange(startDate: timeStart, endDate: timeEnd, checkDate: timeInput) {
                print("Tanggal dan waktu berada di antara range start : \(timeStart) time end \(timeEnd) time ceck \(timeInput)")
                return true
            } else {
                print("Tanggal dan waktu tidak berada di antara range time satrt : \(timeStart) time end \(timeEnd) time ceck \(timeInput)")
                return false
            }

        
    }
}

