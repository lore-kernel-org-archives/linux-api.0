From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 1/5] firmware: Add DMI entry types to the headers
Date: Thu, 17 Feb 2011 13:28:00 -0800
Message-ID: <20110217212800.3967.35961.stgit@mike.mtv.corp.google.com>
References: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110217212754.3967.98648.stgit-tzAwxxnF6Tt6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Olof Johansson <olofj-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Robert Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jon Mayer <jonmayer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Duncan Laurie <dlaurie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Hendrix <dhendrix-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

In preparation for the upcoming commits, introduce the DMI entry types to
the headers.  These type names are based on those specified in the DMTF
SMBIOS specification version 2.7.1.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
