From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v7 1/6] seccomp: add a return code to trap to userspace
Date: Thu, 27 Sep 2018 17:04:08 -0600
Message-ID: <20180927230408.GH15491@cisco.cisco.com>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-2-tycho@tycho.ws>
 <CAG48ez05LyQOb4pw5H74VhHdQFDEOPLoLuhDPMEqFG7W1hwA_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez05LyQOb4pw5H74VhHdQFDEOPLoLuhDPMEqFG7W1hwA_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: hch@lst.de, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 11:51:40PM +0200, Jann Horn wrote:
> +Christoph Hellwig, Al Viro, fsdevel: For two questions about the poll
> interface (search for "seccomp_notify_poll" and
> "seccomp_notify_release" in the patch)
> 
> @Tycho: FYI, I've gone through all of v7 now, apart from the
> test/sample code. So don't wait for more comments from me before
> sending out v8.

(assuming you meant v8 -> v9) yes thanks for your reviews! Much
appreciated.

> On Thu, Sep 27, 2018 at 5:11 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > This patch introduces a means for syscalls matched in seccomp to notify
> > some other task that a particular filter has been triggered.
> >
> > The motivation for this is primarily for use with containers. For example,
> > if a container does an init_module(), we obviously don't want to load this
> > untrusted code, which may be compiled for the wrong version of the kernel
> > anyway. Instead, we could parse the module image, figure out which module
> > the container is trying to load and load it on the host.
> >
> > As another example, containers cannot mknod(), since this checks
> > capable(CAP_SYS_ADMIN). However, harmless devices like /dev/null or
> > /dev/zero should be ok for containers to mknod, but we'd like to avoid hard
> > coding some whitelist in the kernel. Another example is mount(), which has
> > many security restrictions for good reason, but configuration or runtime
> > knowledge could potentially be used to relax these restrictions.
> 
> Note that in that case, the trusted runtime needs to be in the same
> mount namespace as the container. mount() doesn't work on the mount
> structure of a foreign mount namespace; check_mnt() specifically
> checks for this case, and I think pretty much everything in
> sys_mount() uses that check. So you'd have to join the container's
> mount namespace before forwarding a mount syscall.

Yep, Serge came up with a pretty neat trick that we used in LXD to
accomplish sending mounts to containers, but it requires some
coordination up front.

> > This patch adds functionality that is already possible via at least two
> > other means that I know about, both of which involve ptrace(): first, one
> > could ptrace attach, and then iterate through syscalls via PTRACE_SYSCALL.
> > Unfortunately this is slow, so a faster version would be to install a
> > filter that does SECCOMP_RET_TRACE, which triggers a PTRACE_EVENT_SECCOMP.
> > Since ptrace allows only one tracer, if the container runtime is that
> > tracer, users inside the container (or outside) trying to debug it will not
> > be able to use ptrace, which is annoying. It also means that older
> > distributions based on Upstart cannot boot inside containers using ptrace,
> > since upstart itself uses ptrace to start services.
> >
> > The actual implementation of this is fairly small, although getting the
> > synchronization right was/is slightly complex.
> >
> > Finally, it's worth noting that the classic seccomp TOCTOU of reading
> > memory data from the task still applies here,
> 
> Actually, it doesn't, right? It would apply if you told the kernel "go
> ahead, that syscall is fine", but that's not how the API works - you
> always intercept the syscall, copy argument data to a trusted tracer,
> and then the tracer can make a replacement syscall. Sounds fine to me.

Right, I guess the point here is just "you need to copy all the data
to the tracer *before* making a policy decision".

