From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/11] UAPI: ndctl: Fix g++-unsupported initialisation in
 headers [ver #2]
Date: Thu, 06 Sep 2018 10:19:24 +0100
Message-ID: <153622556444.14298.5971956747198405225.stgit@warthog.procyon.org.uk>
References: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <153622549721.14298.8116794954073122489.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

The following code in the linux/ndctl header file:

	static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
	{
		static const char * const names[] = {
			[ND_CMD_ARS_CAP] = "ars_cap",
			[ND_CMD_ARS_START] = "ars_start",
			[ND_CMD_ARS_STATUS] = "ars_status",
			[ND_CMD_CLEAR_ERROR] = "clear_error",
			[ND_CMD_CALL] = "cmd_call",
		};

		if (cmd < ARRAY_SIZE(names) && names[cmd])
			return names[cmd];
		return "unknown";
	}

is broken in a number of ways:

 (1) ARRAY_SIZE() is not generally defined.

 (2) g++ does not support "non-trivial" array initialisers fully yet.

 (3) Every file that calls this function will acquire a copy of names[].

The same goes for nvdimm_cmd_name().

Fix all three by converting to a switch statement where each case returns a
string.  That way if cmd is a constant, the compiler can trivially reduce it
and, if not, the compiler can use a shared lookup table if it thinks that is
more efficient.

A better way would be to remove these functions and their arrays from the
header entirely.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
---

 include/uapi/linux/ndctl.h |   48 +++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 7e27070b9440..2f2c43d633c5 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -128,37 +128,31 @@ enum {
 
 static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
 {
-	static const char * const names[] = {
-		[ND_CMD_ARS_CAP] = "ars_cap",
-		[ND_CMD_ARS_START] = "ars_start",
-		[ND_CMD_ARS_STATUS] = "ars_status",
-		[ND_CMD_CLEAR_ERROR] = "clear_error",
-		[ND_CMD_CALL] = "cmd_call",
-	};
-
-	if (cmd < ARRAY_SIZE(names) && names[cmd])
-		return names[cmd];
-	return "unknown";
+	switch (cmd) {
+	case ND_CMD_ARS_CAP:		return "ars_cap";
+	case ND_CMD_ARS_START:		return "ars_start";
+	case ND_CMD_ARS_STATUS:		return "ars_status";
+	case ND_CMD_CLEAR_ERROR:	return "clear_error";
+	case ND_CMD_CALL:		return "cmd_call";
+	default:			return "unknown";
+	}
 }
 
 static inline const char *nvdimm_cmd_name(unsigned cmd)
 {
-	static const char * const names[] = {
-		[ND_CMD_SMART] = "smart",
-		[ND_CMD_SMART_THRESHOLD] = "smart_thresh",
-		[ND_CMD_DIMM_FLAGS] = "flags",
-		[ND_CMD_GET_CONFIG_SIZE] = "get_size",
-		[ND_CMD_GET_CONFIG_DATA] = "get_data",
-		[ND_CMD_SET_CONFIG_DATA] = "set_data",
-		[ND_CMD_VENDOR_EFFECT_LOG_SIZE] = "effect_size",
-		[ND_CMD_VENDOR_EFFECT_LOG] = "effect_log",
-		[ND_CMD_VENDOR] = "vendor",
-		[ND_CMD_CALL] = "cmd_call",
-	};
-
-	if (cmd < ARRAY_SIZE(names) && names[cmd])
-		return names[cmd];
-	return "unknown";
+	switch (cmd) {
+	case ND_CMD_SMART:			return "smart";
+	case ND_CMD_SMART_THRESHOLD:		return "smart_thresh";
+	case ND_CMD_DIMM_FLAGS:			return "flags";
+	case ND_CMD_GET_CONFIG_SIZE:		return "get_size";
+	case ND_CMD_GET_CONFIG_DATA:		return "get_data";
+	case ND_CMD_SET_CONFIG_DATA:		return "set_data";
+	case ND_CMD_VENDOR_EFFECT_LOG_SIZE:	return "effect_size";
+	case ND_CMD_VENDOR_EFFECT_LOG:		return "effect_log";
+	case ND_CMD_VENDOR:			return "vendor";
+	case ND_CMD_CALL:			return "cmd_call";
+	default:				return "unknown";
+	}
 }
 
 #define ND_IOCTL 'N'
