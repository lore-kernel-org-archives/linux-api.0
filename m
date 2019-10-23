From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 03/10] Add wake_up_interruptible_sync_poll_locked() [ver
 #2]
Date: Wed, 23 Oct 2019 21:17:31 +0100
Message-ID: <157186185154.3995.9042853314167941790.stgit@warthog.procyon.org.uk>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a wakeup call for a case whereby the caller already has the waitqueue
spinlock held.  This can be used by pipes to alter the ring buffer indices
and issue a wakeup under the same spinlock.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/wait.h |    3 +++
 kernel/sched/wait.c  |   23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index bb7676d396cd..3283c8d02137 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -202,6 +202,7 @@ void __wake_up_locked_key(struct wait_queue_head *wq_he=
ad, unsigned int mode, vo
 void __wake_up_locked_key_bookmark(struct wait_queue_head *wq_head,
 =09=09unsigned int mode, void *key, wait_queue_entry_t *bookmark);
 void __wake_up_sync_key(struct wait_queue_head *wq_head, unsigned int mode=
, void *key);
+void __wake_up_locked_sync_key(struct wait_queue_head *wq_head, unsigned i=
nt mode, void *key);
 void __wake_up_locked(struct wait_queue_head *wq_head, unsigned int mode, =
int nr);
 void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode);
=20
@@ -229,6 +230,8 @@ void __wake_up_sync(struct wait_queue_head *wq_head, un=
signed int mode);
 =09__wake_up(x, TASK_INTERRUPTIBLE, 1, poll_to_key(m))
 #define wake_up_interruptible_sync_poll(x, m)=09=09=09=09=09\
 =09__wake_up_sync_key((x), TASK_INTERRUPTIBLE, poll_to_key(m))
+#define wake_up_interruptible_sync_poll_locked(x, m)=09=09=09=09\
+=09__wake_up_locked_sync_key((x), TASK_INTERRUPTIBLE, poll_to_key(m))
=20
 #define ___wait_cond_timeout(condition)=09=09=09=09=09=09\
 ({=09=09=09=09=09=09=09=09=09=09\
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index b4b52361dab7..ba059fbfc53a 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -191,6 +191,29 @@ void __wake_up_sync_key(struct wait_queue_head *wq_hea=
d, unsigned int mode,
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync_key);
=20
+/**
+ * __wake_up_locked_sync_key - wake up a thread blocked on a locked waitqu=
eue.
+ * @wq_head: the waitqueue
+ * @mode: which threads
+ * @key: opaque value to be passed to wakeup targets
+ *
+ * The sync wakeup differs in that the waker knows that it will schedule
+ * away soon, so while the target thread will be woken up, it will not
+ * be migrated to another CPU - ie. the two threads are 'synchronized'
+ * with each other. This can prevent needless bouncing between CPUs.
+ *
+ * On UP it can prevent extra preemption.
+ *
+ * If this function wakes up a task, it executes a full memory barrier bef=
ore
+ * accessing the task state.
+ */
+void __wake_up_locked_sync_key(struct wait_queue_head *wq_head,
+=09=09=09       unsigned int mode, void *key)
+{
+        __wake_up_common(wq_head, mode, 1, WF_SYNC, key, NULL);
+}
+EXPORT_SYMBOL_GPL(__wake_up_locked_sync_key);
+
 /*
  * __wake_up_sync - see __wake_up_sync_key()
  */
