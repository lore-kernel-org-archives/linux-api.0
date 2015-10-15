From: Stefan Achatz <erazor_de@users.sourceforge.net>
Subject: [PATCH] HID: roccat: Deprecating most Roccat sysfs attributes
Date: Thu, 15 Oct 2015 17:00:09 +0200
Message-ID: <1444921209.2900.17.camel@neuromancer.tessier-ashpool>
Reply-To: erazor_de@users.sourceforge.net
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-input-owner@vger.kernel.org>
Sender: linux-input-owner@vger.kernel.org
To: jkosina@suse.cz, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Deprecates all Roccat sysfs attributes except the ones for the old Kone by moving
abi descriptions from testing to obsolete.
For most devices everything can be done using the hidraw ioctls HIDIOCGFEATURE
and HIDIOCSFEATURE, so I would suggest future removal of device specific drivers.
The userspace tools don't use these attributes for a year now.
The first Kone is not fully HID-compliant and will still need a module.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/obsolete/sysfs-driver-hid-roccat-arvo      |  53 ++++++
 .../ABI/obsolete/sysfs-driver-hid-roccat-isku      | 153 ++++++++++++++++++
 .../ABI/obsolete/sysfs-driver-hid-roccat-koneplus  |  99 +++++++++++-
 .../ABI/obsolete/sysfs-driver-hid-roccat-konepure  | 105 ++++++++++++
 .../ABI/obsolete/sysfs-driver-hid-roccat-kovaplus  |  50 ++++++
 .../ABI/obsolete/sysfs-driver-hid-roccat-lua       |   7 +
 .../ABI/obsolete/sysfs-driver-hid-roccat-pyra      |  50 ++++++
 .../ABI/obsolete/sysfs-driver-hid-roccat-ryos      | 178 +++++++++++++++++++++
 .../ABI/obsolete/sysfs-driver-hid-roccat-savu      |  76 +++++++++
 .../ABI/testing/sysfs-driver-hid-roccat-arvo       |  53 ------
 .../ABI/testing/sysfs-driver-hid-roccat-isku       | 153 ------------------
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |  96 -----------
 .../ABI/testing/sysfs-driver-hid-roccat-konepure   | 105 ------------
 .../ABI/testing/sysfs-driver-hid-roccat-kovaplus   |  49 ------
 .../ABI/testing/sysfs-driver-hid-roccat-lua        |   7 -
 .../ABI/testing/sysfs-driver-hid-roccat-pyra       |  49 ------
 .../ABI/testing/sysfs-driver-hid-roccat-ryos       | 178 ---------------------
 .../ABI/testing/sysfs-driver-hid-roccat-savu       |  76 ---------
 18 files changed, 770 insertions(+), 767 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-arvo
 create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-isku
 create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-konepure
 create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-lua
 create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-ryos
 create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-savu
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-konepure
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-lua
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-ryos
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-savu

diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-arvo b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-arvo
new file mode 100644
index 0000000..55e281b
--- /dev/null
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-arvo
@@ -0,0 +1,53 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/actual_profile
+Date:		Januar 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 1-5.
+		When read, this attribute returns the number of the actual
+		profile which is also the profile that's active on device startup.
+		When written this attribute activates the selected profile
+		immediately.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/button
+Date:		Januar 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The keyboard can store short macros with consist of 1 button with
+		several modifier keys internally.
+		When written, this file lets one set the sequence for a specific
+		button for a specific profile. Button and profile numbers are
+		included in written data. The data has to be 24 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/info
+Date:		Januar 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns some info about the device like the
+		installed firmware version.
+		The size of the data is 8 bytes in size.
+		This file is readonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/key_mask
+Date:		Januar 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The keyboard lets the user deactivate 5 certain keys like the
+		windows and application keys, to protect the user from the outcome
+		of accidentally pressing them.
+		The integer value of this attribute has bits 0-4 set depending
+		on the state of the corresponding key.
+		When read, this file returns the current state of the buttons.
+		When written, the given buttons are activated/deactivated
+		immediately.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/mode_key
+Date:		Januar 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The keyboard has a condensed layout without num-lock key.
+		Instead it uses a mode-key which activates a gaming mode where
+		the assignment of the number block changes.
+		The integer value of this attribute ranges from 0 (OFF) to 1 (ON).
+		When read, this file returns the actual state of the key.
+		When written, the key is activated/deactivated immediately.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-isku b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-isku
new file mode 100644
index 0000000..c601d0f
--- /dev/null
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-isku
@@ -0,0 +1,153 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/actual_profile
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 0-4.
+		When read, this attribute returns the number of the actual
+		profile. This value is persistent, so its equivalent to the
+		profile that's active when the device is powered on next time.
+		When written, this file sets the number of the startup profile
+		and the device activates this profile immediately.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/info
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns general data like firmware version.
+		The data is 6 bytes long.
+		This file is readonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/key_mask
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one deactivate certain keys like
+		windows and application keys, to prevent accidental presses.
+		Profile number for which this settings occur is included in
+		written data. The data has to be 6 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_capslock
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		capslock key for a specific profile. Profile number is included
+		in written data. The data has to be 6 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_easyzone
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		easyzone keys for a specific profile. Profile number is included
+		in written data. The data has to be 65 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_function
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		function keys for a specific profile. Profile number is included
+		in written data. The data has to be 41 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_macro
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the macro
+		keys for a specific profile. Profile number is included in
+		written data. The data has to be 35 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_media
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the media
+		keys for a specific profile. Profile number is included in
+		written data. The data has to be 29 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_thumbster
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		thumbster keys for a specific profile. Profile number is included
+		in written data. The data has to be 23 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/last_set
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the time in secs since
+		epoch in which the last configuration took place.
+		The data has to be 20 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/light
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the backlight intensity for
+		a specific profile. Profile number is included in written data.
+		The data has to be 10 bytes long for Isku, IskuFX needs	16 bytes
+		of data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/macro
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one store macros with max 500
+		keystrokes for a specific button for a specific profile.
+		Button and profile numbers are included in written data.
+		The data has to be 2083 bytes long.
+		Before reading this file, control has to be written to select
+		which profile and key to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/reset
+Date:		November 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one reset the device.
+		The data has to be 3 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/control
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one select which data from which
+		profile will be	read next. The data has to be 3 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/talk
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one trigger easyshift functionality
+		from the host.
+		The data has to be 16 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/talkfx
+Date:		February 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one trigger temporary color schemes
+		from the host.
+		The data has to be 16 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus
index 833fd59..545e69f 100644
--- a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus
@@ -1,3 +1,14 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/actual_profile
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 0-4.
+                When read, this attribute returns the number of the actual
+                profile. This value is persistent, so its equivalent to the
+                profile that's active when the mouse is powered on next time.
+		When written, this file sets the number of the startup profile
+		and the mouse activates this profile immediately.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/startup_profile
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
@@ -22,6 +33,40 @@ Description:	When read, this file returns the raw integer version number of the
 		Please read binary attribute info which contains firmware version.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/info
+Date:		November 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
+		The data is 8 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/macro
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store a macro with max 500 key/button strokes
+		internally.
+		When written, this file lets one set the sequence for a specific
+		button for a specific profile. Button and profile numbers are
+		included in written data. The data has to be 2082 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile_buttons
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_buttons holds information about button layout.
+		When written, this file lets one write the respective profile
+		buttons back to the mouse. The data has to be 77 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile[1-5]_buttons
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
@@ -34,6 +79,22 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Write control to select profile and read profile_buttons instead.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile_settings
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_settings holds information like resolution, sensitivity
+		and light effects.
+		When written, this file lets one write the respective profile
+		settings back to the mouse. The data has to be 43 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile[1-5]_settings
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
@@ -45,4 +106,40 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		The returned data is 43 bytes in size.
 		This file is readonly.
 		Write control to select profile and read profile_settings instead.
