//
//  kind.swift
//  csq
//
//  Created by Cope on 1/7/2569 BE.
//

enum data_type: String
{
	case i8, i16, i32, i64
	case u8, u16, u32, u64
}

enum kw: String
{
	case pub
	case mut
	
	case `if`
}

enum oper
{
	enum single: Character
	{
		case assign = "="
		
		case ampersand = "&"
		case caret = "^"
		case star = "*"
		case tilde = "~"
	}
	
	enum double: String
	{
		case eq = "=="
	}
	
//	enum triple: String
//	{
//		
//	}
}

enum punc: Character
{
	case semicolon = ";"
	
	case l_bracket = "{"
	case r_bracket = "}"
	
	case l_paren = "("
	case r_paren = ")"
}

enum kind
{
	case eof
	
	// prolly should make its own thing
	case id(String)
	case int(Int)
	
	case type(data_type)
	case kw(kw)

	case s_oper(oper.single)
	case d_oper(oper.double)
	
	case punc(punc)
}
