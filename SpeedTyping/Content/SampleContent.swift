import Foundation

enum Library {

    // MARK: - Practice articles (basic → advanced, varied lengths)

    static let practice: [TypingItem] = [
        // BASIC — home row & short words
        TypingItem(title: "Home Row Words", difficulty: .basic,
            text: "a sad lad has a flask. dad asks a lass. all fall as a gas leaks. a salad and a glass."),
        TypingItem(title: "Simple Sentences", difficulty: .basic,
            text: "the cat sat on the mat. a dog ran to the park. we like to play in the sun."),
        TypingItem(title: "Short Greetings", difficulty: .basic,
            text: "hello there. how are you today? i hope you have a good day. see you soon."),

        // EASY — common words, light punctuation
        TypingItem(title: "Daily Routine", difficulty: .easy,
            text: "Every morning I wake up early, brush my teeth, and make a cup of coffee. Then I read the news and plan the tasks for the day ahead."),
        TypingItem(title: "A Walk Outside", difficulty: .easy,
            text: "The path through the garden was quiet and cool. Birds called from the trees while a gentle breeze moved the leaves. It felt good to be outdoors."),

        // INTERMEDIATE — mixed case, numbers, punctuation
        TypingItem(title: "Office Memo", difficulty: .intermediate,
            text: "Please submit your report by Friday, 5 p.m. The meeting is moved to Room 204 on the 3rd floor. Bring 2 printed copies and a charged laptop."),
        TypingItem(title: "The Coffee Shop", difficulty: .intermediate,
            text: "She ordered a flat white and sat by the window. Outside, the city moved in waves: buses, bikes, and hurried footsteps. Inside, the warm hum of conversation wrapped around her like a blanket, and for a moment everything felt unhurried."),

        // ADVANCED — longer, richer vocabulary, symbols
        TypingItem(title: "On Productivity", difficulty: .advanced,
            text: "Productivity is not about doing more; it is about doing what matters. The most effective people protect their attention fiercely, batch shallow work into short windows, and reserve their sharpest hours for deep, demanding tasks. Tools help, but habits decide. A simple rule — \"plan tonight, execute tomorrow\" — often outperforms any app you can buy."),
        TypingItem(title: "The Lighthouse", difficulty: .advanced,
            text: "For forty years the lighthouse keeper climbed the spiral stair at dusk, lit the great lamp, and watched its beam sweep the restless sea. Sailors he would never meet steered by that light; storms he could not calm were tamed, in part, by his quiet diligence. He kept no diary, sought no thanks, and asked for nothing beyond the steady turning of the lens."),

        // EXPERT — dense text, code-like symbols, marathon length
        TypingItem(title: "Code Comments", difficulty: .expert,
            text: "func quicksort(_ a: [Int]) -> [Int] { guard a.count > 1 else { return a }; let pivot = a[a.count / 2]; let less = a.filter { $0 < pivot }; let equal = a.filter { $0 == pivot }; let more = a.filter { $0 > pivot }; return quicksort(less) + equal + quicksort(more) }"),
        TypingItem(title: "The Long Essay", difficulty: .expert,
            text: "Language is a strange and powerful machine. With twenty-six letters and a handful of marks — commas, dashes, brackets, and the occasional semicolon — we encode entire worlds. A single paragraph can argue a case, paint a sunset, or break a heart. Typing well, then, is more than mechanical speed; it is the quiet craft of getting thought onto the page before it slips away. The fastest typists are not merely quick: they are accurate, rhythmic, and unhurried, trusting their fingers to find each key while their minds stay free to think. Practice builds that trust, one deliberate, well-aimed keystroke at a time."),
    ]

    // MARK: - Graded test passages

