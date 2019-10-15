From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 02/21] Add a prelocked wake-up
Date: Tue, 15 Oct 2019 22:48:07 +0100
Message-ID: <157117608708.15019.1998141309054662114.stgit@warthog.procyon.org.uk>
References: <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a wakeup call for a case whereby the caller already has the waitqueue
spinlock held.  This can be used by pipes to alter the ring buffer indices
under the spinlock.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/wait.h |    2 ++
 kernel/sched/wait.c  |    7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 3eb7cae8206c..d511b298a20c 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -229,6 +229,8 @@ void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode, int nr);
 	__wake_up(x, TASK_INTERRUPTIBLE, 1, poll_to_key(m))
 #define wake_up_interruptible_sync_poll(x, m)					\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, poll_to_key(m))
+void prelocked_wake_up_interruptible_sync_poll(struct wait_queue_head *wq_head,
+					       __poll_t mask);
 
 #define ___wait_cond_timeout(condition)						\
 ({										\
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index c1e566a114ca..43fbbbe9af27 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -126,6 +126,13 @@ static void __wake_up_common_lock(struct wait_queue_head *wq_head, unsigned int
 	} while (bookmark.flags & WQ_FLAG_BOOKMARK);
 }
 
+void prelocked_wake_up_interruptible_sync_poll(struct wait_queue_head *wq_head,
+					       __poll_t mask)
+{
+	__wake_up_common(wq_head, TASK_INTERRUPTIBLE, 1, WF_SYNC,
+			 poll_to_key(mask), NULL);
+}
+
 /**
  * __wake_up - wake up threads blocked on a waitqueue.
  * @wq_head: the waitqueue
