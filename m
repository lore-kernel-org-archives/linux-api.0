From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 1/4] seccomp: add a return code to trap to userspace
Date: Fri, 22 Jun 2018 03:28:24 +0200
Message-ID: <CAG48ez1Wob-CrbrPfgP_OBoG7zas4bJwFdLFFQLtgQAkj+HEOQ@mail.gmail.com>
References: <20180621220416.5412-1-tycho@tycho.ws> <20180621220416.5412-2-tycho@tycho.ws>
 <CAG48ez2-vK57HfbRs94YLiz3SVJ7u4tTrxtAmbRepDqk6m-c_A@mail.gmail.com> <20180622005829.GK3992@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180622005829.GK3992@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, "Tobin C. Harding" <me@tobin.cc>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 22, 2018 at 2:58 AM Tycho Andersen <tycho@tycho.ws> wrote:
>
> On Fri, Jun 22, 2018 at 01:21:47AM +0200, Jann Horn wrote:
> > On Fri, Jun 22, 2018 at 12:05 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > >
> > > This patch introduces a means for syscalls matched in seccomp to notify
> > > some other task that a particular filter has been triggered.
> > [...]
> > > +Userspace Notification
> > > +======================
> > > +
> > > +The ``SECCOMP_RET_USER_NOTIF`` return code lets seccomp filters pass a
> > > +particular syscall to userspace to be handled. This may be useful for
> > > +applications like container managers, which whish to intercept particular
> >
> > typo: "wish"
> >
> > [...]
> > > +passed around via ``SCM_RIGHTS`` or similar. Alternativley, a filter fd can be
> >
> > typo: "Alternatively"
> >
> > [...]
> > > +It is worth noting that ``struct seccomp_data`` contains the values of register
> > > +arguments to the syscall, but does not contain pointers to memory. The task's
> > > +memory is accessiable to suitably privileged traces via via ``ptrace()`` or
> >
> > Typo: "accessible"
>
> Thanks!
>
> > [...]
> > > +
> > > +static void seccomp_do_user_notification(int this_syscall,
> > > +                                        struct seccomp_filter *match,
> > > +                                        const struct seccomp_data *sd)
> > > +{
> > > +       int err;
> > > +       long ret = 0;
> > > +       struct seccomp_knotif n = {};
> > > +
> > > +       mutex_lock(&match->notify_lock);
> > > +       err = -ENOSYS;
> > > +       if (!match->has_listener)
> > > +               goto out;
> > > +
> > > +       n.pid = task_pid(current);
> > > +       n.state = SECCOMP_NOTIFY_INIT;
> > > +       n.data = sd;
> > > +       n.id = seccomp_next_notify_id(match);
> > > +       init_completion(&n.ready);
> > > +
> > > +       list_add(&n.list, &match->notifications);
> > > +       wake_up_poll(&match->wqh, EPOLLIN | EPOLLRDNORM);
> > > +
> > > +       mutex_unlock(&match->notify_lock);
> > > +       up(&match->request);
> > > +
> > > +       err = wait_for_completion_interruptible(&n.ready);
> > > +       mutex_lock(&match->notify_lock);
> > > +
> > > +       /*
> > > +        * Here it's possible we got a signal and then had to wait on the mutex
> > > +        * while the reply was sent, so let's be sure there wasn't a response
> > > +        * in the meantime.
> > > +        */
> > > +       if (err < 0 && n.state != SECCOMP_NOTIFY_REPLIED) {
> > > +               /*
> > > +                * We got a signal. Let's tell userspace about it (potentially
> > > +                * again, if we had already notified them about the first one).
> > > +                */
> > > +               if (n.state == SECCOMP_NOTIFY_SENT) {
> > > +                       n.state = SECCOMP_NOTIFY_INIT;
> > > +                       up(&match->request);
> > > +               }
> > > +               mutex_unlock(&match->notify_lock);
> > > +               err = wait_for_completion_killable(&n.ready);
> >
> > Does this mean that when you get a signal that isn't SIGKILL,
> > wait_for_completion_interruptible() will bail out with -ERESTARTSYS,
> > but then you hang on this wait_for_completion_killable()? I don't
> > understand what's going on here. What's the point of using
> > wait_for_completion_interruptible() when you'll just hang on another
> > wait on the same "struct completion"?
>
> This is the implementation of this suggestion by Andy:
> https://lkml.org/lkml/2018/3/15/1122
>
> The idea is to alert the listener that there was a signal exactly
> once, in case it's in the middle of processing a request it could bail
> out and do something else. So the killable wait is intended to ignore
> other (non-fatal) signals after the first one and wait for whatever
> the handler decides to do with the signal it received.

How can the listener tell that a signal arrived? When the first
non-fatal signal comes in, you just set the state to
SECCOMP_NOTIFY_INIT if it was SECCOMP_NOTIFY_SENT, right? So the
listener will potentially see the request twice, but with no
additional indicator that a signal arrived? And in particular, if the
listener doesn't read the request before the signal arrives, it will
only see the request once, just as if it was a normal request with no
signals involved?

Would it perhaps make sense to add a field to struct seccomp_notif
that indicates whether the notification is for a normal syscall or a
canceled syscall?
