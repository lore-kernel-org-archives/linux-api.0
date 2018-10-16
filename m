From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v2 1/2] sysctl: handle overflow in proc_get_long
Date: Tue, 16 Oct 2018 21:53:36 +0200
Message-ID: <20181016195337.2440-2-christian@brauner.io>
References: <20181016195337.2440-1-christian@brauner.io>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181016195337.2440-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, mcgrof@kernel.org, akpm@linux-foundation.org, joe.lawrence@redhat.com, longman@redhat.com, linux@dominikbrodowski.net, viro@zeniv.linux.org.uk, adobriyan@gmail.com, linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

proc_get_long() is a funny function. It uses simple_strtoul() and for a
good reason. proc_get_long() wants to always succeed the parse and return
the maybe incorrect value and the trailing characters to check against a
pre-defined list of acceptable trailing values.
However, simple_strtoul() explicitly ignores overflows which can cause
funny things like the following to happen:

echo 18446744073709551616 > /proc/sys/fs/file-max
cat /proc/sys/fs/file-max
0

(Which will cause your system to silently die behind your back.)

On the other hand kstrtoul() does do overflow detection but does not return
the trailing characters, and also fails the parse when anything other than
'\n' is a trailing character whereas proc_get_long() wants to be more
lenient.

Now, before adding another kstrtoul() function let's simply add a static
parse strtoul_lenient() which:
- fails on overflow with -ERANGE
- returns the trailing characters to the caller

The reason why we should fail on ERANGE is that we already do a partial
fail on overflow right now. Namely, when the TMPBUFLEN is exceeded. So we
already reject values such as 184467440737095516160 (21 chars) but accept
values such as 18446744073709551616 (20 chars) but both are overflows. So
we should just always reject 64bit overflows and not special-case this
based on the number of chars.

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Christian Brauner <christian@brauner.io>
---
v1->v2:
- s/sysctl_cap_erange/sysctl_lenient/g
- consistenly fail on overflow
v0->v1:
- s/sysctl_strtoul_lenient/strtoul_cap_erange/g
- (Al) remove bool overflow return argument from strtoul_cap_erange
- (Al) return ULONG_MAX on ERANGE from strtoul_cap_erange
- (Dominik) fix spelling in commit message
---
 kernel/sysctl.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index cc02050fd0c4..7d98e02e5d72 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -67,6 +67,7 @@
 #include <linux/bpf.h>
 #include <linux/mount.h>
 #include <linux/pipe_fs_i.h>
+#include <../lib/kstrtox.h>
 
 #include <linux/uaccess.h>
 #include <asm/processor.h>
@@ -2065,6 +2066,26 @@ static void proc_skip_char(char **buf, size_t *size, const char v)
 	}
 }
 
+static int strtoul_lenient(const char *cp, char **endp, unsigned int base,
+			   unsigned long *res)
+{
+	unsigned long long result;
+	unsigned int rv;
+
+	cp = _parse_integer_fixup_radix(cp, &base);
+	rv = _parse_integer(cp, base, &result);
+	if ((rv & KSTRTOX_OVERFLOW) || (result != (unsigned long)result))
+		return -ERANGE;
+
+	cp += rv;
+
+	if (endp)
+		*endp = (char *)cp;
+
+	*res = (unsigned long)result;
+	return 0;
+}
+
 #define TMPBUFLEN 22
 /**
  * proc_get_long - reads an ASCII formatted integer from a user buffer
@@ -2108,7 +2129,8 @@ static int proc_get_long(char **buf, size_t *size,
 	if (!isdigit(*p))
 		return -EINVAL;
 
-	*val = simple_strtoul(p, &p, 0);
+	if (strtoul_lenient(p, &p, 0, val))
+		return -EINVAL;
 
 	len = p - tmp;
 
-- 
2.17.1
