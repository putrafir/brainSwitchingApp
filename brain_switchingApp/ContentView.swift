import SwiftUI
import UserNotifications


extension Date {
    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }
    
    func isWithinTimeRange(of targetDate: Date, rangeInSeconds: TimeInterval) -> Bool {
        let timeDifference = self.timeIntervalSince(targetDate)
        return timeDifference >= 0 && timeDifference <= rangeInSeconds
    }
}


struct ContentView: View {
    
    let notificationDelegate = NotificationDelegate()
    
    
    @State private var selectedDate = Date()
    @State private var currentMonthOffset = 0
    @State private var showAddSheet = false
    @State private var daftarJadwal: [Jadwal] = []
    @State private var showRestReminder = false

    let restReminderTimeInterval: TimeInterval = 10 * 60 // 10 menit sebelum jeda

    var body: some View {
        VStack(spacing: 0) {
            CalendarHeader(selectedDate: $selectedDate, currentMonthOffset: $currentMonthOffset)
                .padding(.vertical)
            
            Divider()
            
            ZStack {
                Color("Gray").ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
//                            Text("Schedule")
//                            /Users/mac/Documents/Workspace/brainswitchingapp2/Untitled/brain_switchingApp/ItemViews/DetailTaskView.swift            .font(.title3)
//                                .bold()
                            
                            Spacer()
                            
                            Button(action: {
                                showAddSheet = true
                            }) {
                                Text("Add")
                            }
                        }
                        .padding(.top, 16)
                        .sheet(isPresented: $showAddSheet) {
                            AddJadwalView(
                                showSheet: $showAddSheet,
                                daftarJadwal: $daftarJadwal,
                                selectedDate: selectedDate
                            )
                            .presentationDetents([.fraction(0.5), .medium])
                        }
                        
                        let daftarJadwalSelected = daftarJadwal
                            .filter { $0.tanggal.isSameDay(as: selectedDate) }
                        
                        if daftarJadwalSelected.isEmpty {
                            Text("Belum ada jadwal di tanggal ini")
                        } else {
                            let sortedJadwal = daftarJadwalSelected.sorted { $0.waktuMulai < $1.waktuMulai }

                            ForEach(Array(sortedJadwal.enumerated()), id: \.1.id) { index, jadwal in
                                VStack(alignment: .leading, spacing: 8) {
                                    if index > 0 {
                                        let prev = sortedJadwal[index - 1]
                                        let timeGap = jadwal.waktuMulai.timeIntervalSince(prev.waktuSelesai)
                                        
                                        if jadwal.tipe != prev.tipe && timeGap < 3600 {
                                            TimeDelayView(
                                                from: prev.waktuSelesai.formatted(date: .omitted, time: .shortened),
                                                to: jadwal.waktuMulai.formatted(date: .omitted, time: .shortened)
                                            )
                                        }
                                    }
                                }
                                TaskCardView(jadwal: jadwal)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

            }
        }
        .onAppear {
            
            UNUserNotificationCenter.current().delegate = notificationDelegate
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Izin notifikasi diberikan")
                } else {
                    print("Izin notifikasi ditolak")
                }
            }
            
//            let now = Date()
//
//            let jadwal1 = Jadwal(
//                namaJadwal: "Belajar",
//                tanggal: now,
//                waktuMulai: now,
//                waktuSelesai: Calendar.current.date(byAdding: .minute, value: 5, to: now)!,
//                tipe: "Kerja"
//            )
//
//            let jadwal2 = Jadwal(
//                namaJadwal: "Main",
//                tanggal: now,
//                waktuMulai: Calendar.current.date(byAdding: .minute, value: 10, to: now)!,
//                waktuSelesai: Calendar.current.date(byAdding: .minute, value: 40, to: now)!,
//                tipe: "Belajar"
//            )
//            
//          
//                daftarJadwal = [jadwal1, jadwal2]
//                selectedDate = now
                checkForRestReminder()
//             triggerRestNotification()

            startTimer()
        }
    }

    
    
   
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            checkForRestReminder()
        }
    }

   
    private func checkForRestReminder() {
        let sortedJadwal = daftarJadwal
            .filter { $0.tanggal.isSameDay(as: selectedDate) }
            .sorted { $0.waktuMulai < $1.waktuMulai }

        guard sortedJadwal.count >= 2 else { return }

        for index in 1..<sortedJadwal.count {
            let prev = sortedJadwal[index - 1]
            let current = sortedJadwal[index]
            let timeGap = current.waktuMulai.timeIntervalSince(prev.waktuSelesai)

            if current.tipe != prev.tipe && timeGap < 3600 {
                if Date().isWithinTimeRange(of: prev.waktuSelesai, rangeInSeconds: restReminderTimeInterval) {
                    print("Menjadwalkan notifikasi istirahat...")
                    triggerRestNotification()
                }
            }
        }
    }
}





func triggerRestNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Waktunya Istirahat"
    content.body = "Kamu waktunya time delay. Yuk istirahat sebentar!"
    content.sound = .default

   
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Gagal mengirim notifikasi: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}






class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
