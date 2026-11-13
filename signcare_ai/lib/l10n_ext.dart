import 'package:flutter/widgets.dart';
import 'l10n/app_localizations.dart';

/// Chhota rasta: AppLocalizations.of(context) ki jagah  context.l10n
/// Misal:  Text(context.l10n.cancel)
extension L10nContext on BuildContext {
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations)!;
}
