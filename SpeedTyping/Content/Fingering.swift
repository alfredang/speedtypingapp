import SwiftUI

/// The ten fingers used for touch typing (thumbs share the space bar).
enum Finger: Int, CaseIterable, Identifiable {
    case leftPinky, leftRing, leftMiddle, leftIndex
    case rightIndex, rightMiddle, rightRing, rightPinky
    case thumbs

    var id: Int { rawValue }

    var name: String {
        switch self {
        case .leftPinky:   return "Left pinky"
        case .leftRing:    return "Left ring"
        case .leftMiddle:  return "Left middle"
        case .leftIndex:   return "Left index"
        case .rightIndex:  return "Right index"
        case .rightMiddle: return "Right middle"
        case .rightRing:   return "Right ring"
        case .rightPinky:  return "Right pinky"
        case .thumbs:      return "Thumbs"
        }
    }

    var color: Color {
        switch self {
        case .thumbs: return Theme.mutedInk
        default:      return Theme.fingerColors[rawValue]
        }
    }

    /// The key a finger rests on in home-row position.
    var homeKey: String? {
        switch self {
        case .leftPinky:   return "A"
        case .leftRing:    return "S"
        case .leftMiddle:  return "D"
        case .leftIndex:   return "F"
        case .rightIndex:  return "J"
        case .rightMiddle: return "K"
        case .rightRing:   return "L"
        case .rightPinky:  return ";"
        case .thumbs:      return "Space"
        }
    }
}

/// A single key on the visual keyboard.
struct Key: Identifiable {
    let id = UUID()
    let label: String
    let finger: Finger
    var width: CGFloat = 1.0      // relative width units
    var isHomeKey: Bool = false
}

enum KeyboardLayout {
    /// Standard QWERTY rows with the correct finger assigned to every key.
    static let rows: [[Key]] = [
        // number row
        [
            Key(label: "`", finger: .leftPinky),
            Key(label: "1", finger: .leftPinky),
            Key(label: "2", finger: .leftRing),
            Key(label: "3", finger: .leftMiddle),
            Key(label: "4", finger: .leftIndex),
            Key(label: "5", finger: .leftIndex),
            Key(label: "6", finger: .rightIndex),
            Key(label: "7", finger: .rightIndex),
            Key(label: "8", finger: .rightMiddle),
            Key(label: "9", finger: .rightRing),
            Key(label: "0", finger: .rightPinky),
            Key(label: "-", finger: .rightPinky),
            Key(label: "=", finger: .rightPinky),
            Key(label: "⌫", finger: .rightPinky, width: 1.6),
        ],
        // top row
        [
            Key(label: "Tab", finger: .leftPinky, width: 1.6),
            Key(label: "Q", finger: .leftPinky),
            Key(label: "W", finger: .leftRing),
            Key(label: "E", finger: .leftMiddle),
            Key(label: "R", finger: .leftIndex),
            Key(label: "T", finger: .leftIndex),
            Key(label: "Y", finger: .rightIndex),
            Key(label: "U", finger: .rightIndex),
            Key(label: "I", finger: .rightMiddle),
            Key(label: "O", finger: .rightRing),
            Key(label: "P", finger: .rightPinky),
            Key(label: "[", finger: .rightPinky),
            Key(label: "]", finger: .rightPinky),
        ],
        // home row
        [
            Key(label: "Caps", finger: .leftPinky, width: 1.9),
            Key(label: "A", finger: .leftPinky, isHomeKey: true),
            Key(label: "S", finger: .leftRing, isHomeKey: true),
            Key(label: "D", finger: .leftMiddle, isHomeKey: true),
            Key(label: "F", finger: .leftIndex, isHomeKey: true),
            Key(label: "G", finger: .leftIndex),
            Key(label: "H", finger: .rightIndex),
            Key(label: "J", finger: .rightIndex, isHomeKey: true),
            Key(label: "K", finger: .rightMiddle, isHomeKey: true),
            Key(label: "L", finger: .rightRing, isHomeKey: true),
            Key(label: ";", finger: .rightPinky, isHomeKey: true),
            Key(label: "↩", finger: .rightPinky, width: 1.9),
        ],
        // bottom row
        [
            Key(label: "Shift", finger: .leftPinky, width: 2.4),
            Key(label: "Z", finger: .leftPinky),
            Key(label: "X", finger: .leftRing),
            Key(label: "C", finger: .leftMiddle),
            Key(label: "V", finger: .leftIndex),
            Key(label: "B", finger: .leftIndex),
            Key(label: "N", finger: .rightIndex),
            Key(label: "M", finger: .rightIndex),
            Key(label: ",", finger: .rightMiddle),
            Key(label: ".", finger: .rightRing),
            Key(label: "/", finger: .rightPinky),
            Key(label: "Shift", finger: .rightPinky, width: 2.4),
        ],
        // space row
        [
            Key(label: "Space", finger: .thumbs, width: 10),
        ],
    ]

    /// Maps a typed character to the finger that should press it.
    static func finger(for character: Character) -> Finger? {
        let upper = Character(character.uppercased())
        if character == " " { return .thumbs }
        for row in rows {
            for key in row where key.label.count == 1 {
                if Character(key.label) == upper { return key.finger }
            }
        }
        return nil
    }
}
