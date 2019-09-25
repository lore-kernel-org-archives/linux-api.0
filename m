From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v2 3/4] sched_setattr: switch to copy_struct_from_user()
Date: Thu, 26 Sep 2019 01:03:31 +0200
Message-ID: <20190925230332.18690-4-cyphar@cyphar.com>
References: <20190925230332.18690-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190925230332.18690-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

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
index df9f1fe5689b..cdb2f5e29b88 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4900,9 +4900,6 @@ static int sched_copy_attr(struct sched_attr __user *uattr, struct sched_attr *a
 	u32 size;
 	int ret;
 
-	if (!access_ok(uattr, SCHED_ATTR_SIZE_VER0))
-		return -EFAULT;
-
 	/* Zero the full structure, so that a short copy will be nice: */
 	memset(attr, 0, sizeof(*attr));
 
@@ -4910,45 +4907,19 @@ static int sched_copy_attr(struct sched_attr __user *uattr, struct sched_attr *a
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
@@ -5148,7 +5119,7 @@ sched_attr_copy_to_user(struct sched_attr __user *uattr,
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
