From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Thu, 1 Nov 2018 15:48:05 +0100
Message-ID: <20181101144804.GD23232@redhat.com>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-2-tycho@tycho.ws>
 <20181030143235.GA3385@redhat.com>
 <20181030153231.GB7343@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181030153231.GB7343@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/30, Tycho Andersen wrote:
>
> > I am not sure I understand the value of signaled/SECCOMP_NOTIF_FLAG_SIGNALED...
> > I mean, why it is actually useful?
> >
> > Sorry if this was already discussed.
>
> :) no problem, many people have complained about this. This is an
> implementation of Andy's suggestion here:
> https://lkml.org/lkml/2018/3/15/1122
>
> You can see some more detailed discussion here:
> https://lkml.org/lkml/2018/9/21/138

Cough, sorry, I simply can't understand what are you talking about ;)
It seems that I need to read all the previous emails... So let me ask
a stupid question below.

> > But my main concern is that either way wait_for_completion_killable() allows
> > to trivially create a process which doesn't react to SIGSTOP, not good...
> >
> > Note also that this can happen if, say, both the tracer and tracee run in the
> > same process group and SIGSTOP is sent to their pgid, if the tracer gets the
> > signal first the tracee won't stop.
> >
> > Of freezer. try_to_freeze_tasks() can fail if it freezes the tracer before
> > it does SECCOMP_IOCTL_NOTIF_SEND.
>
> I think in general the way this is intended to be used these things
> wouldn't happen.

Why?

> was malicious and had the ability to create a user namespace to
> exhaust pids this way,

Not sure I understand how this connects to my question... nevermind.

> so perhaps we should drop this part of the
> patch. I have no real need for it, but perhaps Andy can elaborate?

Yes I think it would be nice to avoid wait_for_completion_killable().

So please help me to understand the problem. Once again, why can not
seccomp_do_user_notification() use wait_for_completion_interruptible() only?

This is called before the task actually starts the syscall, so
-ERESTARTNOINTR if signal_pending() can't hurt.

Now lets suppose seccomp_do_user_notification() simply does

	err = wait_for_completion_interruptible(&n.ready);

	if (err < 0 && state != SECCOMP_NOTIFY_REPLIED) {
		syscall_set_return_value(ERESTARTNOINTR);
		list_del(&n.list);
		return -1;
	}

(I am ignoring the locking/etc). Now the obvious problem is that the listener
doing SECCOMP_IOCTL_NOTIF_SEND can't distinguish -ENOENT from the case when the
tracee was killed, yes?

Is it that important?

Any other problem?

Oleg.
