From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
Date: Fri, 14 Nov 2014 11:32:53 -0500
Message-ID: <x49mw7tyc7e.fsf@segfault.boston.devel.redhat.com>
References: <cover.1415636409.git.milosz@adfin.com>
	<20141111064417.GT23575@dastard>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20141111064417.GT23575@dastard> (Dave Chinner's message of "Tue,
	11 Nov 2014 17:44:17 +1100")
Sender: owner-linux-aio@kvack.org
To: Dave Chinner <david@fromorbit.com>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, davej@redhat.com
List-Id: linux-api@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Mon, Nov 10, 2014 at 11:40:23AM -0500, Milosz Tanski wrote:
>> This patcheset introduces an ability to perform a non-blocking read from
>> regular files in buffered IO mode. This works by only for those filesystems
>> that have data in the page cache.
>> 
>> It does this by introducing new syscalls new syscalls preadv2/pwritev2. These
>> new syscalls behave like the network sendmsg, recvmsg syscalls that accept an
>> extra flag argument (RWF_NONBLOCK).
>> 
>> It's a very common patern today (samba, libuv, etc..) use a large threadpool to
>> perform buffered IO operations. They submit the work form another thread
>> that performs network IO and epoll or other threads that perform CPU work. This
>> leads to increased latency for processing, esp. in the case of data that's
>> already cached in the page cache.
>> 
>> With the new interface the applications will now be able to fetch the data in
>> their network / cpu bound thread(s) and only defer to a threadpool if it's not
>> there. In our own application (VLDB) we've observed a decrease in latency for
>> "fast" request by avoiding unnecessary queuing and having to swap out current
>> tasks in IO bound work threads.
>
> Can you write a test (or set of) for fstests that exercises this new
> functionality? I'm not worried about performance, just
> correctness....

On the subject of testing, I added support to trinity (attached,
untested).  That did raise one question.  Do we expect applications to
#include <linux/fs.h> to get the RWF_NONBLOCK definition?

Cheers,
Jeff

diff --git a/include/syscalls-i386.h b/include/syscalls-i386.h
index 767be6e..3125064 100644
--- a/include/syscalls-i386.h
+++ b/include/syscalls-i386.h
@@ -365,4 +365,6 @@ struct syscalltable syscalls_i386[] = {
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
 	{ .entry = &syscall_bpf },
+	{ .entry = &syscall_preadv2 },
+	{ .entry = &syscall_pwritev2 },
 };
diff --git a/include/syscalls-x86_64.h b/include/syscalls-x86_64.h
index cb609ad..8d32571 100644
--- a/include/syscalls-x86_64.h
+++ b/include/syscalls-x86_64.h
@@ -329,4 +329,6 @@ struct syscalltable syscalls_x86_64[] = {
 	{ .entry = &syscall_memfd_create },
 	{ .entry = &syscall_kexec_file_load },
 	{ .entry = &syscall_bpf },
+	{ .entry = &syscall_preadv2 },
+	{ .entry = &syscall_pwritev2 },
 };
diff --git a/syscalls/read.c b/syscalls/read.c
index e0948a2..adbf146 100644
--- a/syscalls/read.c
+++ b/syscalls/read.c
@@ -3,6 +3,7 @@
  */
 #include <stdlib.h>
 #include <string.h>
+#include <linux/fs.h>
 #include "arch.h"
 #include "maps.h"
 #include "random.h"
@@ -94,3 +95,29 @@ struct syscallentry syscall_preadv = {
 	.arg5name = "pos_h",
 	.flags = NEED_ALARM,
 };
+
+/*
+ * SYSCALL_DEFINE6(preadv2, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h,
+		int, flags)
+ */
+
+struct syscallentry syscall_preadv2 = {
+	.name = "preadv2",
+	.num_args = 5,
+	.arg1name = "fd",
+	.arg1type = ARG_FD,
+	.arg2name = "vec",
+	.arg2type = ARG_IOVEC,
+	.arg3name = "vlen",
+	.arg3type = ARG_IOVECLEN,
+	.arg4name = "pos_l",
+	.arg5name = "pos_h",
+	.arg6name = "flags",
+	.arg6type = ARG_OP,
+	.arg6list = {
+		.num = 1,
+		.values = { RWF_NONBLOCK, },
+	},
+	.flags = NEED_ALARM,
+};
diff --git a/syscalls/syscalls.h b/syscalls/syscalls.h
index 5a7748b..04400dd 100644
--- a/syscalls/syscalls.h
+++ b/syscalls/syscalls.h
@@ -375,5 +375,7 @@ extern struct syscallentry syscall_seccomp;
 extern struct syscallentry syscall_memfd_create;
 extern struct syscallentry syscall_kexec_file_load;
 extern struct syscallentry syscall_bpf;
+extern struct syscallentry syscall_preadv2;
+extern struct syscallentry syscall_pwritev2;
 
 unsigned int random_fcntl_setfl_flags(void);
diff --git a/syscalls/write.c b/syscalls/write.c
index f37e760..4218ccc 100644
--- a/syscalls/write.c
+++ b/syscalls/write.c
@@ -2,6 +2,7 @@
  * SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf, size_t, count)
  */
 #include <stdlib.h>
+#include <linux/fs.h>
 #include "arch.h"	// page_size
 #include "maps.h"
 #include "random.h"
@@ -95,3 +96,30 @@ struct syscallentry syscall_pwritev = {
 	.arg5name = "pos_h",
 	.flags = NEED_ALARM,
 };
+
+
+/*
+ * SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h,
+		int, flags)
+ */
+
+struct syscallentry syscall_pwritev2 = {
+	.name = "pwritev2",
+	.num_args = 6,
+	.arg1name = "fd",
+	.arg1type = ARG_FD,
+	.arg2name = "vec",
+	.arg2type = ARG_IOVEC,
+	.arg3name = "vlen",
+	.arg3type = ARG_IOVECLEN,
+	.arg4name = "pos_l",
+	.arg5name = "pos_h",
+	.arg6name = "flags",
+	.arg6type = ARG_OP,
+	.arg6list = {
+		.num = 1,
+		.values = { RWF_NONBLOCK, },
+	},
+	.flags = NEED_ALARM,
+};

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
