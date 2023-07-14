//
//  RMCharacter.swift
//  RIckAndMorty
//
//  Created by Dmitrii Tikhomirov on 7/13/23.
//

import Foundation

struct RMCharacter: Codable {

  /// The id of the character.
  let id: Int
  /// The name of the character.
  let name: String
  /// The status of the character ('Alive', 'Dead' or 'unknown').
  let status: RMCharacterStatus
  /// The species of the character.
  let species: String
  /// The type or subspecies of the character.
  let type: String
  /// The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
  let gender: RMCharacterGender
  /// Name and link to the character's origin location.
  let origin: RMOrigin
  /// Name and link to the character's last known location endpoint.
  let location: RMSingleLocation
  /// Link to the character's image. All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
  let image: String
  /// List of episodes in which this character appeared.
  let episode: [String]
  /// Link to the character's own URL endpoint.
  let url: String
  /// Time at which the character was created in the database.
  let created: String

}
