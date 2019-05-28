From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 4/7] vfs: Add superblock notifications
Date: Tue, 28 May 2019 22:27:47 +0200
Message-ID: <CAG48ez2o1egR13FDd3=CgdXP_MbBsZM4SX=+aqvR6eheWddhFg@mail.gmail.com>
References: <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905934373.7587.10824503964531598726.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155905934373.7587.10824503964531598726.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 6:05 PM David Howells <dhowells@redhat.com> wrote:
> Add a superblock event notification facility whereby notifications about
> superblock events, such as I/O errors (EIO), quota limits being hit
> (EDQUOT) and running out of space (ENOSPC) can be reported to a monitoring
> process asynchronously.  Note that this does not cover vfsmount topology
> changes.  mount_notify() is used for that.
[...]
> +#ifdef CONFIG_SB_NOTIFICATIONS
> +/*
> + * Post superblock notifications.
> + */
> +void post_sb_notification(struct super_block *s, struct superblock_notification *n)
> +{
> +       post_watch_notification(s->s_watchers, &n->watch, current_cred(),
> +                               s->s_unique_id);
> +}

You're using current_cred() here? So the idea is that if some random
process runs into a disk I/O error, the I/O error will come from that
task's credentials? In general, you're not supposed to look at task
credentials in ->read/->write handlers.

> +static void release_sb_watch(struct watch_list *wlist, struct watch *watch)
> +{
> +       struct super_block *s = watch->private;
> +
> +       put_super(s);
> +}
> +
> +/**
> + * sys_sb_notify - Watch for superblock events.
> + * @dfd: Base directory to pathwalk from or fd referring to superblock.
> + * @filename: Path to superblock to place the watch upon
> + * @at_flags: Pathwalk control flags
> + * @watch_fd: The watch queue to send notifications to.
> + * @watch_id: The watch ID to be placed in the notification (-1 to remove watch)
> + */
> +SYSCALL_DEFINE5(sb_notify,
> +               int, dfd,
> +               const char __user *, filename,
> +               unsigned int, at_flags,
> +               int, watch_fd,
> +               int, watch_id)
> +{
> +       struct watch_queue *wqueue;
> +       struct super_block *s;
> +       struct watch_list *wlist = NULL;
> +       struct watch *watch;
> +       struct path path;
> +       int ret;
> +
> +       if (watch_id < -1 || watch_id > 0xff)
> +               return -EINVAL;
> +
> +       ret = user_path_at(dfd, filename, at_flags, &path);

As in the other patch, I don't think userspace is supposed to be able
to supply user_path_at()'s third argument.

It might make sense to require that the path points to the root inode
of the superblock? That way you wouldn't be able to do this on a bind
mount that exposes part of a shared filesystem to a container.

> +       if (ret)
> +               return ret;
> +
> +       wqueue = get_watch_queue(watch_fd);
> +       if (IS_ERR(wqueue))
> +               goto err_path;
> +
> +       s = path.dentry->d_sb;
> +       if (watch_id >= 0) {
> +               if (!s->s_watchers) {
> +                       wlist = kzalloc(sizeof(*wlist), GFP_KERNEL);
> +                       if (!wlist)
> +                               goto err_wqueue;
> +                       INIT_HLIST_HEAD(&wlist->watchers);
> +                       spin_lock_init(&wlist->lock);
> +                       wlist->release_watch = release_sb_watch;
> +               }
> +
> +               watch = kzalloc(sizeof(*watch), GFP_KERNEL);
> +               if (!watch)
> +                       goto err_wlist;
> +
> +               init_watch(watch, wqueue);
> +               watch->id               = s->s_unique_id;
> +               watch->private          = s;
> +               watch->info_id          = (u32)watch_id << 24;
> +
> +               down_write(&s->s_umount);
> +               ret = -EIO;
> +               if (atomic_read(&s->s_active)) {
> +                       if (!s->s_watchers) {
> +                               s->s_watchers = wlist;
> +                               wlist = NULL;
> +                       }
> +
> +                       ret = add_watch_to_object(watch, s->s_watchers);
> +                       if (ret == 0) {
> +                               spin_lock(&sb_lock);
> +                               s->s_count++;
> +                               spin_unlock(&sb_lock);

Why do watches hold references on the superblock they're watching?

> +                       }
> +               }
> +               up_write(&s->s_umount);
> +               if (ret < 0)
> +                       kfree(watch);
> +       } else if (s->s_watchers) {

This should probably have something like a READ_ONCE() for clarity?

> +               down_write(&s->s_umount);
> +               ret = remove_watch_from_object(s->s_watchers, wqueue,
> +                                              s->s_unique_id, false);
> +               up_write(&s->s_umount);
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
> +#endif
