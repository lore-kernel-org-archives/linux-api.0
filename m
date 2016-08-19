From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: [PATCH 1/8] pipe: relocate round_pipe_size() above pipe_set_size()
Date: Fri, 19 Aug 2016 17:25:12 +1200
Message-ID: <1975f9d2-5929-7acd-46ef-b735dcf32a8e@gmail.com>
References: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mtk.manpages@gmail.com, Willy Tarreau <w@1wt.eu>, Vegard Nossum <vegard.nossum@oracle.com>, socketpair@gmail.com, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is a minor preparatory patch. After subsequent patches,
round_pipe_size() will be called from pipe_set_size(), so place
round_pipe_size() above pipe_set_size().

Cc: Willy Tarreau <w@1wt.eu>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: socketpair@gmail.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

---
 fs/pipe.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 4ebe6b2..7d7c21e 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1011,6 +1011,18 @@ const struct file_operations pipefifo_fops = {
 };
 
 /*
+ * Currently we rely on the pipe array holding a power-of-2 number
+ * of pages.
+ */
+static inline unsigned int round_pipe_size(unsigned int size)
+{
+	unsigned long nr_pages;
+
+	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	return roundup_pow_of_two(nr_pages) << PAGE_SHIFT;
+}
+
+/*
  * Allocate a new array of pipe buffers and copy the info over. Returns the
  * pipe size if successful, or return -ERROR on error.
  */
@@ -1062,18 +1074,6 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long nr_pages)
 }
 
 /*
- * Currently we rely on the pipe array holding a power-of-2 number
- * of pages.
- */
-static inline unsigned int round_pipe_size(unsigned int size)
-{
-	unsigned long nr_pages;
-
-	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	return roundup_pow_of_two(nr_pages) << PAGE_SHIFT;
-}
-
-/*
  * This should work even if CONFIG_PROC_FS isn't set, as proc_dointvec_minmax
  * will return an error.
  */
-- 
2.5.5