> > but can be avoided with
> > careful design of the userspace handler: if the userspace handler reads all
> > of the task memory that is necessary before applying its security policy,
> > the tracee's subsequent memory edits will not be read by the tracer.
> [...]
> > diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
> [...]
> > +which (on success) will return a listener fd for the filter, which can then be
> > +passed around via ``SCM_RIGHTS`` or similar. Alternatively, a filter fd can be
> > +acquired via:
> > +
> > +.. code-block::
> > +
> > +    fd = ptrace(PTRACE_SECCOMP_NEW_LISTENER, pid, 0);
> 
> The manpage documents ptrace() as taking four arguments, not three. I
> know that the header defines it with varargs, but it would probably be
> more useful to require passing in zero as the fourth argument so that
> we have a place to stick flags if necessary in the future.

Yep, I'll fix this, thanks. But also this documentation should really
live in the seccomp patch; some rebase got screwed up somewhere.

> > +which grabs the 0th filter for some task which the tracer has privilege over.
> > +Note that filter fds correspond to a particular filter, and not a particular
> > +task. So if this task then forks, notifications from both tasks will appear on
> > +the same filter fd. Reads and writes to/from a filter fd are also synchronized,
> > +so a filter fd can safely have many readers.
> 
> Add a note about needing CAP_SYS_ADMIN here? Also, might be useful to
> clarify in which direction "nth filter" counts.

Will do.

> > +The interface for a seccomp notification fd consists of two structures:
> > +
> > +.. code-block::
> > +
> > +    struct seccomp_notif {
> > +        __u16 len;
> > +        __u64 id;
> > +        pid_t pid;
> > +        __u8 signalled;
> > +        struct seccomp_data data;
> > +    };
> > +
> > +    struct seccomp_notif_resp {
> > +        __u16 len;
> > +        __u64 id;
> > +        __s32 error;
> > +        __s64 val;
> > +    };
> > +
> > +Users can read via ``ioctl(SECCOMP_NOTIF_RECV)``  (or ``poll()``) on a seccomp
> > +notification fd to receive a ``struct seccomp_notif``, which contains five
> > +members: the input length of the structure, a unique-per-filter ``id``, the
> > +``pid`` of the task which triggered this request (which may be 0 if the task is
> > +in a pid ns not visible from the listener's pid namespace), a flag representing
> > +whether or not the notification is a result of a non-fatal signal, and the
> > +``data`` passed to seccomp. Userspace can then make a decision based on this
> > +information about what to do, and ``ioctl(SECCOMP_NOTIF_SEND)`` a response,
> > +indicating what should be returned to userspace. The ``id`` member of ``struct
> > +seccomp_notif_resp`` should be the same ``id`` as in ``struct seccomp_notif``.
> > +
> > +It is worth noting that ``struct seccomp_data`` contains the values of register
> > +arguments to the syscall, but does not contain pointers to memory. The task's
> > +memory is accessible to suitably privileged traces via ``ptrace()`` or
> > +``/proc/pid/map_files/``.
> 
> You probably don't actually want to use /proc/pid/map_files here; you
> can't use that to access anonymous memory, and it needs CAP_SYS_ADMIN.
> And while reading memory via ptrace() is possible, the interface is
> really ugly (e.g. you can only read data in 4-byte chunks), and your
> caveat about locking out other ptracers (or getting locked out by
> them) applies. I'm not even sure if you could read memory via ptrace
> while a process is stopped in the seccomp logic? PTRACE_PEEKDATA
> requires the target to be in a __TASK_TRACED state.
> The two interfaces you might want to use instead are /proc/$pid/mem
> and process_vm_{readv,writev}, which allow you to do nice,
> arbitrarily-sized, vectored IO on the memory of another process.

Yes, in fact the sample code does use /proc/$pid/mem, but the docs
should be correct :)

