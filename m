From: Aleksa Sarai <asarai@suse.de>
Subject: [PATCH RESEND v3 3/4] sched_setattr: switch to copy_struct_from_user()
Date: Tue,  1 Oct 2019 05:15:25 +1000
Message-ID: <20190930191526.19544-4-asarai@suse.de>
References: <20190930191526.19544-1-asarai@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-105510-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20190930191526.19544-1-asarai@suse.de>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Kees Cook <keescook@chromium.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Aleksa Sarai <cyphar@cyphar.com>

The change is very straightforward, and helps unify the syscall
interface for struct-from-userspace syscalls. Ideally we could also
unify sched_getattr(2)-style syscalls as well, but unfortunately the
correct semantics for such syscalls are much less clear (see [1] for
more detail). In future we could come up with a more sane idea for how
the syscall interface should look.

[1]: commit 1251201c0d34 ("sched/core: Fix uclamp ABI bug, clean up and
     robustify sched_read_attr() ABI logic and code")

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 kernel/sched/core.c | 43 +++++++------------------------------------
 1 file changed, 7 insertions(+), 36 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7880f4f64d0e..dd05a378631a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5106,9 +5106,6 @@ static int sched_copy_attr(struct sched_attr __user *uattr, struct sched_attr *a
 	u32 size;
 	int ret;
 
-	if (!access_ok(uattr, SCHED_ATTR_SIZE_VER0))
-		return -EFAULT;
-
 	/* Zero the full structure, so that a short copy will be nice: */
 	memset(attr, 0, sizeof(*attr));
 
@@ -5116,45 +5113,19 @@ static int sched_copy_attr(struct sched_attr __user *uattr, struct sched_attr *a
 	if (ret)
 		return ret;
 
-	/* Bail out on silly large: */
-	if (size > PAGE_SIZE)
-		goto err_size;
-
 	/* ABI compatibility quirk: */
 	if (!size)
 		size = SCHED_ATTR_SIZE_VER0;
-
-	if (size < SCHED_ATTR_SIZE_VER0)
+	if (size < SCHED_ATTR_SIZE_VER0 || size > PAGE_SIZE)
 		goto err_size;
 
-	/*
-	 * If we're handed a bigger struct than we know of,
-	 * ensure all the unknown bits are 0 - i.e. new
-	 * user-space does not rely on any kernel feature
-	 * extensions we dont know about yet.
-	 */
-	if (size > sizeof(*attr)) {
-		unsigned char __user *addr;
-		unsigned char __user *end;
-		unsigned char val;
-
-		addr = (void __user *)uattr + sizeof(*attr);
-		end  = (void __user *)uattr + size;
-
-		for (; addr < end; addr++) {
-			ret = get_user(val, addr);
-			if (ret)
-				return ret;
-			if (val)
-				goto err_size;
-		}
-		size = sizeof(*attr);
+	ret = copy_struct_from_user(attr, sizeof(*attr), uattr, size);
+	if (ret) {
+		if (ret == -E2BIG)
+			goto err_size;
+		return ret;
 	}
 
-	ret = copy_from_user(attr, uattr, size);
-	if (ret)
-		return -EFAULT;
-
 	if ((attr->sched_flags & SCHED_FLAG_UTIL_CLAMP) &&
 	    size < SCHED_ATTR_SIZE_VER1)
 		return -EINVAL;
@@ -5354,7 +5325,7 @@ sched_attr_copy_to_user(struct sched_attr __user *uattr,
  * sys_sched_getattr - similar to sched_getparam, but with sched_attr
  * @pid: the pid in question.
  * @uattr: structure containing the extended parameters.
- * @usize: sizeof(attr) that user-space knows about, for forwards and backwards compatibility.
+ * @usize: sizeof(attr) for fwd/bwd comp.
  * @flags: for future extension.
  */
 SYSCALL_DEFINE4(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
-- 
2.23.0
