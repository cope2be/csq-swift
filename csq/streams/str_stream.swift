//
//  str_stream.swift
//  csq
//
//  Created by Cope on 30/6/2569 BE.
//

class str_stream
{
	private var remainder: Substring
	
	private var col: Int = 1
	private var line: Int = 1
	
	init(_ src: String)
	{
		remainder = Substring(src)
	}
	
	init(_ src: Substring)
	{
		remainder = src
	}
	
	func get_col() -> Int
	{
		return col
	}
	
	func get_line() -> Int
	{
		return line
	}

	func is_empty() -> Bool
	{
		return remainder.isEmpty
	}
		
	@discardableResult
	func consume() -> Bool
	{
		guard let c = remainder.first else { return false }
		
		if c.isNewline
		{
			col = 1
			line += 1
		}
		else
		{
			col += 1
		}
		
		remainder = remainder.dropFirst()
		return true
	}
	
	@discardableResult
	func consume(_ dist: Int) -> Bool
	{
		for _ in 0..<max(dist, 0)
		{
			if !consume() { return false }
		}
		
		return true
	}
	
	func next() -> Character?
	{
		let c = peek()
		if !consume() { return nil }
		
		return c
	}
	
	func next(_ cond: (Character) -> Bool) -> (Substring, Int)
	{
		let start = remainder
		var len = 0
		
		while let c = peek(), cond(c)
		{
			len += 1
			consume()
		}
		
		return (start[..<remainder.startIndex], len)
	}
	
	func peek() -> Character?
	{
		return remainder.first
	}
	
	// strs are slow in swift :v
	func peek(_ dist: Int) -> Character?
	{
		guard
			let idx = remainder.index(remainder.startIndex, offsetBy: dist, limitedBy: remainder.endIndex),
			idx < remainder.endIndex
		else
		{
			return nil
		}
		
		return remainder[idx]
	}
}
