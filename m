From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 2/3] ACPICA: Add _PLD front and back panel constants
Date: Mon, 27 Apr 2015 18:01:47 +0300
Message-ID: <1430146908-27919-3-git-send-email-octavian.purdila@intel.com>
References: <1430146908-27919-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430146908-27919-1-git-send-email-octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/acpi/acbuffer.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/acpi/acbuffer.h b/include/acpi/acbuffer.h
index 6b040f4..2be0270 100644
--- a/include/acpi/acbuffer.h
+++ b/include/acpi/acbuffer.h
@@ -139,6 +139,11 @@ struct acpi_pld_info {
 	u16 horizontal_offset;
 };
 
+enum {
+	ACPI_PLD_PANEL_FRONT = 4,
+	ACPI_PLD_PANEL_BACK
+};
+
 /*
  * Macros to:
  *     1) Convert a _PLD buffer to internal struct acpi_pld_info format - ACPI_PLD_GET*
-- 
1.9.1
