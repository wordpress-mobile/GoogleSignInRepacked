## Description:

This repository contains the [GoogleSignIn library](https://developers.google.com/identity/sign-in/ios/sdk/), repacked as a *dynamic* library.
Plus: in the `Tools` folder you'll find the bash script used to do this.

What does this mean?

**Static Frameworks** simply mean that they contain object files, packed together. Bottom line, this object code is integrated within your app's namespace, directly.
**Dynamic Frameworks** consist of libraries that can be dynamically loaded, but it's code doesn't add up to your final binary.


## Details:

Once dynamified, you need to grab `GoogleSignIn.framework` and:

- 	Replace it's inner binary.
- 	Inject an `Info.plist` file, which isn't required in Static Frameworks (but is a must for dynamic ones).
-	Ship a new version of cocoapods

## Notes:

No code was disassembled (NOR) modified. This is, purely, a `.framework` patched version.
This work was done because: frameworks distributed via cocoapods can't have `static libraries` (distributed via cocoapods, again) as dependencies.

And that was precisely the use case i've hit!.
