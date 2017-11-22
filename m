From: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 1/4] fs/splice: introduce pages_to_pipe helper
Date: Wed, 22 Nov 2017 21:36:28 +0200
Message-ID: <1511379391-988-2-git-send-email-rppt@linux.vnet.ibm.com>
References: <1511379391-988-1-git-send-email-rppt@linux.vnet.ibm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511379391-988-1-git-send-email-rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 fs/splice.c | 57 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 39e2dc0..7f1ffc5 100644
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
