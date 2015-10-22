From: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/23] userfaultfd: wake pending userfaults
Date: Thu, 22 Oct 2015 15:20:15 +0200
Message-ID: <20151022132015.GF19147@redhat.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
 <1431624680-20153-15-git-send-email-aarcange@redhat.com>
 <20151022121056.GB7520@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151022121056.GB7520-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Sanidhya Kashyap <sanidhya.gatech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, zhang.zhanghailiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Dr. David Alan Gilbert" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Huangpeng (Peter)" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 22, 2015 at 02:10:56PM +0200, Peter Zijlstra wrote:
> On Thu, May 14, 2015 at 07:31:11PM +0200, Andrea Arcangeli wrote:
> > @@ -255,21 +259,23 @@ int handle_userfault(struct vm_area_struct *vma, unsigned long address,
> >  	 * through poll/read().
> >  	 */
> >  	__add_wait_queue(&ctx->fault_wqh, &uwq.wq);
> > -	for (;;) {
> > -		set_current_state(TASK_KILLABLE);
> > -		if (!uwq.pending || ACCESS_ONCE(ctx->released) ||
> > -		    fatal_signal_pending(current))
> > -			break;
> > -		spin_unlock(&ctx->fault_wqh.lock);
> > +	set_current_state(TASK_KILLABLE);
> > +	spin_unlock(&ctx->fault_wqh.lock);
> >  
> > +	if (likely(!ACCESS_ONCE(ctx->released) &&
> > +		   !fatal_signal_pending(current))) {
> >  		wake_up_poll(&ctx->fd_wqh, POLLIN);
> >  		schedule();
> > +		ret |= VM_FAULT_MAJOR;
> > +	}
> 
> So what happens here if schedule() spontaneously wakes for no reason?
> 
> I'm not sure enough of userfaultfd semantics to say if that would be
> bad, but the code looks suspiciously like it relies on schedule() not to
> do that; which is wrong.

That would repeat the fault and trigger the DEBUG_VM printk above,
complaining that FAULT_FLAG_ALLOW_RETRY is not set. It is only a
problem for kernel faults (copy_user/get_user_pages*). Userland won't
error out in such a way because userland would return 0 and not
VM_FAULT_RETRY. So it's only required when the task schedule in
TASK_KILLABLE state.

If schedule spontaneously wakes up a task in TASK_KILLABLE state that
would be a bug in the scheduler in my view. Luckily there doesn't seem
to be such a bug, or at least we never experienced it.

Overall this dependency on the scheduler will be lifted soon, as it
must be lifted in order to track the write protect faults, so longer
term this is not a concern and this is not a design issue, but this
remains an implementation detail that avoided to change the arch code
and gup.

If you send a reproducer to show how the current scheduler can wake up
the task in TASK_KILLABLE despite not receiving a wakeup, that would
help too as we never experienced that.

The reason this dependency will be lifted soon is that the userfaultfd
write protect tracking may be armed at any time while the app is
running so we may already be in the middle of a page fault that
returned VM_FAULT_RETRY by the time we arm the write protect
tracking. So longer term the arch page fault and
__get_user_pages_locked must allow handle_userfault() to return
VM_FAULT_RETRY even if FAULT_FLAG_TRIED is set. Then we don't care if
the task is waken.

Waking a task in TASK_KILLABLE state it will still waste CPU so the
scheduler still shouldn't do that. All load balancing works better if
the task isn't running anyway so I can't imagine a good reason for
wanting to run a task in TASK_KILLABLE state before it gets the
wakeup.

Trying to predict that a wakeup is always happening in less time than
it takes to schedule the task out of the CPU, sounds a very CPU
intensive thing to measure and it's probably better to leave those
heuristics in the caller like by spinning on a lock for a while before
blocking.

Thanks,
Andrea
