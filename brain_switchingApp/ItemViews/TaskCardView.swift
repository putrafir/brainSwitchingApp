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
                }
               
            }
            .padding()
            .background(Color(.white))
            .cornerRadius(12)
        }
    }
}
