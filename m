From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: [PATCH v5 1/4] fs/splice: introduce pages_to_pipe helper
Date: Tue,  9 Jan 2018 08:30:50 +0200
Message-ID: <1515479453-14672-2-git-send-email-rppt@linux.vnet.ibm.com>
References: <1515479453-14672-1-git-send-email-rppt@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1515479453-14672-1-git-send-email-rppt@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, criu@openvz.org, gdb@sourceware.org, devel@lists.open-mpi.org, rr-dev@mozilla.org, Arnd Bergmann <arnd@arndb.de>, Pavel Emelyanov <xemul@virtuozzo.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Josh Triplett <josh@joshtriplett.org>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Andrei Vagin <avagin@openvz.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
---
 fs/splice.c | 57 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 39e2dc01ac12..7f1ffc50ff1d 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1185,6 +1185,36 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 	return -EINVAL;
 }
 
+static int pages_to_pipe(struct page **pages, struct pipe_inode_info *pipe,
+			 struct pipe_buffer *buf, size_t *total,
+			 ssize_t copied, size_t start)
+{
+	bool failed = false;
+	size_t len = 0;
+	int ret = 0;
+	int n;
+
+	for (n = 0; copied; n++, start = 0) {
+		int size = min_t(int, copied, PAGE_SIZE - start);
+		if (!failed) {
+			buf->page = pages[n];
+			buf->offset = start;
+			buf->len = size;
+			ret = add_to_pipe(pipe, buf);
+			if (unlikely(ret < 0))
+				failed = true;
+			else
+				len += ret;
+		} else {
+			put_page(pages[n]);
+		}
+		copied -= size;
+	}
+
+	*total += len;
+	return failed ? ret : len;
+}
+
 static int iter_to_pipe(struct iov_iter *from,
 			struct pipe_inode_info *pipe,
 			unsigned flags)
@@ -1195,13 +1225,11 @@ static int iter_to_pipe(struct iov_iter *from,
 	};
 	size_t total = 0;
 	int ret = 0;
-	bool failed = false;
 
-	while (iov_iter_count(from) && !failed) {
+	while (iov_iter_count(from)) {
 		struct page *pages[16];
 		ssize_t copied;
 		size_t start;
-		int n;
 
 		copied = iov_iter_get_pages(from, pages, ~0UL, 16, &start);
 		if (copied <= 0) {
@@ -1209,24 +1237,11 @@ static int iter_to_pipe(struct iov_iter *from,
 			break;
 		}
 
-		for (n = 0; copied; n++, start = 0) {
-			int size = min_t(int, copied, PAGE_SIZE - start);
-			if (!failed) {
-				buf.page = pages[n];
-				buf.offset = start;
-				buf.len = size;
-				ret = add_to_pipe(pipe, &buf);
-				if (unlikely(ret < 0)) {
-					failed = true;
-				} else {
-					iov_iter_advance(from, ret);
-					total += ret;
-				}
-			} else {
-				put_page(pages[n]);
-			}
-			copied -= size;
-		}
+		ret = pages_to_pipe(pages, pipe, &buf, &total, copied, start);
+		if (unlikely(ret < 0))
+			break;
+
+		iov_iter_advance(from, ret);
 	}
 	return total ? total : ret;
 }
-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
