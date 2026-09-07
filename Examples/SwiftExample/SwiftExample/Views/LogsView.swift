//
//  LogsView.swift
//  SwiftExample
//
//  Created for OpenIM iOS SDK Standalone Swift Example.
//

import SwiftUI

public struct LogsView: View {
    @EnvironmentObject private var service: OpenIMService
    @State private var filterText: String = ""

    public init() {}

    private var filteredLogs: [LogEntry] {
        if filterText.isEmpty {
            return service.logs
        }
        return service.logs.filter {
            $0.message.localizedCaseInsensitiveContains(filterText) ||
            $0.level.rawValue.localizedCaseInsensitiveContains(filterText)
        }
    }

    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if filteredLogs.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "terminal")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text(service.logs.isEmpty ? "No Logs Recorded Yet" : "No Matching Logs")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(filteredLogs) { entry in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Text(entry.level.rawValue)
                                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 1)
                                        .background(badgeColor(for: entry.level))
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 3))

                                    Text(entry.formattedTime)
                                        .font(.system(size: 10, design: .monospaced))
                                        .foregroundColor(.secondary)

                                    Spacer()
                                }

                                Text(entry.message)
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Live Logs")
            .searchable(text: $filterText, prompt: "Filter log messages")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: service.clearLogs) {
                        Image(systemName: "trash")
                    }
                    .disabled(service.logs.isEmpty)
                }
            }
        }
    }

    private func badgeColor(for level: LogEntry.LogLevel) -> Color {
        switch level {
        case .info:
            return .blue
        case .success:
            return .green
        case .warning:
            return .orange
        case .error:
            return .red
        }
    }
}
