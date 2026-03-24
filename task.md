# Movie-Vault Bug Fixes & Legal Compliance

## Critical: Legal & Movie Showing
- [ ] Fix movie showing approach — change from "WATCH NOW" (implies full movie streaming) to "WATCH TRAILER" (honest about YouTube trailer content)
- [ ] Update [moviePage.dart](file:///f:/3%20year/6th%20Sem/SE/project/Movie-Vault/lib/pages/Main/moviePage.dart) labels to clarify trailer playback
- [ ] Add disclaimer text that content is official YouTube trailers only

## Critical: Crash Bugs
- [ ] Fix null crash in [movieVault.dart](file:///f:/3%20year/6th%20Sem/SE/project/Movie-Vault/lib/pages/Main/movieVault.dart) line 165 — `password!` before null check
- [ ] Fix null-before-check in [movieVaultHome.dart](file:///f:/3%20year/6th%20Sem/SE/project/Movie-Vault/lib/pages/Main/movieVaultHome.dart) line 49 — `user!.uid` before `user == null` check
- [ ] Fix broken password sync in [signin.dart](file:///f:/3%20year/6th%20Sem/SE/project/Movie-Vault/lib/pages/Authorization/signin.dart) lines 58-63 — controllers cleared before password comparison

## Security
- [ ] Remove plaintext password storage in Firestore (signup creates `password` field)
- [ ] Remove password from [getUserPassword()](file:///f:/3%20year/6th%20Sem/SE/project/Movie-Vault/lib/pages/Firebase/database.dart#34-39) usage where possible

## Code Quality
- [ ] Remove all debug `print()` statements across the codebase
- [ ] Fix deprecated `withOpacity` calls → use `Color.fromRGBO` or `.withValues(alpha:)`
- [ ] Fix SVG assets missing from [pubspec.yaml](file:///f:/3%20year/6th%20Sem/SE/project/Movie-Vault/pubspec.yaml) assets declarations
- [ ] Fix `Image.asset` used for `bannerUrl` from Firestore (should support both asset and network images)
- [ ] Add error handling for network images with placeholder fallback

## Verification
- [ ] Run `flutter analyze` to check for errors
- [ ] Verify app runs with `flutter run`
