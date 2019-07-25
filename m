From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 4/5] pidfd: add CLONE_WAIT_PID
Date: Thu, 25 Jul 2019 13:41:49 +0200
Message-ID: <20190725114148.bgm37lpiqli7g3ti@brauner.io>
References: <20190724144651.28272-1-christian@brauner.io>
 <20190724144651.28272-5-christian@brauner.io>
 <20190725103543.GF4707@redhat.com>
 <20190725104006.7myahvjtnbcgu3in@brauner.io>
 <20190725112503.GG4707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190725112503.GG4707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, joel@joelfernandes.org, tglx@linutronix.de, tj@kernel.org, dhowells@redhat.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, cyphar@cyphar.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, kernel-team@android.com, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 25, 2019 at 01:25:03PM +0200, Oleg Nesterov wrote:
> On 07/25, Christian Brauner wrote:
> >
> > On Thu, Jul 25, 2019 at 12:35:44PM +0200, Oleg Nesterov wrote:
> > >
> > > I have to admit this feature looks a bit exotic to me...
> >
> > It might look like it from the kernels perspective but from the feedback
> > on this when presenting on this userspace has real usecases for this.
> 
> OK...
> 
> but then perhaps we can make PF_WAIT_PID more flexible.

I've changed this to be a property on signal_struct, i.e. a bitfield
entry following the {is,has}_child_subreaper entries.

> 
> Say, we can add the new WXXX wait option and change eligible_child()
> 
> 	if ((p->flags & PF_WAIT_PID) && (wo->options & WXXX))
> 		return 0;
> 
> this way the parent can tell waitid() whether the PF_WAIT_PID tasks should
> be filtered or not.
> 
> And if we do this we can even add PR_SET_WAIT_PID/PR_CLR_WAIT_PID instead
> of the new CLONE_ flag.

Hm, I prefer to not do this.
The idea is that this is a property of the pidfd itself and not of the
waitid() call. And currently, I don't think it makes sense to change
this property at runtime.
What might make sense is to remove this property when a task gets
reparented, i.e. when its parent has died.
