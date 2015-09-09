From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 09/13] Hide bp_type_idx behind #ifdef __KERNEL__
Date: Wed,  9 Sep 2015 14:08:18 -0700
Message-ID: <1441832902-28993-10-git-send-email-palmer@dabbelt.com>
References: <2644177.lVCYzIBfPW@wuerfel>
 <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
Sender: linux-arch-owner@vger.kernel.org
To: arnd@arndb.de
Cc: 3chas3@gmail.com, hpa@zytor.com, mingo@redhat.com, plagnioj@jcrosoft.com, jikos@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-atm-general@lists.sourceforge.net, linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tglx@linutronix.de, tomi.valkeinen@ti.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
List-Id: linux-api@vger.kernel.org

I'm actually not sure what to do here: if this enum is meant to be
used by userspace, then it has to be the same regardless of kernel
configuration.  One option would be to have the kernel expose all the
values to userspace and then map them internally if
CONFIG_HAVE_MIXED_BREAKPOINT_REGS isn't set, but that feels like it'd
be more invasive.

Here I took the simple and fail-fast route to hide all the
definitions.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
---
 include/uapi/linux/hw_breakpoint.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/hw_breakpoint.h b/include/uapi/linux/hw_breakpoint.h
index b04000a2296a..2498bfbf56c4 100644
--- a/include/uapi/linux/hw_breakpoint.h
+++ b/include/uapi/linux/hw_breakpoint.h
@@ -17,14 +17,16 @@ enum {
 	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
 };
 
+#ifdef __KERNEL__
 enum bp_type_idx {
 	TYPE_INST 	= 0,
-#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
+#if defined(CONFIG_HAVE_MIXED_BREAKPOINTS_REGS)
 	TYPE_DATA	= 0,
 #else
 	TYPE_DATA	= 1,
 #endif
 	TYPE_MAX
 };
+#endif /* __KERNEL__ */
 
 #endif /* _UAPI_LINUX_HW_BREAKPOINT_H */
-- 
2.4.6
