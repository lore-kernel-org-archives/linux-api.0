From: Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH] HID: roccat: Fixed resubmit: Deprecating most Roccat sysfs
 attributes
Date: Sat, 17 Oct 2015 15:10:28 +0200
Message-ID: <1445087428.2322.10.camel@neuromancer.tessier-ashpool>
References: <1444921209.2900.17.camel@neuromancer.tessier-ashpool>
	 <20151015184944.GA1226@kroah.com>
Reply-To: erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151015184944.GA1226-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jkosina-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Deprecates all Roccat sysfs attributes except the ones for the old Kone by moving
abi descriptions from testing to obsolete.
For most devices everything can be done using the hidraw ioctls HIDIOCGFEATURE
and HIDIOCSFEATURE, so I would suggest future removal of device specific drivers.
The userspace tools don't use these attributes for a year now.
The first Kone is not fully HID-compliant and will still need a module.

Fix: Resubmitting this patch, now done with 'git format-patch -M' like Greg KH suggested.

Signed-off-by: Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 .../sysfs-driver-hid-roccat-arvo                   |  0
 .../sysfs-driver-hid-roccat-isku                   |  0
 .../ABI/obsolete/sysfs-driver-hid-roccat-koneplus  | 99 +++++++++++++++++++++-
 .../sysfs-driver-hid-roccat-konepure               |  0
 .../ABI/obsolete/sysfs-driver-hid-roccat-kovaplus  | 50 +++++++++++
 .../sysfs-driver-hid-roccat-lua                    |  0
 .../ABI/obsolete/sysfs-driver-hid-roccat-pyra      | 50 +++++++++++
 .../sysfs-driver-hid-roccat-ryos                   |  0
 .../sysfs-driver-hid-roccat-savu                   |  0
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   | 96 ---------------------
 .../ABI/testing/sysfs-driver-hid-roccat-kovaplus   | 49 -----------
 .../ABI/testing/sysfs-driver-hid-roccat-pyra       | 49 -----------
 12 files changed, 198 insertions(+), 195 deletions(-)
 rename Documentation/ABI/{testing => obsolete}/sysfs-driver-hid-roccat-arvo (100%)
 rename Documentation/ABI/{testing => obsolete}/sysfs-driver-hid-roccat-isku (100%)
 rename Documentation/ABI/{testing => obsolete}/sysfs-driver-hid-roccat-konepure (100%)
 rename Documentation/ABI/{testing => obsolete}/sysfs-driver-hid-roccat-lua (100%)
 rename Documentation/ABI/{testing => obsolete}/sysfs-driver-hid-roccat-ryos (100%)
 rename Documentation/ABI/{testing => obsolete}/sysfs-driver-hid-roccat-savu (100%)
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-arvo
similarity index 100%
rename from Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo
rename to Documentation/ABI/obsolete/sysfs-driver-hid-roccat-arvo
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-isku
similarity index 100%
rename from Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
rename to Documentation/ABI/obsolete/sysfs-driver-hid-roccat-isku
diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus
index 833fd59..545e69f 100644
--- a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus
@@ -1,3 +1,14 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/actual_profile
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
 Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
@@ -22,6 +33,40 @@ Description:	When read, this file returns the raw integer version number of the
 		Please read binary attribute info which contains firmware version.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/info
+Date:		November 2012
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
+		The data is 8 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/macro
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
 Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
@@ -34,6 +79,22 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Write control to select profile and read profile_buttons instead.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile_settings
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
 Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+Description:	The mouse has a tracking- and a distance-control-unit. These
