##
## 	Source: 	https://developers.google.com/identity/sign-in/ios/sdk/
## 	Specs: 		https://github.com/CocoaPods/Specs/blob/master/Specs/d/4/0/GoogleSignIn/4.1.2/GoogleSignIn.podspec.json
## 	Tutorial: 	https://pewpewthespells.com/blog/convert_static_to_dynamic.html
##
## 	Download:
##		GoogleSignIn.framework
##
##	Build (armv7 + arm64 + x86 + i386):
##		GTMOAuth2.framework
##		GTMSessionFetcher.framework
##
##
DEPENDENCIES="-framework CoreText -framework SystemConfiguration -framework Security -framework Foundation -framework CoreGraphics \
				-lSystem -framework UIKit -framework SafariServices -framework GoogleSignInDependencies"
SDK_DEVICE_PATH="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
SDK_SIMULATOR_PATH="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
DEPENDENCIES_PATH="../Original/"
STATIC_LIB_PATH="Original/GoogleSignIn.framework/GoogleSignIn"


## Just for display: Current bundled architectures
##
lipo -info $STATIC_LIB_PATH


## Creates and access a New Folder
##
createAndAccessFolder() {
	pushd .
	mkdir ${1}
	cd ${1}
}

## Restores the previously pushed folder
##
restorePreviousFolder() {
	popd
}

## Extracts Object Files from the specified Static Library
##
## ${1}: Static Library Path
## ${2}: Target Architecture
##
extractObjectFiles() {
	lipo ${1} -extract ${2} -output Static
	lipo Static -thin ${2} -output Thin
	ar -x Thin
}

## Generates an ARM Dynamic Libary, starting off with a specified Static Library
##
## ${1}: Specific ARM Architecture
##
dynamifyARM() {
	createAndAccessFolder ${1}

	extractObjectFiles ../$STATIC_LIB_PATH ${1}
	libtool -dynamic *.o -o GoogleSignIn -ios_version_min 8.0 $DEPENDENCIES -syslibroot $SDK_DEVICE_PATH -F$DEPENDENCIES_PATH -arch_only ${1}

	restorePreviousFolder
}

## Generates an Intel Dynamic Libary, starting off from the $STATIC_LIB_PATH
##
## ${1}: Specific Intel Architecture
##
dynamifyIntel() {
	createAndAccessFolder ${1}

	extractObjectFiles ../$STATIC_LIB_PATH ${1}
	libtool -dynamic *.o -o GoogleSignIn -ios_simulator_version_min 8.0 $DEPENDENCIES -syslibroot $SDK_SIMULATOR_PATH -F$DEPENDENCIES_PATH -arch_only ${1}

	restorePreviousFolder
}


## Generate Architecture Specific dylib's
##
dynamifyARM arm64
dynamifyARM armv7
dynamifyIntel i386
dynamifyIntel x86_64


## Merge all of the architectures into a single dylib
##
lipo -create ./i386/GoogleSignIn ./x86_64/GoogleSignIn ./arm64/GoogleSignIn ./armv7/GoogleSignIn -output ./GoogleSignIn

## Patch: Install name. Without this, you're DOOMED.
##
install_name_tool -id  "@rpath/GoogleSignIn.framework/GoogleSignIn" GoogleSignIn 
otool -D GoogleSignIn 

## Cleanup
##
rm -rf arm64
rm -rf armv7
rm -rf i386
rm -rf x86_64
