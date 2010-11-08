From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 22/23] netoops: Add one-shot mode
Date: Mon, 08 Nov 2010 12:33:47 -0800
Message-ID: <20101108203346.22479.10201.stgit@crlf.mtv.corp.google.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101108203120.22479.19708.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Cc: adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, =?utf-8?q?Am=C3=A9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Sometimes it is possible to have a kernel crashing that continuously
Oopses.  In this case, we do not want the network dumper get called over
and over again, as we may only be interested in the first Oops that a
kernel emits (especially in cases where we panic_on_oops).

In order to support this dumping policy, this commit introduces a file
call /proc/sys/kernel/net_dump_one_shot that contains a boolean as to
whether or not the netoops driver will operate in one-shot mode.

Note that 'soft' dumps do not disable the netoops driver when one-shot
mode is enabled.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
TODO: ABI needs a better home.
---
 drivers/net/netoops.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
index 5cbb732..1ffd0f0 100644
--- a/drivers/net/netoops.c
+++ b/drivers/net/netoops.c
@@ -97,6 +97,8 @@ struct netoops_msg {
 } __attribute__ ((packed));
 
 static struct netoops_msg msg;
+static int network_dumper_one_shot = 1;
+static int network_dumper_disabled;
 
 static char netoops_fw_version[80];
 static char netoops_board_name[80];
@@ -221,6 +223,10 @@ static void netoops(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
 		netoops_send_segment(packet_count_2, s1, l1);
 	}
 
+	/* Should we disable ourselves now? */
+	if (!soft_dump && network_dumper_one_shot)
+		network_dumper_disabled = 1;
+
 	spin_unlock_irqrestore(&targets.lock, flags);
 }
 
@@ -282,6 +288,28 @@ static struct kmsg_dumper netoops_dumper = {
 	.dump = netoops,
 };
 
+static struct ctl_table kern_table[] = {
+	{
+		.procname       = "net_dump_one_shot",
+		.data           = &network_dumper_one_shot,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+	{},
+};
+
+static struct ctl_table root_table[] = {
+	{
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= kern_table,
+	},
+	{}
+};
+
+static struct ctl_table_header *proc_table_header;
+
 static int __init netoops_init(void)
 {
 	int retval = -EINVAL;
@@ -309,7 +337,15 @@ static int __init netoops_init(void)
 	if (retval)
 		goto out_sysfs_group;
 
+	proc_table_header = register_sysctl_table(root_table);
+	if (!proc_table_header) {
+		retval = -EINVAL;
+		goto out_kmsg_dump;
+	}
+
 	return 0;
+out_kmsg_dump:
+	kmsg_dump_unregister(&netoops_dumper);
 out_sysfs_group:
 	sysfs_remove_group(netoops_kobj, &attr_group);
 out_kobj:
@@ -322,6 +358,7 @@ out:
 
 static void __exit netoops_exit(void)
 {
+	unregister_sysctl_table(proc_table_header);
 	kmsg_dump_unregister(&netoops_dumper);
 	sysfs_remove_group(netoops_kobj, &attr_group);
 	kobject_put(netoops_kobj);
