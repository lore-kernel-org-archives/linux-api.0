From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 19/98] dm-log-userspace.h: use __u32, __s32 and __u64 from linux/types.h
Date: Sat, 30 May 2015 17:38:11 +0200
Message-ID: <1433000370-19509-20-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

linux/dm-log-userspace.h:416:2: error: unknown type name =E2=80=98uint6=
4_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/dm-log-userspace.h | 43 ++++++++++++++++++---------=
--------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/include/uapi/linux/dm-log-userspace.h b/include/uapi/linux=
/dm-log-userspace.h
index 0fa0d9e..c5ff216 100644
--- a/include/uapi/linux/dm-log-userspace.h
+++ b/include/uapi/linux/dm-log-userspace.h
@@ -7,6 +7,7 @@
 #ifndef __DM_LOG_USERSPACE_H__
 #define __DM_LOG_USERSPACE_H__
=20
+#include <linux/types.h>
 #include <linux/dm-ioctl.h> /* For DM_UUID_LEN */
=20
 /*
@@ -147,12 +148,12 @@
=20
 /*
  * DM_ULOG_GET_REGION_SIZE corresponds to (found in dm-dirty-log.h):
- * uint32_t (*get_region_size)(struct dm_dirty_log *log);
+ * __u32 (*get_region_size)(struct dm_dirty_log *log);
  *
  * Payload-to-userspace:
  *	None.
  * Payload-to-kernel:
- *	uint64_t - contains the region size
+ *	__u64 - contains the region size
  *
  * The region size is something that was determined at constructor tim=
e.
  * It is returned in the payload area and 'data_size' is set to
@@ -168,11 +169,11 @@
  * int (*is_clean)(struct dm_dirty_log *log, region_t region);
  *
  * Payload-to-userspace:
- *	uint64_t - the region to get clean status on
+ *	__u64 - the region to get clean status on
  * Payload-to-kernel:
  *	int64_t  - 1 if clean, 0 otherwise
  *
- * Payload is sizeof(uint64_t) and contains the region for which the c=
lean
+ * Payload is sizeof(__u64) and contains the region for which the clea=
n
  * status is being made.
  *
  * When the request has been processed, user-space must return the
@@ -187,7 +188,7 @@
  *		  int can_block);
  *
  * Payload-to-userspace:
- *	uint64_t - the region to get sync status on
+ *	__u64 - the region to get sync status on
  * Payload-to-kernel:
  *	int64_t - 1 if in-sync, 0 otherwise
  *
@@ -203,7 +204,7 @@
  * Payload-to-userspace:
  *	If the 'integrated_flush' directive is present in the constructor
  *	table, the payload is as same as DM_ULOG_MARK_REGION:
- *		uint64_t [] - region(s) to mark
+ *		__u64 [] - region(s) to mark
  *	else
  *		None
  * Payload-to-kernel:
@@ -225,13 +226,13 @@
  * void (*mark_region)(struct dm_dirty_log *log, region_t region);
  *
  * Payload-to-userspace:
- *	uint64_t [] - region(s) to mark
+ *	__u64 [] - region(s) to mark
  * Payload-to-kernel:
  *	None.
  *
  * Incoming payload contains the one or more regions to mark dirty.
  * The number of regions contained in the payload can be determined fr=
om
- * 'data_size/sizeof(uint64_t)'.
+ * 'data_size/sizeof(__u64)'.
  *
  * When the request has been processed, user-space must return the
  * dm_ulog_request to the kernel - setting the 'error' field and clear=
ing
@@ -244,13 +245,13 @@
  * void (*clear_region)(struct dm_dirty_log *log, region_t region);
  *
  * Payload-to-userspace:
- *	uint64_t [] - region(s) to clear
+ *	__u64 [] - region(s) to clear
  * Payload-to-kernel:
  *	None.
  *
  * Incoming payload contains the one or more regions to mark clean.
  * The number of regions contained in the payload can be determined fr=
om
- * 'data_size/sizeof(uint64_t)'.
+ * 'data_size/sizeof(__u64)'.
  *
  * When the request has been processed, user-space must return the
  * dm_ulog_request to the kernel - setting the 'error' field and clear=
ing
@@ -267,7 +268,7 @@
  * Payload-to-kernel:
  *	{
  *		int64_t i; -- 1 if recovery necessary, 0 otherwise
- *		uint64_t r; -- The region to recover if i=3D1
+ *		__u64 r; -- The region to recover if i=3D1
  *	}
  * 'data_size' should be set appropriately.
  *
@@ -283,7 +284,7 @@
  *
  * Payload-to-userspace:
  *	{
- *		uint64_t - region to set sync state on
+ *		__u64 - region to set sync state on
  *		int64_t  - 0 if not-in-sync, 1 if in-sync
  *	}
  * Payload-to-kernel:
@@ -302,7 +303,7 @@
  * Payload-to-userspace:
  *	None.
  * Payload-to-kernel:
- *	uint64_t - the number of in-sync regions
+ *	__u64 - the number of in-sync regions
  *
  * No incoming payload.  Kernel-bound payload contains the number of
  * regions that are in-sync (in a size_t).
@@ -350,11 +351,11 @@
  * int (*is_remote_recovering)(struct dm_dirty_log *log, region_t regi=
on);
  *
  * Payload-to-userspace:
- *	uint64_t - region to determine recovery status on
+ *	__u64 - region to determine recovery status on
  * Payload-to-kernel:
  *	{
  *		int64_t is_recovering;  -- 0 if no, 1 if yes
- *		uint64_t in_sync_hint;  -- lowest region still needing resync
+ *		__u64 in_sync_hint;  -- lowest region still needing resync
  *	}
  *
  * When the request has been processed, user-space must return the
@@ -413,16 +414,16 @@ struct dm_ulog_request {
 	 * differentiate between logs that are being swapped and have the
 	 * same 'uuid'.  (Think "live" and "inactive" device-mapper tables.)
 	 */
-	uint64_t luid;
+	__u64 luid;
 	char uuid[DM_UUID_LEN];
 	char padding[3];        /* Padding because DM_UUID_LEN =3D 129 */
=20
-	uint32_t version;       /* See DM_ULOG_REQUEST_VERSION */
-	int32_t error;          /* Used to report back processing errors */
+	__u32 version;       /* See DM_ULOG_REQUEST_VERSION */
+	__s32 error;          /* Used to report back processing errors */
=20
-	uint32_t seq;           /* Sequence number for request */
-	uint32_t request_type;  /* DM_ULOG_* defined above */
-	uint32_t data_size;     /* How much data (not including this struct) =
*/
+	__u32 seq;           /* Sequence number for request */
+	__u32 request_type;  /* DM_ULOG_* defined above */
+	__u32 data_size;     /* How much data (not including this struct) */
=20
 	char data[0];
 };
--=20
2.1.4
