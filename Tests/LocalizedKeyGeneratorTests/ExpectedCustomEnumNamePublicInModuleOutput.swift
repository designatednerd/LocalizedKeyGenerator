/// This file is automatically generated. Any changes will be overwritten.

import Foundation

public enum TestKeys: String, CaseIterable {

  // Base localization: "This is a library to generate enums for your localized keys."
  case what_is_this

  // Base localization: "I'm Ellen, nice to meet you."
  case who_are_you

  // Base localization: "Because spelling is hard."
  case why_use_this

  public var localizedValue: String {
    NSLocalizedString(self.rawValue,
                      bundle: .module,
                      comment: "")
  }
}