+		can be activated/deactivated and the lift-off distance can be
+		set. The data has to be 6 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/talk
+Date:		May 2011
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+Description:	Used to active some easy* functions of the mouse from outside.
+		The data has to be 16 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+Description:	When written a calibration process for the tracking control unit
+		can be initiated/cancelled. Also lets one read/write sensor
+		registers.
+		The data has to be 4 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu_image
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+Description:	When read the mouse returns a 30x30 pixel image of the
+		sampled underground. This works only in the course of a
+		calibration process initiated with tcu.
+		The returned data is 1028 bytes in size.
+		This file is readonly.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-konepure b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-konepure
similarity index 100%
rename from Documentation/ABI/testing/sysfs-driver-hid-roccat-konepure
rename to Documentation/ABI/obsolete/sysfs-driver-hid-roccat-konepure
diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus
index 4a98e02..ab01631 100644
--- a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus
@@ -8,6 +8,17 @@ Description:	The integer value of this attribute ranges from 1-4.
 		Has never been used. If bookkeeping is done, it's done in userland tools.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_profile
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
 Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
@@ -40,6 +51,29 @@ Description:	When read, this file returns the raw integer version number of the
 		Obsoleted by binary sysfs attribute "info".
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/info
+Date:		November 2012
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
+		The data is 6 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_buttons
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
 Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
@@ -52,6 +86,22 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Write control to select profile and read profile_buttons instead.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_settings
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
 Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-lua b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-lua
similarity index 100%
rename from Documentation/ABI/testing/sysfs-driver-hid-roccat-lua
rename to Documentation/ABI/obsolete/sysfs-driver-hid-roccat-lua
diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
index 87ac87e..16020b3 100644
--- a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
@@ -37,6 +37,29 @@ Description:	When read, this file returns the raw integer version number of the
 		Please use binary attribute "info" which provides this information.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/info
+Date:		November 2012
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
+		The data is 6 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_buttons
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
 Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
@@ -49,6 +72,22 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Write control to select profile and read profile_buttons instead.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_settings
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
 Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
@@ -62,6 +101,17 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Write control to select profile and read profile_settings instead.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/settings
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
 Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-ryos b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-ryos
similarity index 100%
rename from Documentation/ABI/testing/sysfs-driver-hid-roccat-ryos
rename to Documentation/ABI/obsolete/sysfs-driver-hid-roccat-ryos
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-savu
similarity index 100%
rename from Documentation/ABI/testing/sysfs-driver-hid-roccat-savu
rename to Documentation/ABI/obsolete/sysfs-driver-hid-roccat-savu
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
deleted file mode 100644
index 7bd776f..0000000
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
+++ /dev/null
@@ -1,96 +0,0 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/actual_profile
-Date:		October 2010
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
-Description:	When read, this file returns general data like firmware version.
-		When written, the device can be reset.
-		The data is 8 bytes long.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/macro
-Date:		October 2010
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
-Description:	The mouse has a tracking- and a distance-control-unit. These
-		can be activated/deactivated and the lift-off distance can be
-		set. The data has to be 6 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/talk
-Date:		May 2011
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
-Description:	Used to active some easy* functions of the mouse from outside.
-		The data has to be 16 bytes long.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu
-Date:		October 2010
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
-Description:	When written a calibration process for the tracking control unit
-		can be initiated/cancelled. Also lets one read/write sensor
-		registers.
-		The data has to be 4 bytes long.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu_image
-Date:		October 2010
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
-Description:	When read, this file returns general data like firmware version.
-		When written, the device can be reset.
-		The data is 6 bytes long.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_buttons
-Date:		January 2011
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
deleted file mode 100644
index 9fa9de3..0000000
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
+++ /dev/null
@@ -1,49 +0,0 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/info
-Date:		November 2012
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
-Description:	When read, this file returns general data like firmware version.
-		When written, the device can be reset.
-		The data is 6 bytes long.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_settings
-Date:		August 2010
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
-Contact:	Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
-Description:	When read, this file returns the settings stored in the mouse.
-		The size of the data is 3 bytes and holds information on the
-		startup_profile.
-		When written, this file lets write settings back to the mouse.
-		The data has to be 3 bytes long. The mouse will reject invalid
-		data.
-Users:		http://roccat.sourceforge.net
-- 
2.4.3
