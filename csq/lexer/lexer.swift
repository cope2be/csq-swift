//
//  lexer.swift
//  csq
//
//  Created by Cope on 1/7/2569 BE.
//

struct src
{
	let spans: [ Substring ]
	let tokens: [ token ]
}

struct token
{
	let line: Int
}

final class lexer
{
	private var stream: str_stream?
	static let shared = lexer()
	
	private init(){}
	
	func tokenize(_ stream: str_stream) -> src
	{
		guard self.stream == nil else { fatalError("str stream already exist") }
		self.stream = stream
		
		return src(spans: [], tokens: [])
	}
}
