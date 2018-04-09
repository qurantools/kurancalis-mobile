#!/bin/sh

#sample: 

if [ "$#" -ne 2 ] && [  "x$1" != "xtest" ]  && [ "x$1" != "xmekim" ] ; then
    echo "Illegal number of parameters. Usage: $0 {production <release_version>} | {test}"
    exit 1;
fi

deployment=$1
release=$2
SOURCE_DIR="/users/oksuztepe/Documents/work/dev/trunk/kurancalis.com/kurancalis-web"
TARGET_DIR="/users/oksuztepe/Documents/work/dev/trunk/kurancalis.com/kurancalis-mobile/ionic/qurantools/www"
#SED="sed -i 'bak'"
SED="sed -i"
#SOURCE_DIR="/c/qurantools/web"
#TARGET_DIR="/c/qurantools/mobile2/ionic/qurantools/www"

#copy files
cp -r ${SOURCE_DIR}/app ${SOURCE_DIR}/assets ${SOURCE_DIR}/index.js ${SOURCE_DIR}/m ${SOURCE_DIR}/kurancalis.db ${TARGET_DIR}/
rm -rf ${TARGET_DIR}/assets/img/tutorial

#do some fix

files=`find $TARGET_DIR/../plugins/phonegap-facebook-plugin/ -name AndroidManifest.xml`
for file in $files; do 
        sed -i -e 's/android:minSdkVersion=\".*\"/android:minSdkVersion="14"/' $file
done

files=`find $TARGET_DIR/../platforms/android -name build.gradle`
#for file in $files; do 
#        sed -i -e 's/android:minSdkVersion=\".*\"/android:minSdkVersion="14"/' $file
#done


if [ "$1" == "production" ]; then
    #change fb app ID to test app ID
    $SED 's/400142910165594/295857580594128/g' ${TARGET_DIR}/assets/js/config.js
    $SED 's/e1c0f664bd3e803fce38a8d6399dba2d/8387ff88dfd5c632d6c64059ab3fcebb/g' ${TARGET_DIR}/assets/js/config.js
    
    #change web service address to prod server
    $SED 's/qttest/qt/g' ${TARGET_DIR}/assets/js/config.js
    $SED 's/var domain = .*/var domain = "http:\/\/kurancalis.com";/g' ${TARGET_DIR}/assets/js/config.js
    $SED "s/'webServiceUrl.*/\'webServiceUrl\': \'https:\/\/securewebserver.net\/jetty\/qt\/rest',/g" ${TARGET_DIR}/assets/js/config.js

    $SED 's/400142910165594/295857580594128/g' ${TARGET_DIR}/../plugins/ios.json
    $SED 's/400142910165594/295857580594128/g' ${TARGET_DIR}/../plugins/android.json
    $SED 's/400142910165594/295857580594128/g' ${TARGET_DIR}/../platforms/ios/ios.json
    $SED 's/400142910165594/295857580594128/g' ${TARGET_DIR}/../platforms/android/android.json
    $SED 's/400142910165594/295857580594128/g' ${TARGET_DIR}/../plugins/fetch.json
    $SED 's/400142910165594/295857580594128/g' ${TARGET_DIR}/../package.json


#'webServiceUrl': 'https://securewebserver.net/jetty/qttest/rest',
else
    $SED 's/295857580594128/400142910165594/g' ${TARGET_DIR}/../plugins/ios.json
    $SED 's/295857580594128/400142910165594/g' ${TARGET_DIR}/../plugins/android.json
    $SED 's/295857580594128/400142910165594/g' ${TARGET_DIR}/../plugins/fetch.json
    $SED 's/295857580594128/400142910165594/g' ${TARGET_DIR}/../package.json

    if [ "$1" == "test" ]; then
        $SED 's/var domain = .*/var domain = "http:\/\/test\.kurancalis\.com";/g' ${TARGET_DIR}/assets/js/config.js
        $SED "s/'webServiceUrl.*/\'webServiceUrl\': \'https:\/\/securewebserver.net\/jetty\/qttest\/rest',/g" ${TARGET_DIR}/assets/js/config.js
    elif [ "$1" == "mekim" ]; then
        $SED 's/var domain = .*/var domain = "http:\/\/mekim\.kurancalis\.com:8888\/kurancalis-web";/g' ${TARGET_DIR}/assets/js/config.js
        $SED "s/'webServiceUrl.*/\'webServiceUrl\': \'http:\/\/mekim.kurancalis.com:8080\/QuranToolsApp\/rest',/g" ${TARGET_DIR}/assets/js/config.js
    fi
fi

cd ${TARGET_DIR}/..
ionic cordova prepare ios
ionic cordova prepare android
#sed -i ".bak" 's/android:label=\".*\"/android:label="Kuran ÃalÄ±Å"/' platforms/android/AndroidManifest.xml
#sed -i ".bak" 's/<activity/<activity android:name="org.quran.qurantools.MainActivity"/' platforms/android/AndroidManifest.xml
if [ $1 == "production" ] ; then
    #prepare android jar for store
    ionic build --release android
    jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore qurantools-release-key.keystore ./platforms/android/build/outputs/apk/android-release-unsigned.apk alias_name
    rm qurantools-$release.apk
    pwd
    ~/Library/Android/sdk/build-tools/23.0.1/zipalign -v 4 ${TARGET_DIR}/../platforms/android/build/outputs/apk/android-release-unsigned.apk qurantools-$release.apk
fi
cd -
