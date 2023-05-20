//
//  customCalendar.swift
//  BClean!
//
//  Created by Julien Le ber on 23/04/2023.
//

import SwiftUI

struct WeeklyCalendarView: View {
    @State private var selectedDate = Date()
    
    let calendar: Calendar = {
        var cal = Calendar.current
        cal.locale = .current
        cal.firstWeekday = 6 // Set first day of week to Monday
        return cal
    }()
    
    var body: some View {
        VStack {
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<60) { weekIndex in
                            let weekStartDate = self.calendar.date(byAdding: .weekOfYear, value: weekIndex, to: self.selectedDate)!
                            let weekEndDate = self.calendar.date(byAdding: .day, value: 6, to: weekStartDate)!
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("\(self.calendar.shortMonthSymbols[self.calendar.component(.month, from: weekStartDate)-1]) \(self.calendar.component(.day, from: weekStartDate)) - \(self.calendar.component(.day, from: weekEndDate))")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                    .padding(.bottom, 8)
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            self.selectedDate = self.calendar.date(byAdding: .weekOfYear, value: -1, to: self.selectedDate)!
                                        }) {
                                            Image(systemName: "chevron.left")
                                                .font(.system(size: 20))
                                                .foregroundColor(.gray)
                                        }

                                        Button(action: {
                                            self.selectedDate = self.calendar.date(byAdding: .weekOfYear, value: 1, to: self.selectedDate)!
                                        }) {
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 20))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.trailing,10)

                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom,20)
                                }
                                
                                HStack(spacing: 8) {
                                    ForEach(0..<7) { dayIndex in
                                        let date = self.calendar.date(byAdding: .day, value: dayIndex, to: weekStartDate)!
                                        VStack(spacing: 4) {
                                            Text("\(self.calendar.shortWeekdaySymbols[self.calendar.component(.weekday, from: date)-1])")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.accentColor)
                                            
                                            Text("\(self.calendar.component(.day, from: date))")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(date == Date() ? .accentColor : .primary)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                                Divider()
                                VStack {
                                    HStack(spacing: 8) {
                                        ForEach(0..<7) { _ in
                                            VStack {
                                                Circle()
                                                    .foregroundColor(.gray)
                                                    .frame(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
                                                Spacer()
                                            }
                                            .frame(maxWidth: .infinity,maxHeight: UIScreen.main.bounds.width/9)
                                        }
                                    }
                                    Divider()
                                }
                                .padding(.bottom,0)
                                VStack {
                                    HStack {
                                        Text("Alyssa : ")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.secondary)
                                        .padding(.bottom, 0)
                                        Spacer()
                                    }
                                    HStack(spacing: 8) {
                                        ForEach(0..<7) { _ in
                                            VStack {
                                                Circle()
                                                    .foregroundColor(.gray)
                                                    .frame(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
                                                Spacer()
                                            }.frame(maxWidth: .infinity,maxHeight: UIScreen.main.bounds.width/9)
                                        }
                                    }
                                    Divider()
                                }

                            }
                            .frame(width: UIScreen.main.bounds.width - 32, height: 300)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.trailing, 16)

                    .padding(.vertical, 0)
                    .onAppear {
                        UIScrollView.appearance().isPagingEnabled = true
                    }
                }
                .animation(.easeInOut)
                .frame(maxHeight: 300)
            }
            Spacer()
        }
    }
}


struct customCalendar_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyCalendarView()
    }
}
