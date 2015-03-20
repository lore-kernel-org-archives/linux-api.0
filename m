From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 5/7] clone4: Add a CLONE_AUTOREAP flag to
	automatically reap the child process
Date: Fri, 20 Mar 2015 19:14:04 +0100
Message-ID: <20150320181404.GA26343@redhat.com>
References: <cover.1426376419.git.josh@joshtriplett.org> <6d002995485d446e659105f6931307f3e532ce89.1426376419.git.josh@joshtriplett.org> <20150315145223.GA21887@redhat.com> <20150315171855.GA30620@thin> <20150315195506.GA29475@redhat.com> <20150315233439.GA31890@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150315233439.GA31890@thin>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Thiago Macieira <thiago.macieira@intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Josh,

I am really sorry for delay.

On 03/15, Josh Triplett wrote:
>
> On Sun, Mar 15, 2015 at 08:55:06PM +0100, Oleg Nesterov wrote:
 >
> > It should be per-process simply because this "autoreap" affects the whole
> > process. And the sub-threads are already "autoreap". And these 2 autoreap's
> > semantics differ, we should not confuse them.
>
> Will the approach I suggested, of having clones with CLONE_THREAD
> inherit the autoreap value rather than setting it from CLONE_AUTOREAP,
> implement the semantics you're looking for?

Not sure I understand... CLONE_THREAD should not inherit the autoreap.
A sub-thread is always autoreapable.

> Also, are you suggesting that CLONE_AUTOREAP with CLONE_THREAD should
> produce -EINVAL, or just that it should be ignored?

Yes, I think CLONE_AUTOREAP | CLONE_THREAD should return -EINVAL. But
this all is minor...

The main problem is how/when we should check this "autoreap" without
making this code even more ugly.

I still think we need a preparation patch. I tried to make it today but
failed. Will try again on weekend...


Note that we can't solely rely on do_notify_parent() which (with your patch)
correctly checks !ptrace && autoreap.

Just for example. Please look at __ptrace_detach(). Note that if we add
CLONE_AUTOREAP this needs a fix in any case. The tracee can be "autoreap"
but zombie, because "autoreap" should be ignored until the tracer detaches.
But the "same_thread_group" should not call do_notify_parent() again. So
this needs another check.

And let me quote our discussion from the previous email:

	> > EXCEPT: do we really want SIGCHLD from the exiting child? I think we
	> > do not. I won't really argue though, but this should be discussed and
	> > documented. IIUC, with your patch it is still sent.
	>
	> I think we do, yes.  The caller of clone can already specify what signal
	> they want, including no signal at all.  If they specify a signal
	> (SIGCHLD or otherwise) along with CLONE_AUTOREAP, we can send that
	> signal.

	OK. Agreed.

Yes, I agree...

But the changes in __ptrace_detach() depend on whether we need to send a signal
or not. Either way the changle is simple, but looks ugly. It would be nice to
cleanup this somehow.

Also. I forgot that the kernel always resets ->exit_signal to SIGCHLD on exec
or reparenting. Reparenting is probably fine. But what about exec? Should it
keep ->exit_signal == 0 if "autoreap" ? I think it should not, to avoid the
strange special case.

> > > > And there are ptrace/mt issues,
> > > > it seems. Just for example, we should avoid EXIT_TRACE if autoreap in
> > > > wait_task_zombie() even if we are going to re-notify parent.
> > >
> > > I don't see how EXIT_TRACE can happen in wait_task_zombie if autoreap is
> > > set.  wait_task_zombie does a cmpxchg with exit_state and doesn't
> > > proceed unless exit_state was EXIT_ZOMBIE, and I don't see how we can
> > > ever reach the EXIT_ZOMBIE state if autoreap.
> >
> > Because you again forgot about ptrace ;)

And this too asks for preparation before CLONE_AUTOREAP...

So I'll try to think about this all again on weekend. I'll try very much
to not disappear again ;)

Oleg.
