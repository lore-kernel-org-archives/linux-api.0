From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 96/98] HACK include/uapi/linux/coda_psdev.h: fix compilation in userspace
Date: Sat, 30 May 2015 17:39:28 +0200
Message-ID: <1433000370-19509-97-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Jan Harkes <jaharkes-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org>, coda-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org, codalist-/uMB558Y47wP4a1z8dhFYw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Include linux/coda.h for caddr_t and use unsigned short type directly.
Userspace headers do not have list_head and wait_queue_head_t so just
ifdef them away which is a HACK. Any ideas how to fix this properly?

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/coda_psdev.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/coda_psdev.h b/include/uapi/linux/coda_psdev.h
index 79d0598..50e49f8 100644
--- a/include/uapi/linux/coda_psdev.h
+++ b/include/uapi/linux/coda_psdev.h
@@ -2,6 +2,7 @@
 #define _UAPI__CODA_PSDEV_H
 
 #include <linux/magic.h>
+#include <linux/coda.h>
 
 #define CODA_PSDEV_MAJOR 67
 #define MAX_CODADEVS  5	   /* how many do we allow */
@@ -9,14 +10,18 @@
 
 /* messages between coda filesystem in kernel and Venus */
 struct upc_req {
+#ifdef __KERNEL__
 	struct list_head    uc_chain;
+#endif /* __KERNEL__ */
 	caddr_t	            uc_data;
-	u_short	            uc_flags;
-	u_short             uc_inSize;  /* Size is at most 5000 bytes */
-	u_short	            uc_outSize;
-	u_short	            uc_opcode;  /* copied from data to save lookup */
+	unsigned short      uc_flags;
+	unsigned short      uc_inSize;  /* Size is at most 5000 bytes */
+	unsigned short	    uc_outSize;
+	unsigned short      uc_opcode;  /* copied from data to save lookup */
 	int		    uc_unique;
+#ifdef __KERNEL__
 	wait_queue_head_t   uc_sleep;   /* process' wait queue */
+#endif /* __KERNEL__ */
 };
 
 #define CODA_REQ_ASYNC  0x1
-- 
2.1.4
