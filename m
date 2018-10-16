From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v3 2/2] sysctl: handle overflow for file-max
Date: Wed, 17 Oct 2018 00:33:22 +0200
Message-ID: <20181016223322.16844-3-christian@brauner.io>
References: <20181016223322.16844-1-christian@brauner.io>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181016223322.16844-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, mcgrof@kernel.org, akpm@linux-foundation.org, joe.lawrence@redhat.com, longman@redhat.com, linux@dominikbrodowski.net, viro@zeniv.linux.org.uk, adobriyan@gmail.com, linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Currently, when writing

echo 18446744073709551616 > /proc/sys/fs/file-max

/proc/sys/fs/file-max will overflow and be set to 0. That quickly
crashes the system.
This commit sets the max and min value for file-max and returns -EINVAL
when a long int is exceeded. Any higher value cannot currently be used as
the percpu counters are long ints and not unsigned integers. This behavior
also aligns with other tuneables that return -EINVAL when their range is
exceeded. See e.g. [1], [2] and others.

[1]: fb910c42cceb ("sysctl: check for UINT_MAX before unsigned int min/max")
[2]: 196851bed522 ("s390/topology: correct topology mode proc handler")

Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Christian Brauner <christian@brauner.io>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
v2->v3:
- unchanged

v2->v1:
- consistenly fail on overflow

v0->v1:
- if max value is < than ULONG_MAX use max as upper bound
- (Dominik) remove double "the" from commit message
---
 kernel/sysctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 102aa7a65687..93456e3a90cd 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -128,6 +128,7 @@ static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
 static int __maybe_unused four = 4;
 static unsigned long one_ul = 1;
+static unsigned long long_max = LONG_MAX;
 static int one_hundred = 100;
 static int one_thousand = 1000;
 #ifdef CONFIG_PRINTK
@@ -1697,6 +1698,8 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(files_stat.max_files),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &long_max,
 	},
 	{
 		.procname	= "nr_open",
@@ -2813,6 +2816,10 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 				break;
 			if (neg)
 				continue;
+			if ((max && val > *max) || (min && val < *min)) {
+				err = -EINVAL;
+				break;
+			}
 			val = convmul * val / convdiv;
 			if ((min && val < *min) || (max && val > *max))
 				continue;
-- 
2.17.1
