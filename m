From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 4/5] pidfd: add CLONE_WAIT_PID
Date: Thu, 25 Jul 2019 12:40:06 +0200
Message-ID: <20190725104006.7myahvjtnbcgu3in@brauner.io>
References: <20190724144651.28272-1-christian@brauner.io>
 <20190724144651.28272-5-christian@brauner.io>
 <20190725103543.GF4707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190725103543.GF4707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, joel@joelfernandes.org, tglx@linutronix.de, tj@kernel.org, dhowells@redhat.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, cyphar@cyphar.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, kernel-team@android.com, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 25, 2019 at 12:35:44PM +0200, Oleg Nesterov wrote:
> On 07/24, Christian Brauner wrote:
> >
> > If CLONE_WAIT_PID is set the newly created process will not be
> > considered by process wait requests that wait generically on children
> > such as:
> 
> I have to admit this feature looks a bit exotic to me...

It might look like it from the kernels perspective but from the feedback
on this when presenting on this userspace has real usecases for this.

> 
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -1019,6 +1019,9 @@ eligible_child(struct wait_opts *wo, bool ptrace, struct task_struct *p)
> >  	if (!eligible_pid(wo, p))
> >  		return 0;
> >
> > +	if ((p->flags & PF_WAIT_PID) && (wo->wo_type != PIDTYPE_PID))
> > +		return 0;
> 
> Even if ptrace == T ?
> 
> This doesn't look right. Say, strace should work even if its tracee (or
> one of the tracees) has PF_WAIT_PID.

As in
	if (!ptrace && (p->flags & PF_WAIT_PID) && (wo->wo_type != PIDTYPE_PID))
		return 0;

Sure, we can allow that.

Christian
