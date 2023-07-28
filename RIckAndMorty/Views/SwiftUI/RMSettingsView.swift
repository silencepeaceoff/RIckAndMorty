//
//  RMSettingsView.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/28/23.
//

import SwiftUI

struct RMSettingsView: View {
  let viewModel: RMSettingsViewVM

  init(viewModel: RMSettingsViewVM) {
    self.viewModel = viewModel
  }

  var body: some View {
    List(viewModel.cellViewModels) { viewModel in
      HStack {
        if let image = viewModel.image {
          Image(uiImage: image)
            .resizable()
            .renderingMode(.template)
            .foregroundColor(.white)
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .padding(6)
            .background(Color(viewModel.iconContainerColor))
            .cornerRadius(6)
        }
        Text(viewModel.title)
          .padding(.leading, 10)
        Spacer()
      }
      .padding(10)
      .onTapGesture {
        viewModel.onTapHandler(viewModel.type)
      }
    }
  }

}

struct RMSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
      return RMSettingsCellVM(type: $0) { _ in

      }
    })))
  }
}
