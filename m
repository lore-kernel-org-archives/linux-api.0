From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Fri, 2 Nov 2018 12:29:03 +0100
Message-ID: <20181102112903.GB12360@redhat.com>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-2-tycho@tycho.ws>
 <20181030143235.GA3385@redhat.com>
 <20181030153231.GB7343@cisco>
 <20181101144804.GD23232@redhat.com>
 <20181101203328.GI2180@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181101203328.GI2180@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/01, Tycho Andersen wrote:
>
> On Thu, Nov 01, 2018 at 03:48:05PM +0100, Oleg Nesterov wrote:
> >
> > > > But my main concern is that either way wait_for_completion_killable() allows
> > > > to trivially create a process which doesn't react to SIGSTOP, not good...
> > > >
> > > > Note also that this can happen if, say, both the tracer and tracee run in the
> > > > same process group and SIGSTOP is sent to their pgid, if the tracer gets the
> > > > signal first the tracee won't stop.
> > > >
> > > > Of freezer. try_to_freeze_tasks() can fail if it freezes the tracer before
> > > > it does SECCOMP_IOCTL_NOTIF_SEND.
> > >
> > > I think in general the way this is intended to be used these things
> > > wouldn't happen.
> >
> > Why?
>
> The intent is to run the tracer on the host and have it trace
> containers, which would live in a different freezer cgroup, process
> group, etc.

I didn't mean the freezer cgroup, suspend can fail, it does the "global" freeze.
Nevermind.

> > Yes I think it would be nice to avoid wait_for_completion_killable().
> >
> > So please help me to understand the problem. Once again, why can not
> > seccomp_do_user_notification() use wait_for_completion_interruptible() only?
> >
> > This is called before the task actually starts the syscall, so
> > -ERESTARTNOINTR if signal_pending() can't hurt.
>
> The idea was that when the tracee gets a signal, it notifies the
> tracer exactly once, and then waits for the tracer to decide what to
> do. So if we use another wait_for_completion_interruptible(), doesn't
> it just get re-woken immediately because the signal is still pending?

Hmm. I meant that we should use a single wait_for_completion_interruptible().

> > Now lets suppose seccomp_do_user_notification() simply does
> >
> > 	err = wait_for_completion_interruptible(&n.ready);
> >
> > 	if (err < 0 && state != SECCOMP_NOTIFY_REPLIED) {
> > 		syscall_set_return_value(ERESTARTNOINTR);
> > 		list_del(&n.list);
> > 		return -1;
> > 	}
> >
> > (I am ignoring the locking/etc). Now the obvious problem is that the listener
> > doing SECCOMP_IOCTL_NOTIF_SEND can't distinguish -ENOENT from the case when the
> > tracee was killed, yes?
> >
> > Is it that important?
>
> The answer to this question depends on how we want the listener to be
> able to react. For example, if the listener is in the middle of doing
> a mount() on behalf of the task and it gets a signal and we return
> immediately, the listener will complete the mount(), try to respond
> with success and get -ENOENT.

Yes. Should we undo the mount if the tracee is killed?

> If the task handles the signal and
> restarts the mount(), it'll happen twice unless the listener undoes
> it when it sees the -ENOENT.

Yes. But note that we know that if the same tracee sends another notification
it must be the same syscall.

So. If the listener needs to undo mount when the tracee is killed, it should
undo it if it was interrupted too.

If no, the listener can simply "ignore" the next notification and do
SECCOMP_IOCTL_NOTIF_SEND(val = 0, error = 0).

I see no real difference...

> If we send another notification with the
> SIGNALED flag, the listener has a better picture of what's going on,
> which might be nice.

Yes, but this returns us to my my question: Is it that important?

What exactly the listener can do if it gets SECCOMP_NOTIF_FLAG_SIGNALED?

Undo the mount? No. This doesn't differ from the case when the tracee gets
the non-fatal signal right after SECCOMP_NOTIFY_REPLIED.

Oleg.
