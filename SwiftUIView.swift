//
//  SwiftUIView.swift
//  Test
//
//  Created by Guilherme on 05/09/22.
//

import SwiftUI

struct SwiftUIView: View {
    @ObservedObject var coreBT = CoreBluetoothTest()
    
    var body: some View {
        NavigationView {
            
            List(coreBT.peripheralsNames, id: \.self) { peripheral in
                Text("\(peripheral)")
            }
            .navigationTitle("Peripherals")
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let a = SwiftUIView()
        return a
    }
}


//
//  SwiftUIView.swift
//  Test
//
//  Created by Guilherme on 05/09/22.
//
/*

*/
