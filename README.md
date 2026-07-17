# Windows downloads

## Why this isn't a GitHub Release

GitHub Release assets don't actually serve from github.com - the real file
sits on `release-assets.githubusercontent.com`, and github.com returns a
`302` redirect to get you there. That's invisible in a browser (browsers
follow redirects automatically) but Microsoft Partner Center's package
validator checks the exact submitted URL for a direct `200 OK` and rejects
anything that redirects. So GitHub Releases are not usable as the Package URL
here, full stop - this isn't fixable by changing the URL, the redirect is
built into how GitHub serves release assets.

## The real setup: Cloudflare R2 + a downloads subdomain

Final URL: `https://downloads.getlumensteps.com/windows/1.0.0/LumenSteps-Setup-1.0.0.exe`

This requires action in your Cloudflare account (I can't do this part for
you - it needs your login and control of the domain's DNS):

1. Create a free Cloudflare account if you don't have one, and add
   `getlumensteps.com` to it if it isn't already there (this only affects
   DNS/routing - it does not change where your GitHub Pages site is hosted or
   require moving the main site).
2. In the Cloudflare dashboard, open **R2 Object Storage** and create a
   bucket, e.g. `lumensteps-downloads`.
3. Upload the compiled installer into the bucket under a versioned key/path:
   `windows/1.0.0/LumenSteps-Setup-1.0.0.exe`. While uploading (or after, via
   the object's metadata), make sure **Content-Type** is set to
   `application/octet-stream` - some upload paths guess this correctly from
   the `.exe` extension automatically, but check it explicitly.
4. In the bucket's **Settings > Custom Domains**, connect
   `downloads.getlumensteps.com`. Cloudflare walks you through adding the
   DNS record for you since the domain's already on your account - this is
   what makes R2 serve objects directly (200 OK, no redirect) instead of via
   a signed/redirected URL.
5. Verify from a terminal before submitting anything to Microsoft:
   ```
   curl.exe -I "https://downloads.getlumensteps.com/windows/1.0.0/LumenSteps-Setup-1.0.0.exe"
   ```
   Expect `HTTP/2 200` (not 301/302/307/308) and a `Content-Type` around
   `application/octet-stream`.
6. Submit `https://downloads.getlumensteps.com/windows/1.0.0/LumenSteps-Setup-1.0.0.exe`
   as the Package URL.

Your main site (`getlumensteps.com`, this repo, GitHub Pages) is untouched by
any of this - `downloads.getlumensteps.com` is a separate subdomain pointed
at R2, not at this repo.

## Releasing a new version

1. In Unity, bump `Player Settings > Version` and build.
2. Open `LumenSteps.iss` (included alongside this site's source) in Inno Setup
   Compiler, bump `MyAppVersion` at the top to match, point
   `SourceBuildFolder` at your new build folder, and compile. This produces
   `LumenSteps-Setup-<version>.exe`.
3. Upload it into the R2 bucket under a new versioned path, e.g.
   `windows/1.1.0/LumenSteps-Setup-1.1.0.exe` - never overwrite a previous
   version's object once it's been submitted anywhere.
4. New Package URL: `https://downloads.getlumensteps.com/windows/1.1.0/LumenSteps-Setup-1.1.0.exe`
