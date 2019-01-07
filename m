From: Christian Brauner <christian@brauner.io>
Subject: [RESEND PATCH v3 2/2] sysctl: handle overflow for file-max
Date: Mon,  7 Jan 2019 23:27:00 +0100
Message-ID: <20190107222700.15954-3-christian@brauner.io>
References: <20190107222700.15954-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190107222700.15954-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, mcgrof@kernel.org, joe.lawrence@redhat.com, longman@redhat.com, linux@dominikbrodowski.net, viro@zeniv.linux.org.uk, adobriyan@gmail.com, linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
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
---
v3:
- unchanged

v1:
- consistenly fail on overflow

v1:
- if max value is < than ULONG_MAX use max as upper bound
- (Dominik) remove double "the" from commit message
---
 kernel/sysctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 06df9ef138e3..11378a59af4b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -129,6 +129,7 @@ static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
 static int __maybe_unused four = 4;
 static unsigned long one_ul = 1;
+static unsigned long long_max = LONG_MAX;
 static int one_hundred = 100;
 static int one_thousand = 1000;
 #ifdef CONFIG_PRINTK
@@ -1717,6 +1718,8 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(files_stat.max_files),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &long_max,
 	},
 	{
 		.procname	= "nr_open",
@@ -2833,6 +2836,10 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
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
2.19.1
