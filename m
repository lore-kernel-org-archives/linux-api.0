From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 04/12] sys-rq: Add option to soft dump
Date: Tue, 02 Nov 2010 18:29:49 -0700
Message-ID: <20101103012948.4641.40943.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101103012917.4641.57113.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

It is very useful to provide some means to force the kernel logs to make it out
via the kmsg_oops implementations on the console.  Add a new option 'Y' to
sysrq to allow dumping of logs to kmsg_dumper drivers.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/char/sysrq.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index ef31bb8..888efc5 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -41,6 +41,7 @@
 #include <linux/oom.h>
 #include <linux/slab.h>
 #include <linux/input.h>
+#include <linux/kmsg_dump.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
@@ -395,6 +396,17 @@ static struct sysrq_key_op sysrq_unrt_op = {
 	.enable_mask	= SYSRQ_ENABLE_RTNICE,
 };
 
+static void sysrq_handle_softdump(int key)
+{
+	kmsg_dump(KMSG_DUMP_SOFT, NULL);
+}
+static struct sysrq_key_op sysrq_softdump_op = {
+	.handler	= sysrq_handle_softdump,
+	.help_msg	= "soft-dump(Y)",
+	.action_msg	= "Trigger a soft dump",
+	.enable_mask	= SYSRQ_ENABLE_DUMP,
+};
+
 /* Key Operations table and lock */
 static DEFINE_SPINLOCK(sysrq_key_table_lock);
 
@@ -451,7 +463,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
 	/* x: May be registered on ppc/powerpc for xmon */
 	NULL,				/* x */
 	/* y: May be registered on sparc64 for global register dump */
-	NULL,				/* y */
+	&sysrq_softdump_op,		/* y */
 	&sysrq_ftrace_dump_op,		/* z */
 };
 
