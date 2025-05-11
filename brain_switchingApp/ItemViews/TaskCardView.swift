//
//  TaskCardView.swift
//  brain_switchingApp
//
//  Created by MacBook on 12/05/25.
//

import SwiftUI

struct TaskItem {
    let time: String
    let title: String
    let subtitle: String
    let color: Color
}

struct TaskCardView: View {
    let time: String
    let task: TaskItem
    
    var body: some View {
        HStack(alignment: .top) {
            VStack{
                Text(time)
                    .font(.subheadline)
                    .frame(width: 50, alignment: .leading)
                    .foregroundColor(.gray)
                Spacer()
                Text(time)
                    .font(.subheadline)
                    .frame(width: 50, alignment: .leading)
                    .foregroundColor(.gray)

            }
           
            
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.subheadline)
                    .bold()
                HStack{
                    Text(task.subtitle)
                        .foregroundColor(task.color)
                   
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
