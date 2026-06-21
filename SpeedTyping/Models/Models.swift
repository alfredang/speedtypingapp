import SwiftUI

// MARK: - Difficulty

enum Difficulty: String, CaseIterable, Identifiable, Codable {
    case basic = "Basic"
    case easy = "Easy"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .basic:        return Theme.secondary
        case .easy:         return Color(hex: 0x22C55E)
        case .intermediate: return Theme.highlight
        case .advanced:     return Color(hex: 0xFB923C)
        case .expert:       return Theme.danger
        }
    }

    var icon: String {
        switch self {
        case .basic:        return "1.circle.fill"
        case .easy:         return "2.circle.fill"
        case .intermediate: return "3.circle.fill"
        case .advanced:     return "4.circle.fill"
        case .expert:       return "5.circle.fill"
        }
    }
}

// MARK: - Practice / Test item

struct TypingItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let difficulty: Difficulty
    let text: String

    var characterCount: Int { text.count }
    var wordCount: Int {
        text.split(whereSeparator: { $0 == " " || $0 == "\n" }).count
    }
    /// Rough read time helper used for list subtitles.
    var lengthLabel: String {
        switch characterCount {
        case ..<120:  return "Short"
        case ..<350:  return "Medium"
        case ..<700:  return "Long"
        default:      return "Marathon"
        }
    }
}

// MARK: - Repetitive drill

struct Drill: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let focus: String          // e.g. "Home row", "Left index finger"
    let pattern: String        // text to repeat
    let repetitions: Int

    var fullText: String {
        Array(repeating: pattern, count: repetitions).joined(separator: " ")
    }
}

// MARK: - Result of a finished run

struct TypingResult: Identifiable {
    let id = UUID()
    let title: String
    let wpm: Int
    let cpm: Int
    let accuracy: Double       // 0...1
    let durationSeconds: Double
    let totalCharacters: Int
    let errors: Int
    let passingWPM: Int?       // present only for graded tests

    var passed: Bool? {
        guard let p = passingWPM else { return nil }
        return wpm >= p && accuracy >= 0.90
    }
}
