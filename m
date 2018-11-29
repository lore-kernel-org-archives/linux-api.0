From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] prctl: add PR_{GET,SET}_KILL_DESCENDANTS_ON_EXIT
Date: Thu, 29 Nov 2018 13:34:09 +0100
Message-ID: <20181129123409.GA10645@redhat.com>
References: <20181127225408.7553-1-j@bitron.ch>
 <20181127225408.7553-2-j@bitron.ch>
 <20181128144230.GG30395@redhat.com>
 <87r2f5gr9g.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r2f5gr9g.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/28, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > On 11/27, Jürg Billeter wrote:
> >>
> >> @@ -704,6 +713,9 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
> >>  	struct task_struct *p, *n;
> >>  	LIST_HEAD(dead);
> >>
> >> +	if (group_dead && tsk->signal->kill_descendants_on_exit)
> >> +		walk_process_tree(tsk, kill_descendant_visitor, NULL);
> >
> > Well, this is not exactly right, at least this is suboptimal in that
> > other sub-threads can too call walk_process_tree(kill_descendant_visitor)
> > later for no reason.
>
> Oleg I think I am missing something.

No, it is stupid me who can't read,

> Reading kernel/exit.c I see "group_dead = atomic_dec_and_test(&tsk->signal->live)".
> Which seems like enough to ensure exactly one task/thread calls walk_process_tree.

Of course you right, sorry for confusion.

To me it would be more clean to call walk_process_tree(kill_descendant_visitor)
unconditionally in find_new_reaper() right before "if (has_child_subreaper)", but
then we will need to shift read_lock(tasklist) from walk_process_tree().

So I think the patch is mostly fine, the only problem I can see is that
PR_SET_KILL_DESCENDANTS_ON_EXIT can race with PR_SET_CHILD_SUBREAPER, they both
need to update the bits in the same word.

Oleg.
