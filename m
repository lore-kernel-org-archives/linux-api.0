From: Mike Waychison <mikew@google.com>
Subject: [PATCH v2 23/23] netoops: Add an interface to trigger various types
	of crashes.
Date: Mon, 08 Nov 2010 12:33:53 -0800
Message-ID: <20101108203352.22479.15302.stgit@crlf.mtv.corp.google.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com, Matt Mackall <mpm@selenic.com>
Cc: adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com, Greg KH <greg@kroah.com>, =?utf-8?q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

It is very useful to be able to test the crash path, but in order to do so, we
need to expose various ways to crash the kernel in a deterministic fashion.

This commit adds a file, /proc/sys/kernel/net_dump_now that takes various
tokens that will crash the kernel in various ways.

This requires kmsg_dump() be accessible to modules, so export it.

Signed-off-by: Mike Waychison <mikew@google.com>
---
Changelog:
- v2
   - Folded EXPORT_SYMBOL_GPL(kmsg_dump) into this patch

TODO: User visible ABI needs a better interface
---
 drivers/net/netoops.c |   31 +++++++++++++++++++++++++++++++
 kernel/printk.c       |    1 +
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
index 1ffd0f0..60683c5 100644
--- a/drivers/net/netoops.c
+++ b/drivers/net/netoops.c
@@ -288,6 +288,32 @@ static struct kmsg_dumper netoops_dumper = {
 	.dump = netoops,
 };
 
+static int proc_netoops_now(struct ctl_table *table, int write,
+			    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (write) {
+		char magic[20];
+		/* just crash in kernel mode. */
+		if (copy_from_user(magic, buffer, min(*lenp, sizeof(magic))))
+			return -EFAULT;
+		magic[min(*lenp, sizeof(magic))-1] = 0;
+		if (!strcmp(magic, "elgooG")) {
+			/* Test a simple crash */
+			*(unsigned long *)0 = 0;
+		} else if (!strcmp(magic, "guB")) {
+			/* Test the BUG() handler */
+			BUG();
+		} else if (!strcmp(magic, "cinaP")) {
+			panic("Testing panic");
+		} else if (!strcmp(magic, "pmuD")) {
+			kmsg_dump(KMSG_DUMP_SOFT, NULL);
+		}
+		return 0;
+	}
+	*lenp = 0;
+	return 0;
+}
+
 static struct ctl_table kern_table[] = {
 	{
 		.procname       = "net_dump_one_shot",
@@ -296,6 +322,11 @@ static struct ctl_table kern_table[] = {
 		.mode           = 0644,
 		.proc_handler   = &proc_dointvec,
 	},
+	{
+		.procname       = "net_dump_now",
+		.mode           = 0600,
+		.proc_handler   = &proc_netoops_now,
+	},
 	{},
 };
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 159b4d6..9323339 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1573,4 +1573,5 @@ void kmsg_dump(enum kmsg_dump_reason reason, struct pt_regs *pt_regs)
 		dumper->dump(dumper, reason, pt_regs, s1, l1, s2, l2);
 	spin_unlock_irqrestore(&dump_list_lock, flags);
 }
+EXPORT_SYMBOL_GPL(kmsg_dump);
 #endif