-Users:		http://roccat.sourceforge.net
\ No newline at end of file
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/sensor
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse has a tracking- and a distance-control-unit. These
+		can be activated/deactivated and the lift-off distance can be
+		set. The data has to be 6 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/talk
+Date:		May 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	Used to active some easy* functions of the mouse from outside.
+		The data has to be 16 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written a calibration process for the tracking control unit
+		can be initiated/cancelled. Also lets one read/write sensor
+		registers.
+		The data has to be 4 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu_image
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read the mouse returns a 30x30 pixel image of the
+		sampled underground. This works only in the course of a
+		calibration process initiated with tcu.
+		The returned data is 1028 bytes in size.
+		This file is readonly.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-konepure b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-konepure
new file mode 100644
index 0000000..41a9b7f
--- /dev/null
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-konepure
@@ -0,0 +1,105 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/actual_profile
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. actual_profile holds number of actual profile.
+		This value is persistent, so its value determines the profile
+		that's active when the mouse is powered on next time.
+		When written, the mouse activates the set profile immediately.
+		The data has to be 3 bytes long.
+		The mouse will reject invalid data.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/control
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one select which data from which
+		profile will be	read next. The data has to be 3 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/info
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
+		The data is 6 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/macro
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store a macro with max 500 key/button strokes
+		internally.
+		When written, this file lets one set the sequence for a specific
+		button for a specific profile. Button and profile numbers are
+		included in written data. The data has to be 2082 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/profile_buttons
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_buttons holds information about button layout.
+		When written, this file lets one write the respective profile
+		buttons back to the mouse. The data has to be 59 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/profile_settings
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_settings holds information like resolution, sensitivity
+		and light effects.
+		When written, this file lets one write the respective profile
+		settings back to the mouse. The data has to be 31 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/sensor
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse has a tracking- and a distance-control-unit. These
+		can be activated/deactivated and the lift-off distance can be
+		set. The data has to be 6 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/talk
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	Used to active some easy* functions of the mouse from outside.
+		The data has to be 16 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/tcu
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written a calibration process for the tracking control unit
+		can be initiated/cancelled. Also lets one read/write sensor
+		registers.
+		The data has to be 4 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/tcu_image
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read the mouse returns a 30x30 pixel image of the
+		sampled underground. This works only in the course of a
+		calibration process initiated with tcu.
+		The returned data is 1028 bytes in size.
+		This file is readonly.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus
index 4a98e02..ab01631 100644
--- a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus
@@ -8,6 +8,17 @@ Description:	The integer value of this attribute ranges from 1-4.
 		Has never been used. If bookkeeping is done, it's done in userland tools.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_profile
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 0-4.
+		When read, this attribute returns the number of the active
+		profile.
+		When written, the mouse activates this profile immediately.
+		The profile that's active when powered down is the same that's
+		active when the mouse is powered on.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_sensitivity_x
 Date:		January 2011
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
@@ -40,6 +51,29 @@ Description:	When read, this file returns the raw integer version number of the
 		Obsoleted by binary sysfs attribute "info".
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/info
+Date:		November 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
+		The data is 6 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_buttons
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_buttons holds information about button layout.
+		When written, this file lets one write the respective profile
+		buttons back to the mouse. The data has to be 23 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile[1-5]_buttons
 Date:		January 2011
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
@@ -52,6 +86,22 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Write control to select profile and read profile_buttons instead.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_settings
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_settings holds information like resolution, sensitivity
+		and light effects.
+		When written, this file lets one write the respective profile
+		settings back to the mouse. The data has to be 16 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile[1-5]_settings
 Date:		January 2011
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-lua b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-lua
new file mode 100644
index 0000000..31c6c4c
--- /dev/null
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-lua
@@ -0,0 +1,7 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/control
+Date:		October 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, cpi, button and light settings can be configured.
+		When read, actual cpi setting and sensor data are returned.
+		The data has to be 8 bytes long.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
index 87ac87e..16020b3 100644
--- a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
@@ -37,6 +37,29 @@ Description:	When read, this file returns the raw integer version number of the
 		Please use binary attribute "info" which provides this information.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/info
