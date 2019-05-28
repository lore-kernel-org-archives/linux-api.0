From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 3/7] vfs: Add a mount-notification facility
Date: Tue, 28 May 2019 22:06:23 +0200
Message-ID: <CAG48ez2rRh2_Kq_EGJs5k-ZBNffGs_Q=vkQdinorBgo58tbGpg@mail.gmail.com>
References: <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905933492.7587.6968545866041839538.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155905933492.7587.6968545866041839538.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 6:05 PM David Howells <dhowells@redhat.com> wrote:
> Add a mount notification facility whereby notifications about changes in
> mount topology and configuration can be received.  Note that this only
> covers vfsmount topology changes and not superblock events.  A separate
> facility will be added for that.
[...]
> @@ -172,4 +167,18 @@ static inline void notify_mount(struct mount *changed,
>                                 u32 info_flags)
>  {
>         atomic_inc(&changed->mnt_notify_counter);
> +
> +#ifdef CONFIG_MOUNT_NOTIFICATIONS
> +       {
> +               struct mount_notification n = {
> +                       .watch.type     = WATCH_TYPE_MOUNT_NOTIFY,
> +                       .watch.subtype  = subtype,
> +                       .watch.info     = info_flags | sizeof(n),
> +                       .triggered_on   = changed->mnt_id,
> +                       .changed_mount  = aux ? aux->mnt_id : 0,
> +               };
> +
> +               post_mount_notification(changed, &n);
> +       }
> +#endif
>  }
[...]
> +void post_mount_notification(struct mount *changed,
> +                            struct mount_notification *notify)
> +{
> +       const struct cred *cred = current_cred();

This current_cred() looks bogus to me. Can't mount topology changes
come from all sorts of places? For example, umount_mnt() from
umount_tree() from dissolve_on_fput() from __fput(), which could
happen pretty much anywhere depending on where the last reference gets
dropped?

> +       struct path cursor;
> +       struct mount *mnt;
> +       unsigned seq;
> +
> +       seq = 0;
> +       rcu_read_lock();
> +restart:
> +       cursor.mnt = &changed->mnt;
> +       cursor.dentry = changed->mnt.mnt_root;
> +       mnt = real_mount(cursor.mnt);
> +       notify->watch.info &= ~WATCH_INFO_IN_SUBTREE;
> +
> +       read_seqbegin_or_lock(&rename_lock, &seq);
> +       for (;;) {
> +               if (mnt->mnt_watchers &&
> +                   !hlist_empty(&mnt->mnt_watchers->watchers)) {
> +                       if (cursor.dentry->d_flags & DCACHE_MOUNT_WATCH)
> +                               post_watch_notification(mnt->mnt_watchers,
> +                                                       &notify->watch, cred,
> +                                                       (unsigned long)cursor.dentry);
> +               } else {
> +                       cursor.dentry = mnt->mnt.mnt_root;
> +               }
> +               notify->watch.info |= WATCH_INFO_IN_SUBTREE;
> +
> +               if (cursor.dentry == cursor.mnt->mnt_root ||
> +                   IS_ROOT(cursor.dentry)) {
> +                       struct mount *parent = READ_ONCE(mnt->mnt_parent);
> +
> +                       /* Escaped? */
> +                       if (cursor.dentry != cursor.mnt->mnt_root)
> +                               break;
> +
> +                       /* Global root? */
> +                       if (mnt != parent) {
> +                               cursor.dentry = READ_ONCE(mnt->mnt_mountpoint);
> +                               mnt = parent;
> +                               cursor.mnt = &mnt->mnt;
> +                               continue;
> +                       }
> +                       break;

(nit: this would look clearer if you inverted the condition and wrote
it as "if (mnt == parent) break;", then you also wouldn't need that
"continue" or the braces)

> +               }
> +
> +               cursor.dentry = cursor.dentry->d_parent;
> +       }
> +
> +       if (need_seqretry(&rename_lock, seq)) {
> +               seq = 1;
> +               goto restart;
> +       }
> +
> +       done_seqretry(&rename_lock, seq);
> +       rcu_read_unlock();
> +}
[...]
> +SYSCALL_DEFINE5(mount_notify,
> +               int, dfd,
> +               const char __user *, filename,
> +               unsigned int, at_flags,
> +               int, watch_fd,
> +               int, watch_id)
> +{
> +       struct watch_queue *wqueue;
> +       struct watch_list *wlist = NULL;
> +       struct watch *watch;
> +       struct mount *m;
> +       struct path path;
> +       int ret;
> +
> +       if (watch_id < -1 || watch_id > 0xff)
> +               return -EINVAL;
> +
> +       ret = user_path_at(dfd, filename, at_flags, &path);

The third argument of user_path_at() contains kernel-private lookup
flags, I'm pretty sure userspace isn't supposed to be able to control
these directly.

> +       if (ret)
> +               return ret;
> +
> +       wqueue = get_watch_queue(watch_fd);
> +       if (IS_ERR(wqueue))
> +               goto err_path;
> +
> +       m = real_mount(path.mnt);
> +
> +       if (watch_id >= 0) {
> +               if (!m->mnt_watchers) {
> +                       wlist = kzalloc(sizeof(*wlist), GFP_KERNEL);
> +                       if (!wlist)
> +                               goto err_wqueue;
> +                       INIT_HLIST_HEAD(&wlist->watchers);
> +                       spin_lock_init(&wlist->lock);
> +                       wlist->release_watch = release_mount_watch;
> +               }
> +
> +               watch = kzalloc(sizeof(*watch), GFP_KERNEL);
> +               if (!watch)
> +                       goto err_wlist;
> +
> +               init_watch(watch, wqueue);
> +               watch->id               = (unsigned long)path.dentry;
> +               watch->private          = path.mnt;
> +               watch->info_id          = (u32)watch_id << 24;
> +
> +               down_write(&m->mnt.mnt_sb->s_umount);
> +               if (!m->mnt_watchers) {
> +                       m->mnt_watchers = wlist;
> +                       wlist = NULL;
> +               }
> +
> +               ret = add_watch_to_object(watch, m->mnt_watchers);
> +               if (ret == 0) {
> +                       spin_lock(&path.dentry->d_lock);
> +                       path.dentry->d_flags |= DCACHE_MOUNT_WATCH;
> +                       spin_unlock(&path.dentry->d_lock);
> +                       path_get(&path);

So... the watches on a mountpoint create references back to the
mountpoint? Is your plan that umount_tree() breaks the loop by getting
rid of the watches?

If so: Is there anything that prevents installing new watches after
umount_tree()? Because I don't see anything.

It might make sense to redesign this stuff so that watches don't hold
references on the object being watched.

> +               }
> +               up_write(&m->mnt.mnt_sb->s_umount);
> +               if (ret < 0)
> +                       kfree(watch);
> +       } else if (m->mnt_watchers) {
> +               down_write(&m->mnt.mnt_sb->s_umount);
> +               ret = remove_watch_from_object(m->mnt_watchers, wqueue,
> +                                              (unsigned long)path.dentry,
> +                                              false);
> +               up_write(&m->mnt.mnt_sb->s_umount);
> +       } else {
> +               ret = -EBADSLT;
> +       }
> +
> +err_wlist:
> +       kfree(wlist);
> +err_wqueue:
> +       put_watch_queue(wqueue);
> +err_path:
> +       path_put(&path);
> +       return ret;
> +}
