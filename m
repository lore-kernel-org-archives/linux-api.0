From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v3 2/4] clone3: switch to copy_struct_from_user()
Date: Tue,  1 Oct 2019 04:28:08 +1000
Message-ID: <20190930182810.6090-3-cyphar@cyphar.com>
References: <20190930182810.6090-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-105502-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20190930182810.6090-1-cyphar@cyphar.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Kees Cook <keescook@chromium.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The change is very straightforward, and helps unify the syscall
interface for struct-from-userspace syscalls. Additionally, explicitly
define CLONE_ARGS_SIZE_VER0 to match the other users of the
struct-extension pattern.

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 include/uapi/linux/sched.h |  2 ++
 kernel/fork.c              | 34 +++++++---------------------------
 2 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index b3105ac1381a..0945805982b4 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -47,6 +47,8 @@ struct clone_args {
 	__aligned_u64 tls;
 };
 
+#define CLONE_ARGS_SIZE_VER0 64 /* sizeof first published struct */
+
 /*
  * Scheduling policies
  */
diff --git a/kernel/fork.c b/kernel/fork.c
index f9572f416126..2ef529869c64 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2525,39 +2525,19 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 #ifdef __ARCH_WANT_SYS_CLONE3
 noinline static int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 					      struct clone_args __user *uargs,
-					      size_t size)
+					      size_t usize)
 {
+	int err;
 	struct clone_args args;
 
-	if (unlikely(size > PAGE_SIZE))
+	if (unlikely(usize > PAGE_SIZE))
 		return -E2BIG;
-
-	if (unlikely(size < sizeof(struct clone_args)))
+	if (unlikely(usize < CLONE_ARGS_SIZE_VER0))
 		return -EINVAL;
 
-	if (unlikely(!access_ok(uargs, size)))
-		return -EFAULT;
-
-	if (size > sizeof(struct clone_args)) {
-		unsigned char __user *addr;
-		unsigned char __user *end;
-		unsigned char val;
-
-		addr = (void __user *)uargs + sizeof(struct clone_args);
-		end = (void __user *)uargs + size;
-
-		for (; addr < end; addr++) {
-			if (get_user(val, addr))
-				return -EFAULT;
-			if (val)
-				return -E2BIG;
-		}
-
-		size = sizeof(struct clone_args);
-	}
-
-	if (copy_from_user(&args, uargs, size))
-		return -EFAULT;
+	err = copy_struct_from_user(&args, sizeof(args), uargs, usize);
+	if (err)
+		return err;
 
 	/*
 	 * Verify that higher 32bits of exit_signal are unset and that
-- 
2.23.0
