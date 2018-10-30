From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Tue, 30 Oct 2018 09:32:31 -0600
Message-ID: <20181030153231.GB7343@cisco>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-2-tycho@tycho.ws>
 <20181030143235.GA3385@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181030143235.GA3385@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Oleg,

On Tue, Oct 30, 2018 at 03:32:36PM +0100, Oleg Nesterov wrote:
> On 10/29, Tycho Andersen wrote:
> >
> > +	/* This is where we wait for a reply from userspace. */
> > +	err = wait_for_completion_interruptible(&n.ready);
> > +	mutex_lock(&match->notify_lock);
> > +
> > +	/*
> > +	 * If the noticiation fd died before we re-acquired the lock, we still
> > +	 * give -ENOSYS.
> > +	 */
> > +	if (!match->notif)
> > +		goto remove_list;
> > +
> > +	/*
> > +	 * Here it's possible we got a signal and then had to wait on the mutex
> > +	 * while the reply was sent, so let's be sure there wasn't a response
> > +	 * in the meantime.
> > +	 */
> > +	if (err < 0 && n.state != SECCOMP_NOTIFY_REPLIED) {
> > +		/*
> > +		 * We got a signal. Let's tell userspace about it (potentially
> > +		 * again, if we had already notified them about the first one).
> > +		 */
> > +		n.signaled = true;
> > +		if (n.state == SECCOMP_NOTIFY_SENT) {
> > +			n.state = SECCOMP_NOTIFY_INIT;
> > +			up(&match->notif->request);
> > +		}
> 
> I am not sure I understand the value of signaled/SECCOMP_NOTIF_FLAG_SIGNALED...
> I mean, why it is actually useful?
> 
> Sorry if this was already discussed.

:) no problem, many people have complained about this. This is an
implementation of Andy's suggestion here:
https://lkml.org/lkml/2018/3/15/1122

You can see some more detailed discussion here:
https://lkml.org/lkml/2018/9/21/138

> > +		wake_up_poll(&match->notif->wqh, EPOLLIN | EPOLLRDNORM);
> > +
> > +		mutex_unlock(&match->notify_lock);
> > +		err = wait_for_completion_killable(&n.ready);
> > +		mutex_lock(&match->notify_lock);
> 
> And it seems that SECCOMP_NOTIF_FLAG_SIGNALED is the only reason why
> seccomp_do_user_notification() doesn't do wait_for_completion_killable() from
> the very beginning.
> 
> But my main concern is that either way wait_for_completion_killable() allows
> to trivially create a process which doesn't react to SIGSTOP, not good...
> 
> Note also that this can happen if, say, both the tracer and tracee run in the
> same process group and SIGSTOP is sent to their pgid, if the tracer gets the
> signal first the tracee won't stop.
> 
> Of freezer. try_to_freeze_tasks() can fail if it freezes the tracer before
> it does SECCOMP_IOCTL_NOTIF_SEND.

I think in general the way this is intended to be used these things
wouldn't happen. Of course, it would be pretty easy for someone who
was malicious and had the ability to create a user namespace to
exhaust pids this way, so perhaps we should drop this part of the
patch. I have no real need for it, but perhaps Andy can elaborate?

Tycho
