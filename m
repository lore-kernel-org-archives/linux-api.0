From: adam.manzanares@wdc.com
Subject: [PATCH v6 2/5] fs: Convert kiocb rw_hint from enum to u16
Date: Tue, 22 May 2018 08:07:34 -0700
Message-ID: <20180522150737.9893-3-adam.manzanares@wdc.com>
References: <20180522150737.9893-1-adam.manzanares@wdc.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180522150737.9893-1-adam.manzanares@wdc.com>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org
Cc: tglx@linutronix.de, mingo@kernel.org, pombredanne@nexb.com, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, bigeasy@linutronix.de, jack@suse.cz, darrick.wong@oracle.com, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, hch@infradread.org, jmoyer@redhat.com, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

In order to avoid kiocb bloat for per command iopriority support, rw_hint
is converted from enum to a u16. Added a guard around ki_hint assignment.

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fs.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7f07977bdfd7..50de40dbbb85 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -284,6 +284,8 @@ enum rw_hint {
 	WRITE_LIFE_EXTREME	= RWH_WRITE_LIFE_EXTREME,
 };
 
+#define MAX_KI_HINT		((1 << 16) - 1) /* ki_hint type is u16 */
+
 #define IOCB_EVENTFD		(1 << 0)
 #define IOCB_APPEND		(1 << 1)
 #define IOCB_DIRECT		(1 << 2)
@@ -299,7 +301,7 @@ struct kiocb {
 	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
 	void			*private;
 	int			ki_flags;
-	enum rw_hint		ki_hint;
+	u16			ki_hint;
 } __randomize_layout;
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
@@ -1927,12 +1929,19 @@ static inline enum rw_hint file_write_hint(struct file *file)
 
 static inline int iocb_flags(struct file *file);
 
+static inline u16 ki_hint_validate(enum rw_hint hint)
+{
+	if (hint > MAX_KI_HINT)
+		return 0;
+	return hint;
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
