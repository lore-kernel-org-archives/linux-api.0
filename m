From: adam.manzanares@wdc.com
Subject: [PATCH v7 2/5] fs: Convert kiocb rw_hint from enum to u16
Date: Tue, 22 May 2018 10:52:18 -0700
Message-ID: <20180522175221.2391-3-adam.manzanares@wdc.com>
References: <20180522175221.2391-1-adam.manzanares@wdc.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180522175221.2391-1-adam.manzanares@wdc.com>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org
Cc: mingo@kernel.org, tglx@linutronix.de, kstewart@linuxfoundation.org, peterz@infradead.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, bigeasy@linutronix.de, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, hch@infradread.org, jmoyer@redhat.com, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

In order to avoid kiocb bloat for per command iopriority support, rw_hint
is converted from enum to a u16. Added a guard around ki_hint assignment.

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
---
 fs/aio.c           |  2 +-
 include/linux/fs.h | 13 +++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 755d3f57bcc8..87d8939bb1e4 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1450,7 +1450,7 @@ static int aio_prep_rw(struct kiocb *req, struct iocb *iocb)
 	req->ki_flags = iocb_flags(req->ki_filp);
 	if (iocb->aio_flags & IOCB_FLAG_RESFD)
 		req->ki_flags |= IOCB_EVENTFD;
-	req->ki_hint = file_write_hint(req->ki_filp);
+	req->ki_hint = ki_hint_validate(file_write_hint(req->ki_filp));
 	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
 	if (unlikely(ret))
 		fput(req->ki_filp);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7f07977bdfd7..9b76ee73af14 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -299,7 +299,7 @@ struct kiocb {
 	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
 	void			*private;
 	int			ki_flags;
-	enum rw_hint		ki_hint;
+	u16			ki_hint;
 } __randomize_layout;
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
@@ -1927,12 +1927,21 @@ static inline enum rw_hint file_write_hint(struct file *file)
 
 static inline int iocb_flags(struct file *file);
 
+static inline u16 ki_hint_validate(enum rw_hint hint)
+{
+	typeof(((struct kiocb *)0)->ki_hint) max_hint = -1;
+
+	if (hint <= max_hint)
+		return hint;
+	return 0;
+}
+
 static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 {
 	*kiocb = (struct kiocb) {
 		.ki_filp = filp,
 		.ki_flags = iocb_flags(filp),
-		.ki_hint = file_write_hint(filp),
+		.ki_hint = ki_hint_validate(file_write_hint(filp)),
 	};
 }
 
-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
