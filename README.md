# Windows downloads

This folder exists so `getlumensteps.com/downloads/windows/<version>/...` is a
real, reserved path on this domain, per Microsoft's Package URL requirement
(direct download, versioned, public, no sign-in, stays unchanged after
submission).

## Where the actual .exe lives

The installer file itself is **not** committed into this repo - a real Windows
installer is 100-250MB+, which is over GitHub's 100MB per-file limit for a
normal `git push` (Git LFS technically raises that limit, but plain GitHub
Pages does not reliably serve LFS-tracked binaries - it tends to serve the LFS
pointer file instead of the real content).

Instead, each version's installer is uploaded as a **GitHub Release asset** on
this repo (lumensteps-arch/lumensteps), which has no such size limit and gives
a stable, versioned, directly-downloadable URL automatically:

```
https://github.com/lumensteps-arch/lumensteps/releases/download/v1.0.0/LumenSteps-Setup-1.0.0.exe
```

That URL is what you paste into the Microsoft Store / winget "Package URL"
field - it satisfies every requirement (immediate .exe download, no sign-in,
public, complete offline installer, versioned, stable). As of this update,
**no release has been published yet** on this repo - see the steps below.

If you later want the literal getlumensteps.com domain in that URL instead of
github.com, move this site's hosting from plain GitHub Pages to **Cloudflare
Pages** (free, same GitHub repo, ~10 minutes to switch DNS). Cloudflare Pages
honors the `_redirects` file at the root of this repo, which already has a
line ready to forward `/downloads/windows/1.0.0/LumenSteps-Setup-1.0.0.exe` on
your own domain straight through to the GitHub Release asset above.

## Releasing a new version, step by step

1. In Unity, bump `Player Settings > Version` and build.
2. Open `LumenSteps.iss` (included alongside this site's source) in Inno Setup
   Compiler, bump `MyAppVersion` at the top to match, point
   `SourceBuildFolder` at your new build folder, and compile. This produces
   `LumenSteps-Setup-<version>.exe`.
3. On GitHub, create a new Release, tag it `v<version>` (e.g. `v1.0.0`), and
   upload the compiled `.exe` as a release asset.
4. Copy the asset's download URL - that's your new Package URL. Add a new line
   for it to `_redirects` if you're using Cloudflare Pages.
