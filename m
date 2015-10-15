From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 66/79] include/uapi/linux/coda.h: use __kernel_pid_t and add u_short etc definitions for userspace
Date: Thu, 15 Oct 2015 07:56:44 +0200
Message-ID: <1444888618-4506-67-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, codalist@coda.cs.cmu.edu, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation errors about unknown pid_t, u_short etc types.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
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
2.5.0
