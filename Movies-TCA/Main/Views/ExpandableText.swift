//
//  ExpandableText.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/12/2023.
//

import SwiftUI
struct ExpandableText<Content: View>: View {
    
    enum ExpandMethod {
        case regular
        case sheet(title: String)
    }
    
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    @State private var showingFullTextSheet: Bool = false
    @State private var shrinkText: String
    
    private var text: String
    private var sheetTitle: String
    
    let font: UIFont
    let lineLimit: Int
    let content: () -> Content
    var expandMethod: ExpandMethod = .regular
    
    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? " read less" : " ... read more"
        }
    }
    
    init(
        _ text: String,
        lineLimit: Int,
        font: UIFont = .systemFont(ofSize: 16),
        expandMethod: ExpandMethod = .regular,
        @ViewBuilder content: @escaping (() -> Content)
    ) {
        self.text = text
        self.lineLimit = lineLimit
        _shrinkText =  State(wrappedValue: text)
        self.font = font
        self.expandMethod = expandMethod
        self.content = content
        
        switch expandMethod {
        case .regular: sheetTitle = .empty
        case .sheet(let title): sheetTitle = title
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            Group {
                Text(self.expanded ? text : shrinkText)
                + Text(moreLessText)
                    .foregroundColor(.accentColor)
            }.animation(.easeInOut, value: expanded)
                .lineLimit(expanded ? nil : lineLimit)
                .background(
                    // Render the limited text and measure its size
                    Text(text).lineLimit(lineLimit)
                        .background(GeometryReader { visibleTextGeometry in
                            Color.clear.onAppear() {
                                let size = CGSize(width: visibleTextGeometry.size.width, height: .greatestFiniteMagnitude)
                                let attributes:[NSAttributedString.Key:Any] = [NSAttributedString.Key.font: font]
                                ///Binary search until mid == low && mid == high
                                var low  = 0
                                var heigh = shrinkText.count
                                var mid = heigh ///start from top so that if text contain we does not need to loop
                                while ((heigh - low) > 1) {
                                    let attributedText = NSAttributedString(string: shrinkText + moreLessText, attributes: attributes)
                                    let boundingRect = attributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                                    if boundingRect.size.height > visibleTextGeometry.size.height {
                                        truncated = true
                                        heigh = mid
                                        mid = (heigh + low)/2
                                        
                                    } else {
                                        if mid == text.count {
                                            break
                                        } else {
                                            low = mid
                                            mid = (low + heigh)/2
                                        }
                                    }
                                    shrinkText = String(text.prefix(mid))
                                }
                                if truncated {
                                    shrinkText = String(shrinkText.prefix(shrinkText.count - 2))  //-2 extra as highlighted text is bold
                                }
                            }
                        })
                        .hidden() // Hide the background
                )
                .font(Font(font))
                .sheet(isPresented: $showingFullTextSheet) {
                    SheetContent(title: sheetTitle, content: content)
                }
            
            if truncated {
                Button(action: {
                    switch expandMethod {
                    case .regular: expanded.toggle()
                    case .sheet:
                        showingFullTextSheet = true
                    }
                }, label: {
                    HStack { //taking tap on only last line, As it is not possible to get 'see more' location
                        Spacer()
                        Text("")
                    }.opacity(0)
                })
            }
        }
    }
}

struct ExpandableText_Previews: PreviewProvider {
    
    static let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    static var previews: some View {
        ExpandableText(text, lineLimit: 3, expandMethod: .sheet(title: "asd")) {
            Text(text)
        }
//        .frame(width: UIScreen.width / 1.2)
        .previewLayout(.sizeThatFits)
    }
}

fileprivate struct SheetContent<Content: View>: View {
    
    let title: String
    let content: () -> Content
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                content()
                Spacer()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button() {
                        dismiss()
                    } label: {
                        Text("Done")
                            .bold()
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
    }
}
