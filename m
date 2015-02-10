From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: memcg && uaccess (Was: [PATCH 1/2] kernel/fork: handle
	put_user errors for CLONE_CHILD_SETTID/CLEARTID)
Date: Tue, 10 Feb 2015 20:47:43 +0100
Message-ID: <20150210194743.GA17333@redhat.com>
References: <20150206162301.18031.32251.stgit@buzz> <20150206194405.GA13960@redhat.com> <20150206195529.GA15517@redhat.com> <20150206203246.GA16924@redhat.com> <20150210161941.GB11212@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150210161941.GB11212@phnom.home.cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Roman Gushchin <klamm@yandex-team.ru>, Nikita Vetoshkin <nekto0n@yandex-team.ru>, Pavel Emelyanov <xemul@parallels.com>
List-Id: linux-api@vger.kernel.org

On 02/10, Johannes Weiner wrote:
>
> We had reports of systems deadlocking because

Yes, yes, to some degree I understand why it was done this way. Not
that I understand the details of course. Thanks for your explanations.

> > How can a system call know it should return -ENOMEM if put_user() can only
> > return -EFAULT ?
>
> I see the problem, but allocations can not be guaranteed to succeed,
> not even the OOM killer can reliably make progress,

Yes sure,

> So what
> can we do if that allocation fails?  Even if we go the route that
> Linus proposes and make OOM situations more generic and check them on
> *every* return to userspace, the OOM handler at that point might still
> kill a task more suited to free memory than the faulting one, and so
> we still have to communicate the proper error value to the syscall.

Yes. To me this means that if a page fault from kernel-space fails because
of VM_FAULT_OOM the task should be killed in any case. Except we should
obviously exclude gup/kthreads.

We can't retry in this case and (say) schedule_tail() simply can't report
or handle the failure. Imho it would be better to kill the task loudly,
perhaps with a warning.

To avoid the confusion. Of course, it is not that I am trying to simply
add send_sig(SIGKILL) into the failure paths. My only point is that,
whatever we do, the "silent" or misleading failure is worse than SIGKILL.

The application can't really "handle an out of memory situation gracefully"
as the changlelog says. Even if put_user() (and thus syscall) could return
-ENOMEM, this doesn't really matter I think.

> However, I think we could go back to invoking OOM from all allocation
> contexts again as long as we change allocator and OOM killer to not
> wait for individual OOM victims to exit indefinitely (unless it's a
> __GFP_NOFAIL context).  Maybe wait for some time on the first victim
> before moving on to the next one.

perhaps... can't really comment, at least right now.

> What do you think?

So far I only think that this problem is not trivial ;)

Oleg.
