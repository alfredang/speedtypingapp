import SwiftUI
import Combine

/// Drives a single typing run: captures typed input, compares against the target,
/// and exposes live speed (WPM / CPM) and accuracy metrics.
@MainActor
final class TypingEngine: ObservableObject {
    let target: String
    private let targetChars: [Character]

    @Published var typed: String = "" {
        didSet { handleTypedChange(from: oldValue) }
    }
    @Published private(set) var startDate: Date?
    @Published private(set) var endDate: Date?
    @Published private(set) var elapsed: TimeInterval = 0
    @Published private(set) var isFinished = false

    /// Number of keystrokes that were wrong at the moment they were typed.
    private(set) var keystrokeErrors = 0

    private var timer: AnyCancellable?

    init(target: String) {
        self.target = target
        self.targetChars = Array(target)
    }

    // MARK: - Derived metrics

    /// Index of the next character the user must type.
    var cursor: Int { min(typed.count, targetChars.count) }

    /// Per-character correctness for everything typed so far.
    var typedChars: [Character] { Array(typed) }

    var minutesElapsed: Double {
        max(elapsed, 0.001) / 60.0
    }

    /// Net words-per-minute: standard 5-characters-per-word, correct chars only.
    var wpm: Int {
        let correct = Double(correctCharacterCount)
        return Int(((correct / 5.0) / minutesElapsed).rounded())
    }

    /// Characters-per-minute of correctly typed characters.
    var cpm: Int {
        Int((Double(correctCharacterCount) / minutesElapsed).rounded())
    }

    var correctCharacterCount: Int {
        let t = typedChars
        var count = 0
        for i in 0..<min(t.count, targetChars.count) where t[i] == targetChars[i] {
            count += 1
        }
        return count
    }

    /// Accuracy across all keystrokes ever pressed (penalises corrected mistakes).
    var accuracy: Double {
        let totalKeystrokes = correctCharacterCount + keystrokeErrors
        guard totalKeystrokes > 0 else { return 1.0 }
        return Double(correctCharacterCount) / Double(totalKeystrokes)
    }

    var progress: Double {
        guard !targetChars.isEmpty else { return 0 }
        return Double(cursor) / Double(targetChars.count)
    }

    // MARK: - Lifecycle

    private func handleTypedChange(from old: String) {
        if startDate == nil && !typed.isEmpty {
            start()
        }
        // Count newly committed wrong keystrokes (only when growing forward).
        if typed.count > old.count {
            let t = typedChars
            for i in old.count..<t.count where i < targetChars.count {
                if t[i] != targetChars[i] { keystrokeErrors += 1 }
            }
        }
        if typed.count >= targetChars.count && !isFinished {
            finish()
        }
    }

    private func start() {
        startDate = Date()
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, let start = self.startDate, !self.isFinished else { return }
                self.elapsed = Date().timeIntervalSince(start)
            }
    }

    func finish() {
        guard let start = startDate else { return }
        endDate = Date()
        elapsed = endDate!.timeIntervalSince(start)
        isFinished = true
        timer?.cancel()
        timer = nil
    }

    func reset() {
        typed = ""
        startDate = nil
        endDate = nil
        elapsed = 0
        isFinished = false
        keystrokeErrors = 0
        timer?.cancel()
        timer = nil
    }

    func makeResult(title: String, passingWPM: Int? = nil) -> TypingResult {
        TypingResult(
            title: title,
            wpm: wpm,
            cpm: cpm,
            accuracy: accuracy,
            durationSeconds: elapsed,
            totalCharacters: typed.count,
            errors: keystrokeErrors,
            passingWPM: passingWPM
        )
    }
}
