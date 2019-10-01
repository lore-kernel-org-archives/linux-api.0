From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v4 4/4] perf_event_open: switch to copy_struct_from_user()
Date: Tue,  1 Oct 2019 11:10:55 +1000
Message-ID: <20191001011055.19283-5-cyphar@cyphar.com>
References: <20191001011055.19283-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191001011055.19283-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Kees Cook <keescook@chromium.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The change is very straightforward, and helps unify the syscall
interface for struct-from-userspace syscalls.

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 kernel/events/core.c | 47 +++++++++-----------------------------------
 1 file changed, 9 insertions(+), 38 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4655adbbae10..3f0cb82e4fbc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10586,55 +10586,26 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	u32 size;
 	int ret;
 
-	if (!access_ok(uattr, PERF_ATTR_SIZE_VER0))
-		return -EFAULT;
-
-	/*
-	 * zero the full structure, so that a short copy will be nice.
-	 */
+	/* Zero the full structure, so that a short copy will be nice. */
 	memset(attr, 0, sizeof(*attr));
 
 	ret = get_user(size, &uattr->size);
 	if (ret)
 		return ret;
 
-	if (size > PAGE_SIZE)	/* silly large */
-		goto err_size;
-
-	if (!size)		/* abi compat */
+	/* ABI compatibility quirk: */
+	if (!size)
 		size = PERF_ATTR_SIZE_VER0;
-
-	if (size < PERF_ATTR_SIZE_VER0)
+	if (size < PERF_ATTR_SIZE_VER0 || size > PAGE_SIZE)
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
 	attr->size = size;
 
 	if (attr->__reserved_1)
-- 
2.23.0
