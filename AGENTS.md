# Repository Guidelines

## Project Structure & Module Organization
- `flake.nix` is the entry point; `.treefmt.nix` configures formatting. Inputs for `nixpkgs`, `home-manager`, `nix-darwin`, `nixos-wsl`, and `Hyprland` are declared here.
- Host definitions live in `hosts/`. Each file (e.g., `hosts/geralt.nix`, `hosts/ziraeal.nix`) is a small attrset describing system type, desktop, and per-host modules. `.bak` files are archived variants.
- Shared modules sit under `modules/` (desktop, shell, security, darwin helpers). They are automatically discovered via `utils/modules.nix`.
- User definitions are in `users/` and custom packages or overlays in `pkgs/`. Utility functions for host assembly are in `utils/`.

## Build, Test, and Development Commands
- Format Nix files: `nix fmt` (wraps treefmt running `nixfmt` + `deadnix`).
- Evaluate everything: `nix flake check` (verifies flake outputs and formatting).
- Switch NixOS host: `sudo nixos-rebuild switch --flake .#geralt` (replace `geralt` with the target hostname).
- Switch macOS host: `sudo darwin-rebuild switch --flake .#ziraeal`.
- Manage MAS apps on macOS: `sudo MANAGE_MAS_APPS=1 darwin-rebuild switch --flake .#ziraeal` (omit the env var to skip MAS installs if not signed into the App Store).
- Dry runs are encouraged before applying: append `--dry-run` to rebuild commands.

## Coding Style & Naming Conventions
- Nix files are formatted with `nixfmt`; use two-space indentation and trailing commas as it emits.
- Keep attribute names lowercase with hyphens only when required by upstream options. Prefer `lib` helpers (`mkForce`, `mkMerge`) over manual overrides.
- Name hosts after their file stem and keep module filenames descriptive (`desktop/wayland.nix`, `shell/direnv.nix`).

## Testing & Validation
- Always run `nix fmt` then `nix flake check` before opening a PR to ensure options resolve and dead code is trimmed.
- For risky changes, run a host-specific dry activation: `sudo nixos-rebuild test --flake .#vesemir` or `darwin-rebuild check --flake .#ziraeal` to catch service/permission issues without switching.

## Commit & Pull Request Guidelines
- Use short, imperative commits similar to history (`update to 25.11`, `flake update`). Group related edits together.
- PRs should mention the touched hosts/modules, list the commands run (e.g., `nix fmt`, `nix flake check`, rebuild dry-run), and note any behavioral changes (desktop defaults, services enabled, secrets handling).
- Include screenshots only when visual behavior changes (e.g., Hyprland/desktop tweaks); otherwise prefer concise bullet summaries.

## Security & Configuration Tips
- Do not commit secrets or machine-specific tokens; prefer environment variables or external files referenced in `home-manager` when needed.
- Keep `unfree` usage deliberate per host; match `allowUnfree` flags to host needs and document why when adding new packages.
