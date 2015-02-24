From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH v3 2/3] epoll: restrict wakeups to the overflow list
Date: Tue, 24 Feb 2015 21:25:45 +0000 (GMT)
Message-ID: <fb6e00a97110f31e9b4919a5e85be9373caa3a37.1424805740.git.jbaron@akamai.com>
References: <cover.1424805740.git.jbaron@akamai.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1424805740.git.jbaron@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, luto@amacapital.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

During ep_scan_ready_list(), when the ep->mtx is dropped, we queue new
events to the ep->ovflist. However, instead of just issuing wakeup for these
newly encountered events, we instead proceed to issue wakeups even if
nothing new is being propagated.

Normally, this simply results in unnecessary calls to wakeup. However,
now that we want to add wakeup queues that have 'state', this results in
unnecessary state transitions. That is, with the current default behavior
of always waking up all threads, the extra calls to wakeup do not affect
things adversely (besides the extra call overheads). However, we wish to
add policies that are stateful (for example rotating wakeups among epoll
sets), and these unnecessary wakeups cause unwanted transitions.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index d77f944..da84712 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -594,7 +594,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 					   struct list_head *, void *),
 			      void *priv, int depth, bool ep_locked)
 {
-	int error, pwake = 0;
+	int error, pwake = 0, newly_ready = 0;
 	unsigned long flags;
 	struct epitem *epi, *nepi;
 	LIST_HEAD(txlist);
@@ -634,6 +634,13 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	for (nepi = ep->ovflist; (epi = nepi) != NULL;
 	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
 		/*
+		 * We only need to perform wakeups if new events have arrived
+		 * while the ep->lock was dropped. We should have already
+		 * issued the wakeups for an existing events.
+		 */
+		if (!newly_ready)
+			newly_ready = 1;
+		/*
 		 * We need to check if the item is already in the list.
 		 * During the "sproc" callback execution time, items are
 		 * queued into ->ovflist but the "txlist" might already
@@ -657,7 +664,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	list_splice(&txlist, &ep->rdllist);
 	__pm_relax(ep->ws);
 
-	if (!list_empty(&ep->rdllist)) {
+	if (newly_ready) {
 		/*
 		 * Wake up (if active) both the eventpoll wait list and
 		 * the ->poll() wait list (delayed after we release the lock).
-- 
1.8.2.rc2
