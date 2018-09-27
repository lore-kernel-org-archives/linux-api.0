From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v7 1/6] seccomp: add a return code to trap to userspace
Date: Thu, 27 Sep 2018 17:08:06 -0600
Message-ID: <20180927230806.GI15491@cisco.cisco.com>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-2-tycho@tycho.ws>
 <CAG48ez05LyQOb4pw5H74VhHdQFDEOPLoLuhDPMEqFG7W1hwA_Q@mail.gmail.com>
 <CAGXu5j+uqgCkxaEPoOa_+XSTJBe==bNATCewsqqzwiyKhbLGVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+uqgCkxaEPoOa_+XSTJBe==bNATCewsqqzwiyKhbLGVQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 03:45:11PM -0700, Kees Cook wrote:
> On Thu, Sep 27, 2018 at 2:51 PM, Jann Horn <jannh@google.com> wrote:
> > On Thu, Sep 27, 2018 at 5:11 PM Tycho Andersen <tycho@tycho.ws> wrote:
> >> However, care should be taken to avoid the TOCTOU
> >> +mentioned above in this document: all arguments being read from the tracee's
> >> +memory should be read into the tracer's memory before any policy decisions are
> >> +made. This allows for an atomic decision on syscall arguments.
> >
> > Again, I don't really see how you could get this wrong.
> 
> Doesn't hurt to mention it, IMO.
> 
> >> +static long seccomp_notify_send(struct seccomp_filter *filter,
> >> +                               unsigned long arg)
> >> +{
> >> +       struct seccomp_notif_resp resp = {};
> >> +       struct seccomp_knotif *knotif = NULL;
> >> +       long ret;
> >> +       u16 size;
> >> +       void __user *buf = (void __user *)arg;
> >> +
> >> +       if (copy_from_user(&size, buf, sizeof(size)))
> >> +               return -EFAULT;
> >> +       size = min_t(size_t, size, sizeof(resp));
> >> +       if (copy_from_user(&resp, buf, size))
> >> +               return -EFAULT;
> >> +
> >> +       ret = mutex_lock_interruptible(&filter->notify_lock);
> >> +       if (ret < 0)
> >> +               return ret;
> >> +
> >> +       list_for_each_entry(knotif, &filter->notif->notifications, list) {
> >> +               if (knotif->id == resp.id)
> >> +                       break;
> >> +       }
> >> +
> >> +       if (!knotif || knotif->id != resp.id) {
> >
> > Uuuh, this looks unsafe and wrong. I don't think `knotif` can ever be
> > NULL here. If `filter->notif->notifications` is empty, I think
> > `knotif` will be `container_of(&filter->notif->notifications, struct
> > seccom_knotif, list)` - in other words, you'll have a type confusion,
> > and `knotif` probably points into some random memory in front of
> > `filter->notif`.
> >
> > Am I missing something?
> 
> Oh, good catch. This just needs to be fixed like it's done in
> seccomp_notif_recv (separate cur and knotif).
> 
> >> +static struct file *init_listener(struct task_struct *task,
> >> +                                 struct seccomp_filter *filter)
> >> +{
> >
> > Why does this function take a `task` pointer instead of always
> > accessing `current`? If `task` actually wasn't `current`, I would have
> > concurrency concerns. A comment in seccomp.h even explains:
> >
> >  *          @filter must only be accessed from the context of current as there
> >  *          is no read locking.
> >
> > Unless there's a good reason for it, I would prefer it if this
> > function didn't take a `task` pointer.
> 
> This is to support PTRACE_SECCOMP_NEW_LISTENER.
> 
> But you make an excellent point. Even TSYNC expects to operate only on
> the current thread group. Hmm.
> 
> While the process is stopped by ptrace, we could, in theory, update
> task->seccomp.filter via something like TSYNC.
> 
> So perhaps use:
> 
> mutex_lock_killable(&task->signal->cred_guard_mutex);
> 
> before walking the notify_locks?

This means that all the seccomp/ptrace code probably needs to be
updated for this? I'll try to send patches for this as well as the
return code thing Jann pointed out.

> >
> >> +       struct file *ret = ERR_PTR(-EBUSY);
> >> +       struct seccomp_filter *cur, *last_locked = NULL;
> >> +       int filter_nesting = 0;
> >> +
> >> +       for (cur = task->seccomp.filter; cur; cur = cur->prev) {
> >> +               mutex_lock_nested(&cur->notify_lock, filter_nesting);
> >> +               filter_nesting++;
> >> +               last_locked = cur;
> >> +               if (cur->notif)
> >> +                       goto out;
> >> +       }
> >> +
> >> +       ret = ERR_PTR(-ENOMEM);
> >> +       filter->notif = kzalloc(sizeof(*(filter->notif)), GFP_KERNEL);
> >
> > sizeof(struct notification) instead, to make the code clearer?
> 
> I prefer what Tycho has: I want to allocate an instances of whatever
> filter->notif is.
> 
> Though, let's do the kzalloc outside of the locking, instead?

Yep, sounds good.

> >> +       ret = anon_inode_getfile("seccomp notify", &seccomp_notify_ops,
> >> +                                filter, O_RDWR);
> >> +       if (IS_ERR(ret))
> >> +               goto out;
> >> +
> >> +
> >> +       /* The file has a reference to it now */
> >> +       __get_seccomp_filter(filter);
> >
> > __get_seccomp_filter() has a comment in it that claims "/* Reference
> > count is bounded by the number of total processes. */". I think this
> > change invalidates that comment. I think it should be fine to just
> > remove the comment.
> 
> Update it to "bounded by total processes and notification listeners"?

Will do.

> >> +out:
> >> +       for (cur = task->seccomp.filter; cur; cur = cur->prev) {
> >
> > s/; cur;/; 1;/, or use a while loop instead? If the NULL check fires
> > here, something went very wrong.
> 
> Hm? This is correct. This is how seccomp_run_filters() walks the list too:
> 
>         struct seccomp_filter *f =
>                         READ_ONCE(current->seccomp.filter);
>         ...
>         for (; f; f = f->prev) {
> 
> Especially if we'll be holding the cred_guard_mutex.

There is a last_locked local here though, I think that's what Jann is
pointing out.

Cheers,

Tycho
