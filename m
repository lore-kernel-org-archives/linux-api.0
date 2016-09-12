From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: [PATCH] x86/pkeys: fix pkeys build breakage for some non-x86 arches
Date: Mon, 12 Sep 2016 13:38:42 -0700
Message-ID: <20160912203842.48E7AC50@viggo.jf.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Guenter Roeck reported [1] breakage on the h8300 and c6x
architectures (among others) caused by the new memory protection
keys syscalls.  This patch does what Arnd suggested and adds them
to kernel/sys_ni.c.

1. http://marc.info/?l=linux-kernel&m=147369214820072&w=2

Signed-off-by: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Tested-by: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Acked-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

 b/kernel/sys_ni.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/sys_ni.c~fix-pkeys-arch-breakage kernel/sys_ni.c
--- a/kernel/sys_ni.c~fix-pkeys-arch-breakage	2016-09-12 13:35:17.449066541 -0700
+++ b/kernel/sys_ni.c	2016-09-12 13:35:17.452066676 -0700
@@ -250,3 +250,8 @@ cond_syscall(sys_execveat);
 
 /* membarrier */
 cond_syscall(sys_membarrier);
+
+/* memory protection keys */
+cond_syscall(sys_pkey_mprotect);
+cond_syscall(sys_pkey_alloc);
+cond_syscall(sys_pkey_free);
_
