From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 5/5] firmware: Add documentation for /sys/firmware/dmi
Date: Thu, 17 Feb 2011 13:28:21 -0800
Message-ID: <20110217212821.3967.22439.stgit@mike.mtv.corp.google.com>
References: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>, Olof Johansson <olofj@chromium.org>, Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Lippert <rlippert@google.com>
Cc: Jon Mayer <jonmayer@google.com>, Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>, David Hendrix <dhendrix@chromium.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Document the new ABI added by the dmi-sysfs module.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 Documentation/ABI/testing/sysfs-firmware-dmi |  101 ++++++++++++++++++++++++++
 1 files changed, 101 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-dmi

diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Documentation/ABI/testing/sysfs-firmware-dmi
new file mode 100644
index 0000000..c6526b0
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-dmi
@@ -0,0 +1,101 @@
+What:		/sys/firmware/dmi/
+Date:		February 2011
+Contact:	Mike Waychison <mikew@google.com>
+Description:
+		Many machine's firmware (x86 and ia64) export DMI /
+		SMBIOS tables to the operating system.  Getting at this
+		information is often valuable to userland, especially in
+		cases where there are OEM extensions used.
+
+		The kernel itself does not rely on the majority of the
+		information in these tables being correct.  It equally
+		cannot ensure that the data as exported to userland is
+		without error either.
+
+		DMI is structured as a large table of entries, where
+		each entry has a common header indicating the type and
+		length of the entry, as well as 'handle' that is
+		supposed to be unique amongst all entries.
+
+		Some entries are required by the specification, but many
+		others are optional.  In general though, user's should
+		never expect to find a specific entry type on their
+		system unless they know for certain what their firmware
+		is doing.  Machine to machine will vary.
+
+		Multiple entries of the same type are allowed.  In order
+		to handle these duplicate entry types, each entry is
+		assigned by the operating system an 'instance', which is
+		derived from an entry type's ordinal position.  That is
+		to say, if there are 'N' multiple entries with the same type
+		'T' in the DMI tables (adjacent or spread apart, it
+		doesn't matter), they will be represented in sysfs as
+		entries "T-0" through "T-(N-1)":
+
+		Example entry directories:
+
+			/sys/firmware/dmi/entries/17-0
+			/sys/firmware/dmi/entries/17-1
+			/sys/firmware/dmi/entries/17-2
+			/sys/firmware/dmi/entries/17-3
+			...
+
+		Instance numbers are used in lieu of the firmware
+		assigned entry handles as there is kernel itself makes
+		no guarantees that handles as exported are unique, and
+		there are likely firmware images that get this wrong in
+		the wild.
+
+		Each DMI entry in sysfs has the common header values
+		exported as attributes:
+
+		handle	: The 16bit 'handle' that is assigned to this
+			  entry by the firmware.  This handle may be
+			  referred to by other entries.
+		length	: The length of the entry, as presented in the
+			  entry itself.  Note that this is _not the
+			  total count of bytes associated with the
+			  entry_.  This value represents the length of
+			  the "formatted" portion of the entry.  This
+			  "formatted" region is sometimes followed by
+			  the "unformatted" region composed of nul
+			  terminated strings, with termination signalled
+			  by a two nul characters in series.
+		raw	: The raw bytes of the entry. This includes the
+			  "formatted" portion of the entry, the
+			  "unformatted" strings portion of the entry,
+			  and the two terminating nul characters.
+
+		=== Entry Specialization ===
+
+		Some entry types may have other information available in
+		sysfs.
+
+		--- Type 15 - System Event Log ---
+
+		This entry allows the firmware to export a log of
+		events the system has taken.  This information is
+		typically backed by nvram, but the implementation
+		details are abstracted by this table.  This entries data
+		is exported in the directory:
+
+		/sys/firmware/dmi/entries/15-0/system_event_log
+
+		and has the following attributes (documented in the
+		SMBIOS / DMI specification under "System Event Log (Type 15)":
+
+		area_length
+		header_start_offset
+		data_start_offset
+		access_method
+		status
+		change_token
+		access_method_address
+		header_format
+		per_log_type_descriptor_length
+		type_descriptors_supported_count
+
+		As well, the kernel exports the binary attribute:
+
+		raw_event_log	: The raw binary bits of the event log
+				  as described by the DMI entry.
