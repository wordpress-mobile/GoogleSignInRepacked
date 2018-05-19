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
				-lSystem -framework UIKit -framework SafariServices -framework GTMOAuth2 -framework GTMSessionFetcher"
SDK_DEVICE_PATH="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
SDK_SIMULATOR_PATH="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
DEVICE_DEPENDENCIES_PATH="../DependencyDevice/"
SIMULATOR_DEPENDENCIES_PATH="../DependencySimulator/"


lipo -info GoogleSignIn

mkdir i386 
mkdir x86_64
mkdir armv7
mkdir arm64

pushd .
cd arm64
lipo ../GoogleSignIn.framework/GoogleSignIn -extract arm64 -output GoogleSignIn
lipo GoogleSignIn -thin arm64 -output GoogleSignInThin
ar -x GoogleSignInThin
libtool -dynamic *.o -o libGoogleSignIn_dynamic.dylib -ios_version_min 8.0 $DEPENDENCIES -syslibroot $SDK_DEVICE_PATH -F$DEVICE_DEPENDENCIES_PATH -arch_only arm64
popd

pushd .
cd armv7
lipo ../GoogleSignIn.framework/GoogleSignIn -extract armv7 -output GoogleSignIn
lipo GoogleSignIn -thin armv7 -output GoogleSignInThin
ar -x GoogleSignInThin
libtool -dynamic *.o -o libGoogleSignIn_dynamic.dylib -ios_version_min 8.0 $DEPENDENCIES -syslibroot $SDK_DEVICE_PATH -F$DEVICE_DEPENDENCIES_PATH -arch_only armv7
popd

pushd .
cd x86_64
ar -x GoogleSignInThin
lipo ../GoogleSignIn.framework/GoogleSignIn -extract x86_64 -output GoogleSignIn
lipo GoogleSignIn -thin x86_64 -output GoogleSignInThin
ar -x GoogleSignInThin
libtool -dynamic *.o -o libGoogleSignIn_dynamic.dylib -ios_simulator_version_min 8.0 $DEPENDENCIES -syslibroot $SDK_SIMULATOR_PATH -F$SIMULATOR_DEPENDENCIES_PATH -arch_only x86_64
popd

pushd .
cd i386
lipo ../GoogleSignIn.framework/GoogleSignIn -extract i386 -output GoogleSignIn
lipo GoogleSignIn -thin i386 -output GoogleSignInThin
ar -x GoogleSignInThin
libtool -dynamic *.o -o libGoogleSignIn_dynamic.dylib -ios_simulator_version_min 8.0 $DEPENDENCIES -syslibroot $SDK_SIMULATOR_PATH -F$SIMULATOR_DEPENDENCIES_PATH -arch_only i386
popd



lipo -create \
	./i386/libGoogleSignIn_dynamic.dylib \
	./x86_64/libGoogleSignIn_dynamic.dylib \
	./arm64/libGoogleSignIn_dynamic.dylib \
	./armv7/libGoogleSignIn_dynamic.dylib \
	-output ./libGoogleSignIn_dynamic.dylib
