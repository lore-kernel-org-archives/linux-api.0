From: adam.manzanares@wdc.com
Subject: [PATCH 1/2] fs: aio ioprio add explicit block layer dependence
Date: Mon,  4 Jun 2018 10:59:56 -0700
Message-ID: <20180604175957.2647-1-adam.manzanares@wdc.com>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk, bcrl@kvack.org, mingo@kernel.org, tglx@linutronix.de, kstewart@linuxfoundation.org, peterz@infradead.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, bigeasy@linutronix.de, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, hch@infradread.org, jmoyer@redhat.com, willy@infradead.org, smfrench@gmail.com, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

Previously, the ioprio_check_cap function was only defined when CONFIG_BLOCK
was set. Make this relationship explicit and add a stub for !CONFIG_BLOCK.

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
---
 include/linux/ioprio.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index 4a28cec49ec3..9e30ed6443db 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -77,6 +77,13 @@ extern int ioprio_best(unsigned short aprio, unsigned short bprio);
 
 extern int set_task_ioprio(struct task_struct *task, int ioprio);
 
+#ifdef CONFIG_BLOCK
 extern int ioprio_check_cap(int ioprio);
+#else
+static inline int ioprio_check_cap(int ioprio)
+{
+	return -ENOTBLK;
+}
+#endif /* CONFIG_BLOCK */
 
 #endif
-- 
2.17.0

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
