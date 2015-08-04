From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Subject: [RFC v6 36/40] sunrpc: Add xdr_init_encode_pages
Date: Tue,  4 Aug 2015 13:53:34 +0200
Message-ID: <1438689218-6921-37-git-send-email-agruenba@redhat.com>
References: <1438689218-6921-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438689218-6921-1-git-send-email-agruenba@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, linux-cifs@vger.kernel.org, linux-security-module@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
List-Id: linux-api@vger.kernel.org

Initialize xdr_stream and xdr_buf from a pages array, for encoding into
the pages.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 include/linux/sunrpc/xdr.h |  2 ++
 net/sunrpc/xdr.c           | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 70c6b92..2c99cff 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -214,6 +214,8 @@ typedef void	(*kxdreproc_t)(void *rqstp, struct xdr_stream *xdr, void *obj);
 typedef int	(*kxdrdproc_t)(void *rqstp, struct xdr_stream *xdr, void *obj);
 
 extern void xdr_init_encode(struct xdr_stream *xdr, struct xdr_buf *buf, __be32 *p);
+extern void xdr_init_encode_pages(struct xdr_stream *xdr, struct xdr_buf *buf,
+				  struct page **pages, unsigned int len);
 extern __be32 *xdr_reserve_space(struct xdr_stream *xdr, size_t nbytes);
 extern void xdr_commit_encode(struct xdr_stream *xdr);
 extern void xdr_truncate_encode(struct xdr_stream *xdr, size_t len);
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 63c1c36..f97b96b 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -483,6 +483,31 @@ void xdr_init_encode(struct xdr_stream *xdr, struct xdr_buf *buf, __be32 *p)
 EXPORT_SYMBOL_GPL(xdr_init_encode);
 
 /**
+ * xdr_init_encode_pages - Initialize struct xdr_stream for encoding into pages
+ * @xdr: pointer to xdr_stream struct
+ * @buf: pointer to XDR buffer in which to encode data
+ * @pages: pages array in which to encode
+ * @len: maximum length of @buf
+ *
+ * Initialize @xdr and @buf for encoding into the @pages array.  If a
+ * page in @pages is NULL, it will be allocated on demand.
+ */
+void xdr_init_encode_pages(struct xdr_stream *xdr, struct xdr_buf *buf,
+			   struct page **pages, unsigned int len)
+{
+	memset(buf, 0, sizeof(*buf));
+	buf->pages = pages;
+	buf->page_len = len;
+	buf->buflen = len;
+
+	memset(xdr, 0, sizeof(*xdr));
+	xdr->buf = buf;
+	xdr->iov = buf->head;
+	xdr->page_ptr = pages - 1;
+}
+EXPORT_SYMBOL_GPL(xdr_init_encode_pages);
+
+/**
  * xdr_commit_encode - Ensure all data is written to buffer
  * @xdr: pointer to xdr_stream
  *
-- 
2.5.0
