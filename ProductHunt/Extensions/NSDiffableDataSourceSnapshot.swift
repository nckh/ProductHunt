import UIKit

extension NSDiffableDataSourceSnapshot {

  mutating func appendSectionIfNeeded(_ identifier: SectionIdentifierType) {
    guard !sectionIdentifiers.contains(identifier) else { return }
    appendSections([identifier])
  }

  mutating func insertSectionIfNeeded(
    _ identifier: SectionIdentifierType,
    afterSection toIdentifier: SectionIdentifierType
  ) {
    guard !sectionIdentifiers.contains(identifier) else { return }
    insertSections([identifier], afterSection: toIdentifier)
  }

}
