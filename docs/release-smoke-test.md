# Release Smoke Test Checklist

Use this checklist for the final release smoke pass after the implemented fixes.

## App Smoke

- [ ] Home opens.
- [ ] Search works for an Indonesian query.
- [ ] Search works for an Arabic query.
- [ ] Material detail opens.
- [ ] Arabic text displays right-to-left.
- [ ] Font scale slider changes Arabic text size.
- [ ] Paragraph cards are readable.
- [ ] Reading screen has no copy/salin action.

## Quran Download Manager

- [ ] Shows loading state.
- [ ] Shows download progress.
- [ ] Shows success state.
- [ ] Shows failure state.

## Lainnya

- [ ] Lainnya icons are clear.
- [ ] KBIHU Nur Multazam is reachable.
- [ ] KBIHU Profil opens.
- [ ] KBIHU Manasik Haji opens.
- [ ] KBIHU Manasik Umroh opens.
- [ ] KBIHU Tempat Sejarah opens.
- [ ] KBIHU Do'a opens.
- [ ] KBIHU Dialog dan Hikmah opens.

## Final Commands To Run Later

```powershell
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --debug
```