+Date:		November 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
+		The data is 6 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_buttons
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_buttons holds information about button layout.
+		When written, this file lets one write the respective profile
+		buttons back to the mouse. The data has to be 19 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile[1-5]_buttons
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
@@ -49,6 +72,22 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Write control to select profile and read profile_buttons instead.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_settings
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_settings holds information like resolution, sensitivity
+		and light effects.
+		When written, this file lets one write the respective profile
+		settings back to the mouse. The data has to be 13 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile[1-5]_settings
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
@@ -62,6 +101,17 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Write control to select profile and read profile_settings instead.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/settings
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the settings stored in the mouse.
+		The size of the data is 3 bytes and holds information on the
+		startup_profile.
+		When written, this file lets write settings back to the mouse.
+		The data has to be 3 bytes long. The mouse will reject invalid
+		data.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/startup_profile
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-ryos b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-ryos
new file mode 100644
index 0000000..1d6a8cf
--- /dev/null
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-ryos
@@ -0,0 +1,178 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/control
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one select which data from which
+		profile will be	read next. The data has to be 3 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/profile
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. profile holds index of actual profile.
+		This value is persistent, so its value determines the profile
+		that's active when the device is powered on next time.
+		When written, the device activates the set profile immediately.
+		The data has to be 3 bytes long.
+		The device will reject invalid data.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_primary
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the default of all keys for
+		a specific profile. Profile index is included in written data.
+		The data has to be 125 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_function
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		function keys for a specific profile. Profile index is included
+		in written data. The data has to be 95 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_macro
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the macro
+		keys for a specific profile. Profile index is included in
+		written data. The data has to be 35 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_thumbster
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		thumbster keys for a specific profile. Profile index is included
+		in written data. The data has to be 23 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_extra
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		capslock and function keys for a specific profile. Profile index
+		is included in written data. The data has to be 8 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_easyzone
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		easyzone keys for a specific profile. Profile index is included
+		in written data. The data has to be 294 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/key_mask
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one deactivate certain keys like
+		windows and application keys, to prevent accidental presses.
+		Profile index for which this settings occur is included in
+		written data. The data has to be 6 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/light
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the backlight intensity for
+		a specific profile. Profile index is included in written data.
+		This attribute is only valid for the glow and pro variant.
+		The data has to be 16 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/macro
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one store macros with max 480
+		keystrokes for a specific button for a specific profile.
+		Button and profile indexes are included in written data.
+		The data has to be 2002 bytes long.
+		Before reading this file, control has to be written to select
+		which profile and key to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/info
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns general data like firmware version.
+		The data is 8 bytes long.
+		This file is readonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/reset
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one reset the device.
+		The data has to be 3 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/talk
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one trigger easyshift functionality
+		from the host.
+		The data has to be 16 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/light_control
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one switch between stored and custom
+		light settings.
+		This attribute is only valid for the pro variant.
+		The data has to be 8 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/stored_lights
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set per-key lighting for different
+		layers.
+		This attribute is only valid for the pro variant.
+		The data has to be 1382 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/custom_lights
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the actual per-key lighting.
+		This attribute is only valid for the pro variant.
+		The data has to be 20 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/light_macro
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set a light macro that is looped
+		whenever the device gets in dimness mode.
+		This attribute is only valid for the pro variant.
+		The data has to be 2002 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-savu b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-savu
new file mode 100644
index 0000000..f1e02a9
--- /dev/null
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-savu
@@ -0,0 +1,76 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/buttons
+Date:		Mai 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split into general settings and
+		button settings. buttons holds informations about button layout.
+		When written, this file lets one write the respective profile
+		buttons to the mouse. The data has to be 47 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/control
+Date:		Mai 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one select which data from which
+		profile will be	read next. The data has to be 3 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/general
+Date:		Mai 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split into general settings and
+		button settings. profile holds informations like resolution, sensitivity
+		and light effects.
+		When written, this file lets one write the respective profile
+		settings back to the mouse. The data has to be 43 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/info
+Date:		Mai 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
+		The data is 8 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/macro
+Date:		Mai 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one store macros with max 500
+		keystrokes for a specific button for a specific profile.
+		Button and profile numbers are included in written data.
+		The data has to be 2083 bytes long.
+		Before reading this file, control has to be written to select
+		which profile and key to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/profile
+Date:		Mai 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. profile holds number of actual profile.
+		This value is persistent, so its value determines the profile
+		that's active when the mouse is powered on next time.
+		When written, the mouse activates the set profile immediately.
+		The data has to be 3 bytes long.
+		The mouse will reject invalid data.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/sensor
+Date:		July 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse has a Avago ADNS-3090 sensor.
+		This file allows reading and writing of the mouse sensors registers.
+		The data has to be 4 bytes long.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo b/Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo
deleted file mode 100644
index 55e281b..0000000
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo
+++ /dev/null
@@ -1,53 +0,0 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/actual_profile
-Date:		Januar 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The integer value of this attribute ranges from 1-5.
-		When read, this attribute returns the number of the actual
-		profile which is also the profile that's active on device startup.
-		When written this attribute activates the selected profile
-		immediately.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/button
-Date:		Januar 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The keyboard can store short macros with consist of 1 button with
-		several modifier keys internally.
-		When written, this file lets one set the sequence for a specific
-		button for a specific profile. Button and profile numbers are
-		included in written data. The data has to be 24 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/info
-Date:		Januar 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns some info about the device like the
-		installed firmware version.
-		The size of the data is 8 bytes in size.
-		This file is readonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/key_mask
-Date:		Januar 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The keyboard lets the user deactivate 5 certain keys like the
-		windows and application keys, to protect the user from the outcome
-		of accidentally pressing them.
-		The integer value of this attribute has bits 0-4 set depending
-		on the state of the corresponding key.
-		When read, this file returns the current state of the buttons.
-		When written, the given buttons are activated/deactivated
-		immediately.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/mode_key
-Date:		Januar 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The keyboard has a condensed layout without num-lock key.
-		Instead it uses a mode-key which activates a gaming mode where
-		the assignment of the number block changes.
-		The integer value of this attribute ranges from 0 (OFF) to 1 (ON).
-		When read, this file returns the actual state of the key.
-		When written, the key is activated/deactivated immediately.
-Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku b/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
deleted file mode 100644
index c601d0f..0000000
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
+++ /dev/null
@@ -1,153 +0,0 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/actual_profile
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The integer value of this attribute ranges from 0-4.
-		When read, this attribute returns the number of the actual
-		profile. This value is persistent, so its equivalent to the
-		profile that's active when the device is powered on next time.
-		When written, this file sets the number of the startup profile
-		and the device activates this profile immediately.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/info
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns general data like firmware version.
-		The data is 6 bytes long.
-		This file is readonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/key_mask
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one deactivate certain keys like
-		windows and application keys, to prevent accidental presses.
-		Profile number for which this settings occur is included in
-		written data. The data has to be 6 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_capslock
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the function of the
-		capslock key for a specific profile. Profile number is included
-		in written data. The data has to be 6 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_easyzone
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the function of the
-		easyzone keys for a specific profile. Profile number is included
-		in written data. The data has to be 65 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_function
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the function of the
-		function keys for a specific profile. Profile number is included
-		in written data. The data has to be 41 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_macro
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the function of the macro
-		keys for a specific profile. Profile number is included in
-		written data. The data has to be 35 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_media
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the function of the media
-		keys for a specific profile. Profile number is included in
-		written data. The data has to be 29 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_thumbster
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the function of the
-		thumbster keys for a specific profile. Profile number is included
-		in written data. The data has to be 23 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/last_set
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the time in secs since
-		epoch in which the last configuration took place.
-		The data has to be 20 bytes long.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/light
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the backlight intensity for
-		a specific profile. Profile number is included in written data.
-		The data has to be 10 bytes long for Isku, IskuFX needs	16 bytes
-		of data.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/macro
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one store macros with max 500
-		keystrokes for a specific button for a specific profile.
-		Button and profile numbers are included in written data.
-		The data has to be 2083 bytes long.
-		Before reading this file, control has to be written to select
-		which profile and key to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/reset
-Date:		November 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one reset the device.
-		The data has to be 3 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/control
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one select which data from which
-		profile will be	read next. The data has to be 3 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/talk
-Date:		June 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one trigger easyshift functionality
-		from the host.
-		The data has to be 16 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/talkfx
-Date:		February 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one trigger temporary color schemes
-		from the host.
-		The data has to be 16 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
deleted file mode 100644
index 7bd776f..0000000
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
+++ /dev/null
@@ -1,96 +0,0 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/actual_profile
-Date:		October 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The integer value of this attribute ranges from 0-4.
-                When read, this attribute returns the number of the actual
-                profile. This value is persistent, so its equivalent to the
-                profile that's active when the mouse is powered on next time.
-		When written, this file sets the number of the startup profile
-		and the mouse activates this profile immediately.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/info
-Date:		November 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns general data like firmware version.
-		When written, the device can be reset.
-		The data is 8 bytes long.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/macro
-Date:		October 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store a macro with max 500 key/button strokes
-		internally.
-		When written, this file lets one set the sequence for a specific
-		button for a specific profile. Button and profile numbers are
-		included in written data. The data has to be 2082 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile_buttons
-Date:		August 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split in settings and buttons.
-		profile_buttons holds information about button layout.
-		When written, this file lets one write the respective profile
-		buttons back to the mouse. The data has to be 77 bytes long.
-		The mouse will reject invalid data.
-		Which profile to write is determined by the profile number
-		contained in the data.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile_settings
-Date:		October 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split in settings and buttons.
-		profile_settings holds information like resolution, sensitivity
-		and light effects.
-		When written, this file lets one write the respective profile
-		settings back to the mouse. The data has to be 43 bytes long.
-		The mouse will reject invalid data.
-		Which profile to write is determined by the profile number
-		contained in the data.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/sensor
-Date:		October 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse has a tracking- and a distance-control-unit. These
-		can be activated/deactivated and the lift-off distance can be
-		set. The data has to be 6 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/talk
-Date:		May 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	Used to active some easy* functions of the mouse from outside.
-		The data has to be 16 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu
-Date:		October 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written a calibration process for the tracking control unit
-		can be initiated/cancelled. Also lets one read/write sensor
-		registers.
-		The data has to be 4 bytes long.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu_image
-Date:		October 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read the mouse returns a 30x30 pixel image of the
-		sampled underground. This works only in the course of a
-		calibration process initiated with tcu.
-		The returned data is 1028 bytes in size.
-		This file is readonly.
-Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-konepure b/Documentation/ABI/testing/sysfs-driver-hid-roccat-konepure
deleted file mode 100644
index 41a9b7f..0000000
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-konepure
+++ /dev/null
@@ -1,105 +0,0 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/actual_profile
-Date:		December 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. actual_profile holds number of actual profile.
-		This value is persistent, so its value determines the profile
-		that's active when the mouse is powered on next time.
-		When written, the mouse activates the set profile immediately.
-		The data has to be 3 bytes long.
-		The mouse will reject invalid data.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/control
-Date:		December 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one select which data from which
-		profile will be	read next. The data has to be 3 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/info
-Date:		December 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns general data like firmware version.
-		When written, the device can be reset.
-		The data is 6 bytes long.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/macro
-Date:		December 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store a macro with max 500 key/button strokes
-		internally.
-		When written, this file lets one set the sequence for a specific
-		button for a specific profile. Button and profile numbers are
-		included in written data. The data has to be 2082 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/profile_buttons
-Date:		December 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split in settings and buttons.
-		profile_buttons holds information about button layout.
-		When written, this file lets one write the respective profile
-		buttons back to the mouse. The data has to be 59 bytes long.
-		The mouse will reject invalid data.
-		Which profile to write is determined by the profile number
-		contained in the data.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/profile_settings
-Date:		December 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split in settings and buttons.
-		profile_settings holds information like resolution, sensitivity
-		and light effects.
-		When written, this file lets one write the respective profile
-		settings back to the mouse. The data has to be 31 bytes long.
-		The mouse will reject invalid data.
-		Which profile to write is determined by the profile number
-		contained in the data.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/sensor
-Date:		December 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse has a tracking- and a distance-control-unit. These
-		can be activated/deactivated and the lift-off distance can be
-		set. The data has to be 6 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/talk
-Date:		December 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	Used to active some easy* functions of the mouse from outside.
-		The data has to be 16 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/tcu
-Date:		December 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written a calibration process for the tracking control unit
-		can be initiated/cancelled. Also lets one read/write sensor
-		registers.
-		The data has to be 4 bytes long.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/tcu_image
-Date:		December 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read the mouse returns a 30x30 pixel image of the
-		sampled underground. This works only in the course of a
-		calibration process initiated with tcu.
-		The returned data is 1028 bytes in size.
-		This file is readonly.
-Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
deleted file mode 100644
index a10404f..0000000
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
+++ /dev/null
@@ -1,49 +0,0 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_profile
-Date:		January 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The integer value of this attribute ranges from 0-4.
-		When read, this attribute returns the number of the active
-		profile.
-		When written, the mouse activates this profile immediately.
-		The profile that's active when powered down is the same that's
-		active when the mouse is powered on.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/info
-Date:		November 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns general data like firmware version.
-		When written, the device can be reset.
-		The data is 6 bytes long.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_buttons
-Date:		January 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split in settings and buttons.
-		profile_buttons holds information about button layout.
-		When written, this file lets one write the respective profile
-		buttons back to the mouse. The data has to be 23 bytes long.
-		The mouse will reject invalid data.
-		Which profile to write is determined by the profile number
-		contained in the data.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_settings
-Date:		January 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split in settings and buttons.
-		profile_settings holds information like resolution, sensitivity
-		and light effects.
-		When written, this file lets one write the respective profile
-		settings back to the mouse. The data has to be 16 bytes long.
-		The mouse will reject invalid data.
-		Which profile to write is determined by the profile number
-		contained in the data.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-lua b/Documentation/ABI/testing/sysfs-driver-hid-roccat-lua
deleted file mode 100644
index 31c6c4c..0000000
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-lua
+++ /dev/null
@@ -1,7 +0,0 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/control
-Date:		October 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, cpi, button and light settings can be configured.
-		When read, actual cpi setting and sensor data are returned.
-		The data has to be 8 bytes long.
-Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
deleted file mode 100644
index 9fa9de3..0000000
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
+++ /dev/null
@@ -1,49 +0,0 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/info
-Date:		November 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns general data like firmware version.
-		When written, the device can be reset.
-		The data is 6 bytes long.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_settings
-Date:		August 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split in settings and buttons.
-		profile_settings holds information like resolution, sensitivity
-		and light effects.
-		When written, this file lets one write the respective profile
-		settings back to the mouse. The data has to be 13 bytes long.
-		The mouse will reject invalid data.
-		Which profile to write is determined by the profile number
-		contained in the data.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_buttons
-Date:		August 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split in settings and buttons.
-		profile_buttons holds information about button layout.
-		When written, this file lets one write the respective profile
-		buttons back to the mouse. The data has to be 19 bytes long.
-		The mouse will reject invalid data.
-		Which profile to write is determined by the profile number
-		contained in the data.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/settings
-Date:		August 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns the settings stored in the mouse.
-		The size of the data is 3 bytes and holds information on the
-		startup_profile.
-		When written, this file lets write settings back to the mouse.
-		The data has to be 3 bytes long. The mouse will reject invalid
-		data.
-Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-ryos b/Documentation/ABI/testing/sysfs-driver-hid-roccat-ryos
deleted file mode 100644
index 1d6a8cf..0000000
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-ryos
+++ /dev/null
@@ -1,178 +0,0 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/control
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one select which data from which
-		profile will be	read next. The data has to be 3 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/profile
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. profile holds index of actual profile.
-		This value is persistent, so its value determines the profile
-		that's active when the device is powered on next time.
-		When written, the device activates the set profile immediately.
-		The data has to be 3 bytes long.
-		The device will reject invalid data.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_primary
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the default of all keys for
-		a specific profile. Profile index is included in written data.
-		The data has to be 125 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_function
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the function of the
-		function keys for a specific profile. Profile index is included
-		in written data. The data has to be 95 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_macro
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the function of the macro
-		keys for a specific profile. Profile index is included in
-		written data. The data has to be 35 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_thumbster
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the function of the
-		thumbster keys for a specific profile. Profile index is included
-		in written data. The data has to be 23 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_extra
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the function of the
-		capslock and function keys for a specific profile. Profile index
-		is included in written data. The data has to be 8 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_easyzone
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the function of the
-		easyzone keys for a specific profile. Profile index is included
-		in written data. The data has to be 294 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/key_mask
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one deactivate certain keys like
-		windows and application keys, to prevent accidental presses.
-		Profile index for which this settings occur is included in
-		written data. The data has to be 6 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/light
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the backlight intensity for
-		a specific profile. Profile index is included in written data.
-		This attribute is only valid for the glow and pro variant.
-		The data has to be 16 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/macro
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one store macros with max 480
-		keystrokes for a specific button for a specific profile.
-		Button and profile indexes are included in written data.
-		The data has to be 2002 bytes long.
-		Before reading this file, control has to be written to select
-		which profile and key to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/info
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns general data like firmware version.
-		The data is 8 bytes long.
-		This file is readonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/reset
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one reset the device.
-		The data has to be 3 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/talk
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one trigger easyshift functionality
-		from the host.
-		The data has to be 16 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/light_control
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one switch between stored and custom
-		light settings.
-		This attribute is only valid for the pro variant.
-		The data has to be 8 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/stored_lights
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set per-key lighting for different
-		layers.
-		This attribute is only valid for the pro variant.
-		The data has to be 1382 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/custom_lights
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set the actual per-key lighting.
-		This attribute is only valid for the pro variant.
-		The data has to be 20 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/light_macro
-Date:		October 2013
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one set a light macro that is looped
-		whenever the device gets in dimness mode.
-		This attribute is only valid for the pro variant.
-		The data has to be 2002 bytes long.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu b/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu
deleted file mode 100644
index f1e02a9..0000000
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu
+++ /dev/null
@@ -1,76 +0,0 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/buttons
-Date:		Mai 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split into general settings and
-		button settings. buttons holds informations about button layout.
-		When written, this file lets one write the respective profile
-		buttons to the mouse. The data has to be 47 bytes long.
-		The mouse will reject invalid data.
-		Which profile to write is determined by the profile number
-		contained in the data.
-		Before reading this file, control has to be written to select
-		which profile to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/control
-Date:		Mai 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one select which data from which
-		profile will be	read next. The data has to be 3 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/general
-Date:		Mai 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split into general settings and
-		button settings. profile holds informations like resolution, sensitivity
-		and light effects.
-		When written, this file lets one write the respective profile
-		settings back to the mouse. The data has to be 43 bytes long.
-		The mouse will reject invalid data.
-		Which profile to write is determined by the profile number
-		contained in the data.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/info
-Date:		Mai 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns general data like firmware version.
-		When written, the device can be reset.
-		The data is 8 bytes long.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/macro
-Date:		Mai 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When written, this file lets one store macros with max 500
-		keystrokes for a specific button for a specific profile.
-		Button and profile numbers are included in written data.
-		The data has to be 2083 bytes long.
-		Before reading this file, control has to be written to select
-		which profile and key to read.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/profile
-Date:		Mai 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. profile holds number of actual profile.
-		This value is persistent, so its value determines the profile
-		that's active when the mouse is powered on next time.
-		When written, the mouse activates the set profile immediately.
-		The data has to be 3 bytes long.
-		The mouse will reject invalid data.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/sensor
-Date:		July 2012
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse has a Avago ADNS-3090 sensor.
-		This file allows reading and writing of the mouse sensors registers.
-		The data has to be 4 bytes long.
-Users:		http://roccat.sourceforge.net
-- 
2.4.3