    static let tests: [TypingItem] = [
        TypingItem(title: "Test 1 · Foundations", difficulty: .easy,
            text: "Good typing begins with good posture and steady rhythm. Sit upright, keep your wrists level, and let your fingers return home after every key."),
        TypingItem(title: "Test 2 · Standard", difficulty: .intermediate,
            text: "The quick brown fox jumps over the lazy dog while a curious cat watches from the fence. Practice this sentence and you will touch every letter on the keyboard."),
        TypingItem(title: "Test 3 · Professional", difficulty: .advanced,
            text: "Clear writing reflects clear thinking. When you type a message, choose words that carry your meaning without waste, and trust short sentences to do the heavy lifting. Speed matters, but clarity matters more."),
        TypingItem(title: "Test 4 · Certification", difficulty: .expert,
            text: "Certification of typing proficiency requires sustained speed under realistic conditions. Maintain accuracy above ninety percent across a passage that mixes capital letters, numbers such as 7 and 42, and punctuation — commas, periods, and the occasional question mark. Are you ready to prove your skill?"),
    ]

    // MARK: - Repetitive fingering drills

    static let drills: [Drill] = [
        Drill(title: "Home Row Anchor", focus: "Left & right index (F J)",
            pattern: "fff jjj fjf jfj fjj jff", repetitions: 6),
        Drill(title: "Home Row Full", focus: "All eight home keys",
            pattern: "asdf jkl; asdf jkl; fdsa ;lkj", repetitions: 5),
        Drill(title: "Left Hand", focus: "Left-hand fingers",
            pattern: "qaz wsx edc rfv tgb", repetitions: 6),
        Drill(title: "Right Hand", focus: "Right-hand fingers",
            pattern: "yhn ujm ik, ol. p;/", repetitions: 6),
        Drill(title: "Index Reach", focus: "Index fingers (T Y G H B N)",
            pattern: "ftf jyj gtg hyh btb nyn", repetitions: 6),
        Drill(title: "Top Row", focus: "Reaching up from home",
            pattern: "qwe rty uio p qwerty uiop", repetitions: 5),
        Drill(title: "Bottom Row", focus: "Reaching down from home",
            pattern: "zxc vbn m zxcv bnm zxcvbnm", repetitions: 5),
        Drill(title: "Common Bigrams", focus: "Speed combos",
            pattern: "th he in er an re nd at on", repetitions: 6),
        Drill(title: "Pinky Power", focus: "Weak pinky fingers (A ; Q P)",
            pattern: "aqaz p;p/ aa ;; qq pp aza p;p", repetitions: 6),
        Drill(title: "Number Row", focus: "Top number reach",
            pattern: "1q 2w 3e 4r 5t 6y 7u 8i 9o 0p", repetitions: 5),
    ]

    // MARK: - Keyboard memory tips

    static let tips: [Tip] = [
        Tip(symbol: "hand.point.up.left.fill", title: "Find the bumps",
            body: "The F and J keys have small raised ridges. Rest your index fingers there without looking — they let your hands return home by feel alone."),
        Tip(symbol: "house.fill", title: "Always return home",
            body: "After pressing any key, snap the finger straight back to its home key (ASDF / JKL;). The home row is your anchor for everything else."),
        Tip(symbol: "eye.slash.fill", title: "Don't look down",
            body: "Trust your muscle memory. Looking at the keys is the single biggest habit slowing typists down. Keep your eyes on the screen."),
        Tip(symbol: "ruler.fill", title: "One finger, one column",
            body: "Each finger owns a diagonal column of keys. The colours on the keyboard guide show exactly which finger presses which key."),
        Tip(symbol: "figure.seated.side", title: "Posture first",
            body: "Sit upright, feet flat, screen at eye level. Keep wrists straight and floating — not resting hard on the desk."),
        Tip(symbol: "metronome.fill", title: "Rhythm beats rushing",
            body: "Aim for an even, steady beat rather than bursts of speed. Smooth, consistent keystrokes are faster over a full passage."),
        Tip(symbol: "checkmark.seal.fill", title: "Accuracy before speed",
            body: "Slow down until you can type a line with no errors, then let speed grow naturally. Fixing mistakes costs more time than typing carefully."),
        Tip(symbol: "arrow.up.circle.fill", title: "Shift with the far hand",
            body: "Use the opposite-hand Shift key from the letter you're capitalising. Capital T (right hand) uses the left Shift, and vice versa."),
    ]
}

struct Tip: Identifiable, Hashable {
    let id = UUID()
    let symbol: String
    let title: String
    let body: String
}
