From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 90/98] include/uapi/linux/coda.h: use __kernel_pid_t and add u_short etc definitions for userspace
Date: Sat, 30 May 2015 17:39:22 +0200
Message-ID: <1433000370-19509-91-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Jan Harkes <jaharkes-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org>, coda-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org, codalist-/uMB558Y47wP4a1z8dhFYw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation errors about unknown pid_t, u_short etc types.

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/coda.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/coda.h b/include/uapi/linux/coda.h
index 695fade..591bb42 100644
--- a/include/uapi/linux/coda.h
+++ b/include/uapi/linux/coda.h
@@ -100,7 +100,14 @@ typedef unsigned long long u_quad_t;
 #if defined(__linux__)
 #include <linux/time.h>
 #define cdev_t u_quad_t
+typedef unsigned long u_long;
+typedef unsigned int u_int;
+typedef unsigned short u_short;
+typedef u_long ino_t;
+
 #ifndef __KERNEL__
+typedef u_long dev_t;
+typedef void * caddr_t;
 #if !defined(_UQUAD_T_) && (!defined(__GLIBC__) || __GLIBC__ < 2)
 #define _UQUAD_T_ 1
 typedef unsigned long long u_quad_t;
@@ -295,8 +302,8 @@ struct coda_statfs {
 struct coda_in_hdr {
     u_int32_t opcode;
     u_int32_t unique;	    /* Keep multiple outstanding msgs distinct */
-    pid_t pid;
-    pid_t pgid;
+    __kernel_pid_t pid;
+    __kernel_pid_t pgid;
     vuid_t uid;
 };
 
-- 
2.1.4
