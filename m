From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: [PATCH 1/3] userfaultfd: introduce userfaultfd_init_waitqueue helper
Date: Tue, 27 Feb 2018 10:19:50 +0200
Message-ID: <1519719592-22668-2-git-send-email-rppt@linux.vnet.ibm.com>
References: <1519719592-22668-1-git-send-email-rppt@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519719592-22668-1-git-send-email-rppt@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>, linux-mm <linux-mm@kvack.org>, linux-api <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, crml <criu@openvz.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

The helper can be used for initialization of wait queue entries for both
page-fault and non-cooperative events

Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
---
 fs/userfaultfd.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index cec550c8468f..b32c7aaeca6b 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -131,6 +131,15 @@ static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
 	return ret;
 }
 
+static inline void userfaultfd_init_waitqueue(struct userfaultfd_ctx *ctx,
+					      struct userfaultfd_wait_queue *uwq)
+{
+	init_waitqueue_func_entry(&uwq->wq, userfaultfd_wake_function);
+	uwq->wq.private = current;
+	uwq->ctx = ctx;
+	uwq->waken = false;
+}
+
 /**
  * userfaultfd_ctx_get - Acquires a reference to the internal userfaultfd
  * context.
@@ -444,12 +453,9 @@ int handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	/* take the reference before dropping the mmap_sem */
 	userfaultfd_ctx_get(ctx);
 
-	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
-	uwq.wq.private = current;
+	userfaultfd_init_waitqueue(ctx, &uwq);
 	uwq.msg = userfault_msg(vmf->address, vmf->flags, reason,
 			ctx->features);
-	uwq.ctx = ctx;
-	uwq.waken = false;
 
 	return_to_userland =
 		(vmf->flags & (FAULT_FLAG_USER|FAULT_FLAG_KILLABLE)) ==
-- 
2.7.4
