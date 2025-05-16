//
//  DetailTaskView.swift
//  brain_switchingApp
//
//  Created by MacBook on 15/05/25.
//

import SwiftUI
struct DetailTaskView: View {
    @Binding var showSheet: Bool
    @Binding var daftarJadwal: [Jadwal]
    
    var body: some View {
            VStack(content: {
                Text(daftarJadwal[0].namaJadwal).bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text("Date ")
                Text("Time start - end")
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Button")
                })
            })
        
        
       
    }
}

