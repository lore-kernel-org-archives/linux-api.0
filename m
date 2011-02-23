From: Mike Waychison <mikew@google.com>
Subject: [PATCH v2 1/5] firmware: Add DMI entry types to the headers
Date: Tue, 22 Feb 2011 17:53:15 -0800
Message-ID: <20110223015315.13068.7213.stgit@mike.mtv.corp.google.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>, Olof Johansson <olofj@chromium.org>, Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Lippert <rlippert@google.com>
Cc: Jon Mayer <jonmayer@google.com>, Tony Luck <tony.luck@intel.com>, Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>, David Hendrix <dhendrix@chromium.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

In preparation for the upcoming commits, introduce the DMI entry types to
the headers.  These type names are based on those specified in the DMTF
SMBIOS specification version 2.7.1.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 include/linux/dmi.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index 90e087f..f156cca 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -23,6 +23,53 @@ enum dmi_device_type {
 	DMI_DEV_TYPE_DEV_ONBOARD = -3,
 };
 
+enum dmi_entry_type {
+	DMI_ENTRY_BIOS = 0,
+	DMI_ENTRY_SYSTEM,
+	DMI_ENTRY_BASEBOARD,
+	DMI_ENTRY_CHASSIS,
+	DMI_ENTRY_PROCESSOR,
+	DMI_ENTRY_MEM_CONTROLLER,
+	DMI_ENTRY_MEM_MODULE,
+	DMI_ENTRY_CACHE,
+	DMI_ENTRY_PORT_CONNECTOR,
+	DMI_ENTRY_SYSTEM_SLOT,
+	DMI_ENTRY_ONBOARD_DEVICE,
+	DMI_ENTRY_OEMSTRINGS,
+	DMI_ENTRY_SYSCONF,
+	DMI_ENTRY_BIOS_LANG,
+	DMI_ENTRY_GROUP_ASSOC,
+	DMI_ENTRY_SYSTEM_EVENT_LOG,
+	DMI_ENTRY_PHYS_MEM_ARRAY,
+	DMI_ENTRY_MEM_DEVICE,
+	DMI_ENTRY_32_MEM_ERROR,
+	DMI_ENTRY_MEM_ARRAY_MAPPED_ADDR,
+	DMI_ENTRY_MEM_DEV_MAPPED_ADDR,
+	DMI_ENTRY_BUILTIN_POINTING_DEV,
+	DMI_ENTRY_PORTABLE_BATTERY,
+	DMI_ENTRY_SYSTEM_RESET,
+	DMI_ENTRY_HW_SECURITY,
+	DMI_ENTRY_SYSTEM_POWER_CONTROLS,
+	DMI_ENTRY_VOLTAGE_PROBE,
+	DMI_ENTRY_COOLING_DEV,
+	DMI_ENTRY_TEMP_PROBE,
+	DMI_ENTRY_ELECTRICAL_CURRENT_PROBE,
+	DMI_ENTRY_OOB_REMOTE_ACCESS,
+	DMI_ENTRY_BIS_ENTRY,
+	DMI_ENTRY_SYSTEM_BOOT,
+	DMI_ENTRY_MGMT_DEV,
+	DMI_ENTRY_MGMT_DEV_COMPONENT,
+	DMI_ENTRY_MGMT_DEV_THRES,
+	DMI_ENTRY_MEM_CHANNEL,
+	DMI_ENTRY_IPMI_DEV,
+	DMI_ENTRY_SYS_POWER_SUPPLY,
+	DMI_ENTRY_ADDITIONAL,
+	DMI_ENTRY_ONBOARD_DEV_EXT,
+	DMI_ENTRY_MGMT_CONTROLLER_HOST,
+	DMI_ENTRY_INACTIVE = 126,
+	DMI_ENTRY_END_OF_TABLE = 127,
+};
+
 struct dmi_header {
 	u8 type;
 	u8 length;
