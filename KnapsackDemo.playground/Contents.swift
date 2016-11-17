import Foundation
import UIKit

// The max number of characters you're capable of writing before the pen runs out of ink
let CHAR_LIMIT = 200

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: .literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}

// Items, ranked from most important to least important. You want to maximize the value of items written down on the note.
var words = ["water canteen", "dried food", "first aid", "cell phone", "flashlight", "pocket knife", "thermos", "shovel", "flares", "ham radio", "salt", "sewing kit", "whistle"]

words = words.map { $0.removeWhitespace() }
words.joined(separator: "").characters.count
struct WordCell {
    var value = 0
    var words = ""
}

func + (left: WordCell, right: WordCell) -> WordCell {
    return WordCell(value: left.value + right.value, words: left.words + right.words)
}

var array: [[WordCell]] = [[WordCell]](repeating:[WordCell](repeating:WordCell(), count: CHAR_LIMIT), count: words.count);

for row in 0..<words.count {
    for column in 0..<CHAR_LIMIT {
        
        var current = WordCell(value: words.count - row, words: words[row])
        var currentWordSpace = current.words.characters.count
        
        var previousMax : WordCell = WordCell(value: 0, words: "")
        var currentPlusRemainingSpaceValue : WordCell = WordCell(value: 0, words: "")
        
        
        if row == 0 {
            if currentWordSpace < column {
                array[row][column] = WordCell(value: current.value, words: current.words)
            }
        } else { // if a subsequent row
            previousMax = array[row-1][column]
            if let fittingWordIndex = Optional.some(column - currentWordSpace), fittingWordIndex >= 0 {
                if let newValue = Optional.some(array[row-1][fittingWordIndex] + current), newValue.words.characters.count <= column {
                    currentPlusRemainingSpaceValue = newValue
                }
            }
            if previousMax.value > currentPlusRemainingSpaceValue.value {
                array[row][column] = previousMax
            } else {
                array[row][column] = currentPlusRemainingSpaceValue
            }
            
        }
        
    }
}



let totalValue = array[words.count - 1][CHAR_LIMIT - 1].value
let writtenWords = array[words.count - 1][CHAR_LIMIT - 1].words

let utilizedChars = array[words.count - 1][CHAR_LIMIT - 1].words.characters.count

let utilizationEfficiencyPercent = Double(utilizedChars)/Double(CHAR_LIMIT) * 100
