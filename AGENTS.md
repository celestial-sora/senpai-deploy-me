# AGENTS.md

## Project overview

`Senpai Push Me` is a SwiftUI iOS 16 app packaged as a Swift Package. It supports iPhone and iPad and presents an interactive Thai-language lesson/game about Git, AI, and deployment.

The app source is under `SenpaiDeployMe.swiftpm/`:

- `Views/` contains SwiftUI screens and reusable UI components.
- `Models/` contains game state and dialogue models.
- `Data/Script.swift` contains the dialogue flow and scene configuration.
- `Resources/Backgrounds/` contains scene backgrounds.
- `Resources/Sprites/` contains character assets.

## Development commands

Run commands from the repository root:

```sh
cd SenpaiDeployMe.swiftpm
swift build
```

The package includes an Apple product configuration for iOS and a macOS executable configuration for environments where `AppleProductTypes` is unavailable.

## SwiftUI conventions

- Keep reusable visual styling in `Views/DesignSystem.swift`.
- Preserve support for both compact iPhone layouts and wide iPad layouts. Avoid fixed sizes when geometry-based sizing or flexible frames are appropriate.
- Keep game progression in `GameState` and dialogue definitions in `Data/Script.swift`; views should trigger state changes through the existing methods.
- Use `ResourceImage` for bundled images so resources continue to work in both iOS and macOS package builds.
- Test interactive controls with touch on iPad, not only with a mouse or simulator keyboard.

## Sprite assets

- Character sprites must use real transparent PNG assets. Do not use JPEG files for sprites: JPEG cannot store transparency, and a checkerboard or other background becomes part of the rendered image.
- Keep the character visually prominent. In `DialogueView`, size the sprite relative to the available geometry and leave enough room for the dialogue panel and choice buttons.
- When replacing a sprite, verify the file format, alpha channel, dimensions, and how it looks over a scene background.

## iPad keyboard and input behavior

- The terminal mini-game is a touch-selection/reordering interaction. If text input or keyboard dismissal is added, explicitly test on a physical iPad and the iPad simulator.
- Do not rely on macOS keyboard behavior to validate iPad behavior.
- Any text field must have a clear focus/dismissal path and must not be covered by the keyboard. Use safe-area-aware layout and keyboard notifications or SwiftUI focus management where needed.
- Avoid attaching gestures or transparent overlays above controls that can intercept taps or keyboard-related focus changes.

## Verification checklist

Before handing off UI changes:

1. Run `swift build` from `SenpaiDeployMe.swiftpm/`.
2. Test the first dialogue scene in portrait and landscape.
3. Test the terminal puzzle on iPad, including every interactive control and any keyboard flow.
4. Confirm sprites have no visible checkerboard/background and are large enough to read at the intended window size.
5. Review `git diff` and avoid committing generated build artifacts.

