//
//  main.swift
//  csq
//
//  Created by Cope on 30/6/2569 BE.
//

import Foundation

let my_stream = str_stream("""
pub mut i32 x = 1323___123123;
if (x == 0) {}
""")

let my_tokens = lexer.shared.tokenize(my_stream)

print(my_tokens)
