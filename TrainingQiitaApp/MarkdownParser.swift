//
//  MarkdownParser.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/17.
//

import Foundation

func parseMarkdownBody(_ body: String) -> [MarkdownLine] {
    var lines: [MarkdownLine] = []
    var isCodeBlock = false
    var codeBuffer: [String] = []
    
    let rawLines = body.components(separatedBy: .newlines)
    
    for line in rawLines {
        if line.contains("<br>") {
            continue
        }

        if line.starts(with: "```") {
            if isCodeBlock {
                let code = codeBuffer.joined(separator: "\n")
                lines.append(.codeBlock(code))
                codeBuffer = []
            }

            isCodeBlock.toggle()
            continue
        }

        if isCodeBlock {
            codeBuffer.append(line)
        } else if line.starts(with: "#### ") {
            lines.append(.heading4(String(line.dropFirst(5))))
        } else if line.starts(with: "### ") {
            lines.append(.heading3(String(line.dropFirst(4))))
        } else if line.starts(with: "## ") {
            lines.append(.heading2(String(line.dropFirst(3))))
        } else if line.starts(with: "# ") {
            lines.append(.heading1(String(line.dropFirst(2))))
        } else if line.contains("<img src="),
                  let urlStart = line.range(of: "src=\"")?.upperBound,
                  let urlEnd = line[urlStart...].range(of: "\"")?.lowerBound {
            let urlString = String(line[urlStart..<urlEnd])
            if let url = URL(string: urlString) {
                lines.append(.image(url))
            }
        } else if let url = URL(string: line), url.scheme?.hasPrefix("http") == true {
            lines.append(.link(url))
        } else if line.starts(with: "![") && line.contains("](") && line.hasSuffix(")") {
            // 画像Markdown形式にマッチしたら処理
            if let start = line.range(of: "](")?.upperBound,
               let end = line.range(of: ")", range: start..<line.endIndex)?.lowerBound {

                let urlString = String(line[start..<end])
                if let url = URL(string: urlString) {
                    lines.append(.image(url))
                }
            }
        } else if line.contains("<img"),
                  let srcRange = line.range(of: #"src="([^"]+)""#, options: .regularExpression) {
              let srcMatch = line[srcRange]
              let urlString = srcMatch.replacingOccurrences(of: #"src=""#, with: "")
                  .replacingOccurrences(of: "\"", with: "")

              if let url = URL(string: urlString) {
                  lines.append(.image(url))
              }
          } else {
            lines.append(.text(line))
        }
    }

    return lines
}
