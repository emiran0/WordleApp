import SwiftUI

struct KeyboardView: View {
    let keys = [
        ["Q","W","E","R","T","Y","U","I","O","P"],
        ["A","S","D","F","G","H","J","K","L"],
        ["Z","X","C","V","B","N","M"]
    ]
    var onKeyPress: (String) -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(keys, id: \.self) { row in
                HStack(spacing: 5) {
                    ForEach(row, id: \.self) { key in
                        Button(action: {
                            onKeyPress(key)
                        }) {
                            Text(key)
                                .frame(width: 30, height: 50)
                                .background(Color.gray.opacity(0.5))
                                .cornerRadius(5)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            HStack(spacing: 5) {
                Button(action: {
                    onKeyPress("DELETE")
                }) {
                    Image(systemName: "delete.left")
                        .frame(width: 50, height: 50)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(5)
                        .foregroundColor(.white)
                }
                Button(action: {
                    onKeyPress("ENTER")
                }) {
                    Text("Enter")
                        .frame(width: 50, height: 50)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(5)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct Letter {
    var char: Character
    var color: Color
}

