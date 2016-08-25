From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] fs: add iomap_file_dirty
Date: Thu, 25 Aug 2016 16:31:07 -0700
Message-ID: <147216786712.525.5901639662288553230.stgit@birch.djwong.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, viro@ZenIV.linux.org.uk, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Originally-from: Christoph Hellwig <hch@lst.de>

This function uses the iomap infrastructure to re-write all pages
in a given range.  This is useful for doing a copy-up of COW ranges,
and might be useful for scrubbing in the future.

XXX: might want a bigger name, and possible a better implementation
that doesn't require two lookups in the radix tree.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c            |   82 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h |    2 +
 2 files changed, 84 insertions(+)


diff --git a/fs/iomap.c b/fs/iomap.c
index 0342254..7b295d5 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -252,6 +252,88 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *iter,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
+static struct page *
+__iomap_read_page(struct inode *inode, loff_t offset)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct page *page;
+
+	page = read_mapping_page(mapping, offset >> PAGE_SHIFT, NULL);
+	if (IS_ERR(page))
+		return page;
+	if (!PageUptodate(page)) {
+		put_page(page);
+		return ERR_PTR(-EIO);
+	}
+	return page;
+}
+
+static loff_t
+iomap_dirty_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
+		struct iomap *iomap)
+{
+	long status = 0;
+	ssize_t written = 0;
+
+	do {
+		struct page *page, *rpage;
+		unsigned long offset;	/* Offset into pagecache page */
+		unsigned long bytes;	/* Bytes to write to page */
+
+		offset = (pos & (PAGE_SIZE - 1));
+		bytes = min_t(unsigned long, PAGE_SIZE - offset, length);
+
+		rpage = __iomap_read_page(inode, pos);
+		if (IS_ERR(rpage))
+			return PTR_ERR(rpage);
+
+		status = iomap_write_begin(inode, pos, bytes,
+				AOP_FLAG_NOFS | AOP_FLAG_UNINTERRUPTIBLE,
+				&page, iomap);
+		put_page(rpage);
+		if (unlikely(status))
+			return status;
+
+		WARN_ON_ONCE(!PageUptodate(page));
+
+		status = iomap_write_end(inode, pos, bytes, bytes, page);
+		if (unlikely(status <= 0)) {
+			if (WARN_ON_ONCE(status == 0))
+				return -EIO;
+			return status;
+		}
+
+		cond_resched();
+
+		pos += status;
+		written += status;
+		length -= status;
+
+		balance_dirty_pages_ratelimited(inode->i_mapping);
+	} while (length);
+
+	return written;
+}
+
+int
+iomap_file_dirty(struct inode *inode, loff_t pos, loff_t len,
+		struct iomap_ops *ops)
+{
+	loff_t ret;
+
+	while (len) {
+		ret = iomap_apply(inode, pos, len, IOMAP_WRITE, ops, NULL,
+				iomap_dirty_actor);
+		if (ret <= 0)
+			return ret;
+		pos += ret;
+		len -= ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iomap_file_dirty);
+
 static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
 		unsigned bytes, struct iomap *iomap)
 {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3267df4..b2e30e5 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -58,6 +58,8 @@ struct iomap_ops {
 
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		struct iomap_ops *ops);
+int iomap_file_dirty(struct inode *inode, loff_t pos, loff_t len,
+		struct iomap_ops *ops);
 int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
 		bool *did_zero, struct iomap_ops *ops);
 int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
