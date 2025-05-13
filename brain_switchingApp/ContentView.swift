import SwiftUI

extension Date {
    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }
}

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var currentMonthOffset = 0
    @State private var showAddSheet = false
    @State private var daftarJadwal: [Jadwal] = []
    
    
    var body: some View {

        VStack(spacing: 0) {
            CalendarHeader(selectedDate: $selectedDate, currentMonthOffset: $currentMonthOffset)
                .padding(.vertical)

            Divider()

            ZStack{
                Color("Gray").ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Schedule")
                            .font(.title3)
                            .bold()
                            .padding(.top, 16)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                        
                        let daftarJadwalSelected = daftarJadwal
                            .filter { $0.tanggal.isSameDay(as: selectedDate)}

                        if daftarJadwalSelected.isEmpty{
                            Text("Belum ada jadwal di tanggal ini")
                        }else{
//                            ForEach(daftarJadwalSelected) { jadwal in
//                                VStack{
//                                    TaskCardView(jadwal: Jadwal(namaJadwal: jadwal.namaJadwal, tanggal: jadwal.tanggal, waktuMulai: jadwal.waktuMulai, waktuSelesai: jadwal.waktuSelesai, tipe: jadwal.tipe))
//                                }
//                    
//                            }
                            
                            let sortedJadwal = daftarJadwalSelected.sorted { $0.waktuMulai < $1.waktuMulai }

                            ForEach(Array(sortedJadwal.enumerated()), id: \.1.id) { index, jadwal in
                                VStack(alignment: .leading, spacing: 8) {
                                  
                                    if index > 0 {
                                        let prev = sortedJadwal[index - 1]
                                        if jadwal.tipe != prev.tipe {
                                            TimeDelayView(
                                                from: prev.waktuSelesai.formatted(date: .omitted, time: .shortened),
                                                to: jadwal.waktuMulai.formatted(date: .omitted, time: .shortened)
                                            )
                                        }
                                    }
                                    
                                    TaskCardView(jadwal: jadwal)
                                }
                            }
                        }
                   
                       
//                        TimeDelayView(from: "09.00", to: "09.30")
//                        
//                       
//                        TaskCardView(time: "10.00", task: tasks[1])
//                        
//                        TaskCardView(time: "08.00", task: tasks[0])
//                        
//                       
//                        TimeDelayView(from: "09.00", to: "09.30")
//                        
//                       
//                        TaskCardView(time: "10.00", task: tasks[1])

                    }
                    .padding(.horizontal)
                }
                
                
                VStack{
                    Spacer();
                        Button(action: {
                            showAddSheet=true
                        }){
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("Purple"))
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }.padding()
                  
                }.sheet(isPresented: $showAddSheet){
                    AddJadwalView(showSheet: $showAddSheet, daftarJadwal: $daftarJadwal,selectedDate: selectedDate).presentationDetents([.fraction(0.5),.medium])
                }
               
                
            }
        }
    }
}

#Preview {
    ContentView()
}


