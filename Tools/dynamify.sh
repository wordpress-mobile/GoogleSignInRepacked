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


lipo -info $STATIC_LIB_PATH

mkdir i386 
mkdir x86_64
mkdir armv7
mkdir arm64

pushd .
cd arm64
lipo ../$STATIC_LIB_PATH -extract arm64 -output GoogleSignInStatic
lipo GoogleSignInStatic -thin arm64 -output GoogleSignInThin
ar -x GoogleSignInThin
libtool -dynamic *.o -o GoogleSignIn -ios_version_min 8.0 $DEPENDENCIES -syslibroot $SDK_DEVICE_PATH -F$DEPENDENCIES_PATH -arch_only arm64
popd

pushd .
cd armv7
lipo ../$STATIC_LIB_PATH -extract armv7 -output GoogleSignInStatic
lipo GoogleSignInStatic -thin armv7 -output GoogleSignInThin
ar -x GoogleSignInThin
libtool -dynamic *.o -o GoogleSignIn -ios_version_min 8.0 $DEPENDENCIES -syslibroot $SDK_DEVICE_PATH -F$DEPENDENCIES_PATH -arch_only armv7
popd

pushd .
cd x86_64
lipo ../$STATIC_LIB_PATH -extract x86_64 -output GoogleSignInStatic
lipo GoogleSignInStatic -thin x86_64 -output GoogleSignInThin
ar -x GoogleSignInThin
libtool -dynamic *.o -o GoogleSignIn -ios_simulator_version_min 8.0 $DEPENDENCIES -syslibroot $SDK_SIMULATOR_PATH -F$DEPENDENCIES_PATH -arch_only x86_64
popd

pushd .
cd i386
lipo ../$STATIC_LIB_PATH -extract i386 -output GoogleSignInStatic
lipo GoogleSignInStatic -thin i386 -output GoogleSignInThin
ar -x GoogleSignInThin
libtool -dynamic *.o -o GoogleSignIn -ios_simulator_version_min 8.0 $DEPENDENCIES -syslibroot $SDK_SIMULATOR_PATH -F$DEPENDENCIES_PATH -arch_only i386
popd



lipo -create \
	./i386/GoogleSignIn \
	./x86_64/GoogleSignIn \
	./arm64/GoogleSignIn \
	./armv7/GoogleSignIn \
	-output ./GoogleSignIn

rm -rf arm64
rm -rf armv7
rm -rf i386
rm -rf x86_64
