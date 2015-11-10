From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 09/14] Move bp_type_idx to include/linux/hw_breakpoint.h
Date: Mon,  9 Nov 2015 17:31:06 -0800
Message-ID: <1447119071-19392-10-git-send-email-palmer__26526.9461124719$1447119158$gmane$org@dabbelt.com>
References: <1446579994-9937-1-git-send-email-palmer@dabbelt.com>
 <1447119071-19392-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447119071-19392-1-git-send-email-palmer@dabbelt.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, dhowells@redhat.com, peterz@infradead.org
Cc: viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
List-Id: linux-api@vger.kernel.org

This has a "#ifdef CONFIG_*" that used to be exposed to userspace.

The names in here are so generic that I don't think it's a good idea
to expose them to userspace (or even the rest of the kernel).  There are
multiple in-kernel users, so it's been moved to a kernel header file.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
---
 include/linux/hw_breakpoint.h      | 10 ++++++++++
 include/uapi/linux/hw_breakpoint.h | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 0464c85..dfe0376 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -6,6 +6,16 @@
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
+enum bp_type_idx {
+	TYPE_INST	= 0,
+#if defined(CONFIG_HAVE_MIXED_BREAKPOINTS_REGS)
+	TYPE_DATA	= 0,
+#else
+	TYPE_DATA	= 1,
+#endif
+	TYPE_MAX
+};
+
 extern int __init init_hw_breakpoint(void);
 
 static inline void hw_breakpoint_init(struct perf_event_attr *attr)
diff --git a/include/uapi/linux/hw_breakpoint.h b/include/uapi/linux/hw_breakpoint.h
index b04000a..7a6a5a7 100644
--- a/include/uapi/linux/hw_breakpoint.h
+++ b/include/uapi/linux/hw_breakpoint.h
@@ -17,14 +17,4 @@ enum {
 	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
 };
 
-enum bp_type_idx {
-	TYPE_INST 	= 0,
-#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
-	TYPE_DATA	= 0,
-#else
-	TYPE_DATA	= 1,
-#endif
-	TYPE_MAX
-};
-
 #endif /* _UAPI_LINUX_HW_BREAKPOINT_H */
-- 
2.4.10
