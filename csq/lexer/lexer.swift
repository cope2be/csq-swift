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
	let kind: kind
	
	let col: Int
	let line: Int
	let len: Int
}

// TODO: add proper error handling
final class lexer
{
	private var stream: str_stream?
	static let shared = lexer()
	
	private init(){}
	
	private func get_str_kind(_ stream: str_stream, _ start: Character) -> kind
	{
		var str = String(start)
		let (partial_str, _) = stream.next({ ($0.isASCII && $0.isLetter) || $0.isNumber || $0 == "_" })
		
		str.append(contentsOf: partial_str)
		
		if let type = data_type(rawValue: str)
		{
			return .type(type)
		}
		
		if let keyw = kw(rawValue: str)
		{
			return .kw(keyw)
		}
		
		return .id(str)
	}
	
	private func get_int_kind(_ stream: str_stream, _ start: Character) -> kind
	{
		var digits = String(start)
		let (partial_digits, _) = stream.next({ $0.isNumber || $0 == "_" })
		
		digits.append(contentsOf: partial_digits)
		
		// unideal?
		digits.replace("_", with: "")
		
		if let int = Int(digits)
		{
			return kind.int(int)
		}
		
		fatalError("invalid int \(digits)")
	}
	
	func tokenize(_ stream: str_stream) -> src
	{
		guard self.stream == nil else { fatalError("str stream already exist") }
		self.stream = stream
		
		var spans: [ Substring ] = []
		var tokens: [ token ] = []
		
		while !stream.is_empty()
		{
			if let c = stream.peek(), c.isNewline
			{
				stream.consume()
				continue
			}
			
			let local_line = stream.get_line()
			let (span, _) = stream.next({ !$0.isNewline })
			
			spans.append(span)
			
			if let c = stream.peek(), c.isNewline
			{
				stream.consume()
			}
			
			// stupid
			let local_stream = str_stream(span)
			
			while let c = local_stream.next()
			{
				let col = local_stream.get_col() - 1
				
				if c.isASCII && c.isLetter
				{
					tokens.append(.init(
						kind: get_str_kind(local_stream, c),
						col: col,
						line: local_line,
						len: local_stream.get_col() - col
					))
					
					continue
				}
				
				if c.isNumber
				{
					tokens.append(.init(
						kind: get_int_kind(local_stream, c),
						col: col,
						line: local_line,
						len: local_stream.get_col() - col
					))
					
					continue
				}
				
				// perf bottleneck?
				if let s_op = oper.single(rawValue: c)
				{
					if let next_c = local_stream.peek(), let d_op = oper.double(rawValue: String(c) + String(next_c))
					{
						tokens.append(.init(
							kind: .d_oper(d_op),
							col: local_stream.get_col() - 1,
							line: local_line,
							len: 2
						))
						
						local_stream.consume()
						continue
					}
					
					tokens.append(.init(
						kind: .s_oper(s_op),
						col: col,
						line: local_line,
						len: 1
					))
					
					continue
				}
				
				if let pun = punc(rawValue: c)
				{
					tokens.append(.init(
						kind: .punc(pun),
						col: col,
						line: local_line,
						len: 1
					))
					
					continue
				}
			}
		}
		
		tokens.append(.init(kind: .eof, col: stream.get_col(), line: stream.get_line(), len: 1))
		return src(spans: spans, tokens: tokens)
	}
}
