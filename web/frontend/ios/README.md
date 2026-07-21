# iOS project — CocoaPods, not Swift Package Manager

This project was originally scaffolded by Capacitor 8 to use Swift Package
Manager (`CapApp-SPM`). It was switched to **CocoaPods** because
`@capacitor-community/speech-recognition` only ships a `.podspec`, not a
`Package.swift`, and mixing both dependency managers for the same modules
(Capacitor/Cordova) causes duplicate-symbol build failures.

**What changed:**
- The `XCLocalSwiftPackageReference`/`XCSwiftPackageProductDependency`
  entries for `CapApp-SPM` were removed from `App.xcodeproj/project.pbxproj`.
  The `CapApp-SPM/` folder itself is still present (Capacitor CLI
  regenerates its `Package.swift` on every `cap sync`) but is **inert** —
  nothing references it anymore.
- A `Podfile` was added that vends `Capacitor`, `CapacitorCordova`, and
  `CapacitorCommunitySpeechRecognition` as pods.
- `debug.xcconfig` now `#include`s the generated
  `Pods-App.debug.xcconfig` (CocoaPods warns about this if it's missing).

## Day-to-day workflow

**Always open `App.xcworkspace`, never `App.xcodeproj` directly** — the
workspace is what pulls in the Pods project.

```bash
cd web/frontend
npm run build && npx cap sync ios   # safe to run any time — pbxproj is untouched
cd ios/App && pod install           # only needed after changing native deps
npx cap open ios                    # opens App.xcworkspace
```

If `cap sync` ever re-adds the SPM package reference (e.g. after a Capacitor
CLI upgrade), redo the removal described above, or run
`npx cap spm-migration-assistant` in reverse by hand — there is no CLI
command to go SPM → CocoaPods automatically.

## Adding another native plugin later

- If it ships `Package.swift`: `npm install` it, `npx cap sync ios` — it'll
  just work via SPM-in-name-only... actually since we removed the SPM
  linkage, prefer adding it to the `Podfile` instead for consistency, or
  check the plugin's podspec exists and add a `pod` line.
- If it only ships a `.podspec`: add a `pod 'ThePluginName', :path => ...`
  line to `Podfile`, then `pod install`.
