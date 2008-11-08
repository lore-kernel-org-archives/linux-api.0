From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [1/1] Use pid in inotify events.
Date: Sun, 9 Nov 2008 01:03:02 +0300
Message-ID: <20081108220302.GA25271@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081108184013.GA11888@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081108184013.GA11888-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>
Cc: John McCutchan <ttb-/fF4VJJ1vBJctGpslLZhzA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Nov 08, 2008 at 09:40:13PM +0300, Evgeniy Polyakov (zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org) wrote:
> But I really do not want to start to discuss this, since I already see
> that result will be effectively zero, so returning to the original
> problem with putting pid into events: if inotify_init() caller has 0
> (e)uid or if IO origin has the same (e)uid, are you ok to put pid into
> the event?

Something like this (not tested yet, no normal network access).

Signed-off.

diff --git a/fs/inotify.c b/fs/inotify.c
index 690e725..121f025 100644
--- a/fs/inotify.c
+++ b/fs/inotify.c
@@ -80,6 +80,7 @@ struct inotify_handle {
 	struct list_head	watches;	/* list of watches */
 	atomic_t		count;		/* reference count */
 	u32			last_wd;	/* the last wd allocated */
+	uid_t			uid;		/* watcher's uid */
 	const struct inotify_operations *in_ops; /* inotify caller operations */
 };
 
@@ -292,6 +293,10 @@ void inotify_inode_queue_event(struct inode *inode, u32 mask, u32 cookie,
 			mutex_lock(&ih->mutex);
 			if (watch_mask & IN_ONESHOT)
 				remove_watch_no_event(watch, ih);
+
+			if (!cookie && (ih->uid == 0 ||
+					ih->uid == current->user->uid))
+				cookie = task_tgid_vnr(current);
 			ih->in_ops->handle_event(watch, watch->wd, mask, cookie,
 						 name, n_inode);
 			mutex_unlock(&ih->mutex);
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 6024942..e426f7c 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -612,6 +612,8 @@ asmlinkage long sys_inotify_init1(int flags)
 	dev->ih = ih;
 	dev->fa = NULL;
 
+	ih->uid = user->uid;
+
 	filp->f_op = &inotify_fops;
 	filp->f_path.mnt = mntget(inotify_mnt);
 	filp->f_path.dentry = dget(inotify_mnt->mnt_root);


-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
