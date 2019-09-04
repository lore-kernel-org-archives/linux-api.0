From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v12 04/12] perf_event_open: switch to copy_struct_from_user()
Date: Thu,  5 Sep 2019 06:19:25 +1000
Message-ID: <20190904201933.10736-5-cyphar@cyphar.com>
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

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 kernel/events/core.c | 45 ++++++++------------------------------------
 1 file changed, 8 insertions(+), 37 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0463c1151bae..fe5f58443ba6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10498,55 +10498,26 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
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
 	if (size < PERF_ATTR_SIZE_VER0)
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
