From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 09/12] netoops: Add an interface to trigger various types
	of crashes.
Date: Tue, 02 Nov 2010 18:30:19 -0700
Message-ID: <20101103013018.4641.251.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: simon.kagstrom@netinsight.net, davem@davemloft.net
Cc: adurbin@google.com, akpm@linux-foundation.org, chavey@google.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

It is very useful to be able to test the crash path, but in order to do so, we
need to expose various ways to crash the kernel in a deterministic fashion.

This commit adds a file, /proc/sys/kernel/net_dump_now that takes various
tokens that will crash the kernel in various ways.

Signed-off-by: Mike Waychison <mikew@google.com>
---

This trigger is probably better done using an ABI that is much more generic.
It could perhaps be an extension of /proc/sysrq-trigger, though it would be
nice to have the 'types' of crashes enumerated in a programmable manner somehow
to know if they are available or not.
---
 drivers/net/netoops.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
index 01432d7..87b2122 100644
--- a/drivers/net/netoops.c
+++ b/drivers/net/netoops.c
@@ -578,6 +578,32 @@ static int proc_netoops_device(struct ctl_table *table, int write,
 	return 0;
 }
 
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
 		.procname       = "net_dump_device",
@@ -585,6 +611,11 @@ static struct ctl_table kern_table[] = {
 		.proc_handler   = &proc_netoops_device,
 	},
 	{
+		.procname       = "net_dump_now",
+		.mode           = 0600,
+		.proc_handler   = &proc_netoops_now,
+	},
+	{
 		.procname       = "net_dump_one_shot",
 		.data           = &network_dumper_one_shot,
 		.maxlen         = sizeof(int),
