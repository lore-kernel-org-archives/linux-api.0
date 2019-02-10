From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v4 2/3] sysctl: handle overflow for file-max
Date: Sun, 10 Feb 2019 21:39:42 +0100
Message-ID: <20190210203943.8227-3-christian@brauner.io>
References: <20190210203943.8227-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190210203943.8227-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, mcgrof@kernel.org, joe.lawrence@redhat.com, longman@redhat.com, linux@dominikbrodowski.net, viro@zeniv.linux.org.uk, adobriyan@gmail.com, linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Currently, when writing

echo 18446744073709551616 > /proc/sys/fs/file-max

/proc/sys/fs/file-max will overflow and be set to 0. That quickly
crashes the system.
This commit sets the max and min value for file-max. The max value is set
to long int. Any higher value cannot currently be used as the percpu
counters are long ints and not unsigned integers.

Note that the file-max value is ultimately parsed via
__do_proc_doulongvec_minmax(). This function does not report error when min
or max are exceeded. Which means if a value largen that long int is written
userspace will not receive an error instead the old value will be kept.
There is an argument to be made that this should be changed and
__do_proc_doulongvec_minmax() should return an error when a dedicated min
or max value are exceeded. However this has the potential to break
userspace so let's defer this to an RFC patch.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Christian Brauner <christian@brauner.io>
Acked-by: Kees Cook <keescook@chromium.org>
---
v4:
- unchanged
  The prior version of the patch contained a generic change affecting all
  callers of __do_proc_doulongvec_minmax(). This part was split out into a
  separate RFC patch as it nees a proper discussion and consideration
  whether this would break userspace.

v3:
- unchanged

v1:
- consistenly fail on overflow

v1:
- if max value is < than ULONG_MAX use max as upper bound
- (Dominik) remove double "the" from commit message
---
 kernel/sysctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 70581ade3555..c4a44b7ccb8a 100644
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
@@ -1724,6 +1725,8 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(files_stat.max_files),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &long_max,
 	},
 	{
 		.procname	= "nr_open",
-- 
2.20.1