> > +       /*
> > +        * Here it's possible we got a signal and then had to wait on the mutex
> > +        * while the reply was sent, so let's be sure there wasn't a response
> > +        * in the meantime.
> > +        */
> > +       if (err < 0 && n.state != SECCOMP_NOTIFY_REPLIED) {
> > +               /*
> > +                * We got a signal. Let's tell userspace about it (potentially
> > +                * again, if we had already notified them about the first one).
> > +                */
> > +               n.signaled = true;
> > +               if (n.state == SECCOMP_NOTIFY_SENT) {
> > +                       n.state = SECCOMP_NOTIFY_INIT;
> > +                       up(&match->notif->request);
> > +               }
> 
> Do you need another wake_up_poll() here?

Yes! Good point.

> > +               mutex_unlock(&match->notify_lock);
> > +               err = wait_for_completion_killable(&n.ready);
> > +               mutex_lock(&match->notify_lock);
> > +               if (err < 0)
> > +                       goto remove_list;
> 
> Add a comment here explaining that we intentionally leave the
> semaphore count too high (because otherwise we'd have to block), and
> seccomp_notify_recv() compensates for that?

Will do.

> > +       }
> > +
> > +       ret = n.val;
> > +       err = n.error;
> > +
> > +remove_list:
> > +       list_del(&n.list);
> > +out:
> > +       mutex_unlock(&match->notify_lock);
> > +       syscall_set_return_value(current, task_pt_regs(current),
> > +                                err, ret);
> > +}
> > +
> >  static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
> >                             const bool recheck_after_trace)
> >  {
> [...]
> >  #ifdef CONFIG_SECCOMP_FILTER
> > +static struct file *init_listener(struct task_struct *,
> > +                                 struct seccomp_filter *);
> > +
> >  /**
> >   * seccomp_set_mode_filter: internal function for setting seccomp filter
> >   * @flags:  flags to change filter behavior
> > @@ -853,6 +1000,8 @@ static long seccomp_set_mode_filter(unsigned int flags,
> >         const unsigned long seccomp_mode = SECCOMP_MODE_FILTER;
> >         struct seccomp_filter *prepared = NULL;
> >         long ret = -EINVAL;
> > +       int listener = 0;
> > +       struct file *listener_f = NULL;
> >
> >         /* Validate flags. */
> >         if (flags & ~SECCOMP_FILTER_FLAG_MASK)
> > @@ -863,13 +1012,28 @@ static long seccomp_set_mode_filter(unsigned int flags,
> >         if (IS_ERR(prepared))
> >                 return PTR_ERR(prepared);
> >
> > +       if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
> > +               listener = get_unused_fd_flags(0);
> > +               if (listener < 0) {
> > +                       ret = listener;
> > +                       goto out_free;
> > +               }
> > +
> > +               listener_f = init_listener(current, prepared);
> > +               if (IS_ERR(listener_f)) {
> > +                       put_unused_fd(listener);
> > +                       ret = PTR_ERR(listener_f);
> > +                       goto out_free;
> > +               }
> > +       }
> > +
> >         /*
> >          * Make sure we cannot change seccomp or nnp state via TSYNC
> >          * while another thread is in the middle of calling exec.
> >          */
> >         if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
> >             mutex_lock_killable(&current->signal->cred_guard_mutex))
> > -               goto out_free;
> > +               goto out_put_fd;
> >
> >         spin_lock_irq(&current->sighand->siglock);
> >
> > @@ -887,6 +1051,16 @@ static long seccomp_set_mode_filter(unsigned int flags,
> >         spin_unlock_irq(&current->sighand->siglock);
> >         if (flags & SECCOMP_FILTER_FLAG_TSYNC)
> >                 mutex_unlock(&current->signal->cred_guard_mutex);
> > +out_put_fd:
> > +       if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
> > +               if (ret < 0) {
> > +                       fput(listener_f);
> > +                       put_unused_fd(listener);
> > +               } else {
> > +                       fd_install(listener, listener_f);
> > +                       ret = listener;
> > +               }
> > +       }
> >  out_free:
> >         seccomp_filter_free(prepared);
> >         return ret;
> [...]
> > +
> > +#ifdef CONFIG_SECCOMP_FILTER
> > +static int seccomp_notify_release(struct inode *inode, struct file *file)
> > +{
> > +       struct seccomp_filter *filter = file->private_data;
> > +       struct seccomp_knotif *knotif;
> > +
> > +       mutex_lock(&filter->notify_lock);
> > +
> > +       /*
> > +        * If this file is being closed because e.g. the task who owned it
> > +        * died, let's wake everyone up who was waiting on us.
> > +        */
> > +       list_for_each_entry(knotif, &filter->notif->notifications, list) {
> > +               if (knotif->state == SECCOMP_NOTIFY_REPLIED)
> > +                       continue;
> > +
> > +               knotif->state = SECCOMP_NOTIFY_REPLIED;
> > +               knotif->error = -ENOSYS;
> > +               knotif->val = 0;
> > +
> > +               complete(&knotif->ready);
> > +       }
> > +
> > +       wake_up_all(&filter->notif->wqh);
> 
> If select() is polling us, a reference to the open file is being held,
> and this can't be reached; and I think if epoll is polling us,
> eventpoll_release() will remove itself from the wait queue, right? So
> can this wake_up_all() actually ever notify anyone?

I don't know actually, I just thought better safe than sorry. I can
drop it, though.

> > +       kfree(filter->notif);
> > +       filter->notif = NULL;
> > +       mutex_unlock(&filter->notify_lock);
> > +       __put_seccomp_filter(filter);
> > +       return 0;
> > +}
> > +
> > +static long seccomp_notify_recv(struct seccomp_filter *filter,
> > +                               unsigned long arg)
> > +{
> > +       struct seccomp_knotif *knotif = NULL, *cur;
> > +       struct seccomp_notif unotif = {};
> > +       ssize_t ret;
> > +       u16 size;
> > +       void __user *buf = (void __user *)arg;
> > +
> > +       if (copy_from_user(&size, buf, sizeof(size)))
> > +               return -EFAULT;
> > +
> > +       ret = down_interruptible(&filter->notif->request);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       mutex_lock(&filter->notify_lock);
> > +       list_for_each_entry(cur, &filter->notif->notifications, list) {
> > +               if (cur->state == SECCOMP_NOTIFY_INIT) {
> > +                       knotif = cur;
> > +                       break;
> > +               }
> > +       }
> > +
> > +       /*
> > +        * If we didn't find a notification, it could be that the task was
> > +        * interrupted between the time we were woken and when we were able to
> 
> s/interrupted/interrupted by a fatal signal/ ?
> 
> > +        * acquire the rw lock.
> 
> State more explicitly here that we are compensating for an incorrectly
> high semaphore count?

Will do, thanks.

> > +        */
> > +       if (!knotif) {
> > +               ret = -ENOENT;
> > +               goto out;
> > +       }
> > +
> > +       size = min_t(size_t, size, sizeof(unotif));
> > +
> > +       unotif.len = size;
> > +       unotif.id = knotif->id;
> > +       unotif.pid = task_pid_vnr(knotif->task);
> > +       unotif.signaled = knotif->signaled;
> > +       unotif.data = *(knotif->data);
> > +
> > +       if (copy_to_user(buf, &unotif, size)) {
> > +               ret = -EFAULT;
> > +               goto out;
> > +       }
> > +
> > +       ret = size;
> > +       knotif->state = SECCOMP_NOTIFY_SENT;
> > +       wake_up_poll(&filter->notif->wqh, EPOLLOUT | EPOLLWRNORM);
> > +
> > +
> > +out:
> > +       mutex_unlock(&filter->notify_lock);
> > +       return ret;
> > +}
> > +
> > +static long seccomp_notify_send(struct seccomp_filter *filter,
> > +                               unsigned long arg)
> > +{
> > +       struct seccomp_notif_resp resp = {};
> > +       struct seccomp_knotif *knotif = NULL;
> > +       long ret;
> > +       u16 size;
> > +       void __user *buf = (void __user *)arg;
> > +
> > +       if (copy_from_user(&size, buf, sizeof(size)))
> > +               return -EFAULT;
> > +       size = min_t(size_t, size, sizeof(resp));
> > +       if (copy_from_user(&resp, buf, size))
> > +               return -EFAULT;
> > +
> > +       ret = mutex_lock_interruptible(&filter->notify_lock);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       list_for_each_entry(knotif, &filter->notif->notifications, list) {
> > +               if (knotif->id == resp.id)
> > +                       break;
> > +       }
> > +
> > +       if (!knotif || knotif->id != resp.id) {
> 
> Uuuh, this looks unsafe and wrong. I don't think `knotif` can ever be
> NULL here. If `filter->notif->notifications` is empty, I think
> `knotif` will be `container_of(&filter->notif->notifications, struct
> seccom_knotif, list)` - in other words, you'll have a type confusion,
> and `knotif` probably points into some random memory in front of
> `filter->notif`.
> 
> Am I missing something?

No, I just flubbed the list API.

> > +               ret = -ENOENT;
> > +               goto out;
> > +       }
> > +
> > +       /* Allow exactly one reply. */
> > +       if (knotif->state != SECCOMP_NOTIFY_SENT) {
> > +               ret = -EINPROGRESS;
> > +               goto out;
> > +       }
> 
> This means that if seccomp_do_user_notification() has in the meantime
> received a signal and transitioned from SENT back to INIT, this will
> fail, right? So we fail here, then we read the new notification, and
> then we can retry SECCOMP_NOTIF_SEND? Is that intended?

I think so, the idea being that you might want to do something
different if a signal was sent. But Andy seemed to think that we might
not actually do anything different.

Either way, for the case you describe, EINPROGRESS is a little weird.
Perhaps it should be:

if (knotif->state == SECCOMP_NOTIFY_INIT) {
        ret = -EBUSY; /* or something? */
        goto out;
} else if (knotif->state == SECCOMP_NOTIFY_REPLIED) {
        ret = -EINPROGRESS;
        goto out;
}

?

> > +       ret = size;
> > +       knotif->state = SECCOMP_NOTIFY_REPLIED;
> > +       knotif->error = resp.error;
> > +       knotif->val = resp.val;
> > +       complete(&knotif->ready);
> > +out:
> > +       mutex_unlock(&filter->notify_lock);
> > +       return ret;
> > +}
> > +
> > +static long seccomp_notify_id_valid(struct seccomp_filter *filter,
> > +                                   unsigned long arg)
> > +{
> > +       struct seccomp_knotif *knotif = NULL;
> > +       void __user *buf = (void __user *)arg;
> > +       u64 id;
> > +       long ret;
> > +
> > +       if (copy_from_user(&id, buf, sizeof(id)))
> > +               return -EFAULT;
> > +
> > +       ret = mutex_lock_interruptible(&filter->notify_lock);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       ret = -1;
> 
> In strace, this is going to show up as EPERM. Maybe use something like
> -ENOENT instead? Or whatever you think resembles a fitting error
> number.

Yep, will do.

> > +       list_for_each_entry(knotif, &filter->notif->notifications, list) {
> > +               if (knotif->id == id) {
> > +                       ret = 0;
> 
> Would it make sense to treat notifications that have already been
> replied to as invalid?

I suppose so, since we aren't going to let you reply to them anyway.

> > +                       goto out;
> > +               }
> > +       }
> > +
> > +out:
> > +       mutex_unlock(&filter->notify_lock);
> > +       return ret;
> > +}
> > +
> [...]
> > +static __poll_t seccomp_notify_poll(struct file *file,
> > +                                   struct poll_table_struct *poll_tab)
> > +{
> > +       struct seccomp_filter *filter = file->private_data;
> > +       __poll_t ret = 0;
> > +       struct seccomp_knotif *cur;
> > +
> > +       poll_wait(file, &filter->notif->wqh, poll_tab);
> > +
> > +       ret = mutex_lock_interruptible(&filter->notify_lock);
> > +       if (ret < 0)
> > +               return ret;
> 
> Looking at the callers of vfs_poll(), as far as I can tell, a poll
> handler is not allowed to return error codes. Perhaps someone who
> knows the poll interface better can weigh in here. I've CCed some
> people who should hopefully know better how this stuff works.

Thanks.

> > +       list_for_each_entry(cur, &filter->notif->notifications, list) {
> > +               if (cur->state == SECCOMP_NOTIFY_INIT)
> > +                       ret |= EPOLLIN | EPOLLRDNORM;
> > +               if (cur->state == SECCOMP_NOTIFY_SENT)
> > +                       ret |= EPOLLOUT | EPOLLWRNORM;
> > +               if (ret & EPOLLIN && ret & EPOLLOUT)
> > +                       break;
> > +       }
> > +
> > +       mutex_unlock(&filter->notify_lock);
> > +
> > +       return ret;
> > +}
> > +
> > +static const struct file_operations seccomp_notify_ops = {
> > +       .poll = seccomp_notify_poll,
> > +       .release = seccomp_notify_release,
> > +       .unlocked_ioctl = seccomp_notify_ioctl,
> > +};
> > +
> > +static struct file *init_listener(struct task_struct *task,
> > +                                 struct seccomp_filter *filter)
> > +{
> 
> Why does this function take a `task` pointer instead of always
> accessing `current`? If `task` actually wasn't `current`, I would have
> concurrency concerns. A comment in seccomp.h even explains:
> 
>  *          @filter must only be accessed from the context of current as there
>  *          is no read locking.
> 
> Unless there's a good reason for it, I would prefer it if this
> function didn't take a `task` pointer.

I think Kees replied already, but yes, this is a good point :(. We can
continue in his thread.

> > +       struct file *ret = ERR_PTR(-EBUSY);
> > +       struct seccomp_filter *cur, *last_locked = NULL;
> > +       int filter_nesting = 0;
> > +
> > +       for (cur = task->seccomp.filter; cur; cur = cur->prev) {
> > +               mutex_lock_nested(&cur->notify_lock, filter_nesting);
> > +               filter_nesting++;
> > +               last_locked = cur;
> > +               if (cur->notif)
> > +                       goto out;
> > +       }
> > +
> > +       ret = ERR_PTR(-ENOMEM);
> > +       filter->notif = kzalloc(sizeof(*(filter->notif)), GFP_KERNEL);
> 
> sizeof(struct notification) instead, to make the code clearer?
> 
> > +       if (!filter->notif)
> > +               goto out;
> > +
> > +       sema_init(&filter->notif->request, 0);
> > +       INIT_LIST_HEAD(&filter->notif->notifications);
> > +       filter->notif->next_id = get_random_u64();
> > +       init_waitqueue_head(&filter->notif->wqh);
> 
> Nit: next_id and notifications are declared in reverse order in the
> struct. Could you flip them around here?

Sure, will do.

> > +       ret = anon_inode_getfile("seccomp notify", &seccomp_notify_ops,
> > +                                filter, O_RDWR);
> > +       if (IS_ERR(ret))
> > +               goto out;
> > +
> > +
> > +       /* The file has a reference to it now */
> > +       __get_seccomp_filter(filter);
> 
> __get_seccomp_filter() has a comment in it that claims "/* Reference
> count is bounded by the number of total processes. */". I think this
> change invalidates that comment. I think it should be fine to just
> remove the comment.

Will do, thanks.

> > +out:
> > +       for (cur = task->seccomp.filter; cur; cur = cur->prev) {
> 
> s/; cur;/; 1;/, or use a while loop instead? If the NULL check fires
> here, something went very wrong.

I suppose so, given that we have last_locked.

Tycho
