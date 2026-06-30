//
//  main.swift
//  csq
//
//  Created by Cope on 30/6/2569 BE.
//

import Foundation

let my_stream = str_stream("""
henlo
hi
asdasd
asd
vvb
""")

while let c = my_stream.next()
{
	print(c)
}
