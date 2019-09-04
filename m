From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v12 02/12] clone3: switch to copy_struct_from_user()
Date: Thu,  5 Sep 2019 06:19:23 +1000
Message-ID: <20190904201933.10736-3-cyphar@cyphar.com>
References: <20190904201933.10736-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190904201933.10736-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-alpha@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The change is very straightforward, and takes advantage of the (very
minor) efficiency improvements in copy_struct_from_user() -- that the
memchr_inv() check is done on a buffer instead of one-at-at-time with
get_user().

Additionally, explicitly define CLONE_ARGS_SIZE_VER0 to match the other
users of the struct-extension pattern.

Cc: Christian Brauner <christian@brauner.io>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 include/uapi/linux/sched.h |  2 ++
 kernel/fork.c              | 34 ++++++----------------------------
 2 files changed, 8 insertions(+), 28 deletions(-)

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
index 2852d0e76ea3..70c10d9b429a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2528,39 +2528,17 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 #ifdef __ARCH_WANT_SYS_CLONE3
 noinline static int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 					      struct clone_args __user *uargs,
-					      size_t size)
+					      size_t usize)
 {
+	int err;
 	struct clone_args args;
 
-	if (unlikely(size > PAGE_SIZE))
-		return -E2BIG;
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
 
 	*kargs = (struct kernel_clone_args){
 		.flags		= args.flags,
-- 
2.23.0
