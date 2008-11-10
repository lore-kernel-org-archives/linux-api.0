From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: [take 2] Use pid in inotify events.
Date: Mon, 10 Nov 2008 18:13:45 +0300
Message-ID: <20081110151345.GA15796@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>
Cc: John McCutchan <ttb-/fF4VJJ1vBJctGpslLZhzA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi.

This patch allows to send IO origin PID in inotify events (using cookie
fields for all events except moving, where it is already used to track
move from and move to parts) when its uid matches inotify owner uid or
when inotify owner has admin capabilities (Jeff Schroeder's idea).

Signed-off-by: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>

diff --git a/fs/inotify.c b/fs/inotify.c
index 690e725..835259d 100644
--- a/fs/inotify.c
+++ b/fs/inotify.c
@@ -69,6 +69,9 @@ static atomic_t inotify_cookie;
  * inotify_add_watch() to the final put_inotify_watch().
  */
 
+#define IH_FLAGS_ADMIN		(0x00000001)
+/* handler owner has admin capabilities */
+
 /*
  * struct inotify_handle - represents an inotify instance
  *
@@ -80,6 +83,8 @@ struct inotify_handle {
 	struct list_head	watches;	/* list of watches */
 	atomic_t		count;		/* reference count */
 	u32			last_wd;	/* the last wd allocated */
+	uid_t			uid;		/* owner's uid */
+	u32			flags;		/* operation flags */
 	const struct inotify_operations *in_ops; /* inotify caller operations */
 };
 
@@ -292,6 +297,11 @@ void inotify_inode_queue_event(struct inode *inode, u32 mask, u32 cookie,
 			mutex_lock(&ih->mutex);
 			if (watch_mask & IN_ONESHOT)
 				remove_watch_no_event(watch, ih);
+
+			if (!cookie && ((ih->flags & IH_FLAGS_ADMIN) ||
+					(current->uid == ih->uid)))
+				cookie = task_tgid_vnr(current);
+
 			ih->in_ops->handle_event(watch, watch->wd, mask, cookie,
 						 name, n_inode);
 			mutex_unlock(&ih->mutex);
@@ -459,6 +469,10 @@ struct inotify_handle *inotify_init(const struct inotify_operations *ops)
 	mutex_init(&ih->mutex);
 	ih->last_wd = 0;
 	ih->in_ops = ops;
+	ih->uid = current->user->uid;
+	ih->flags = 0;
+	if (capable(CAP_SYS_ADMIN))
+		ih->flags |= IH_FLAGS_ADMIN;
 	atomic_set(&ih->count, 0);
 	get_inotify_handle(ih);
 
-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
