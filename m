From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] prctl: add PR_{GET,SET}_KILL_DESCENDANTS_ON_EXIT
Date: Wed, 28 Nov 2018 09:23:39 -0600
Message-ID: <87r2f5gr9g.fsf@xmission.com>
References: <20181127225408.7553-1-j@bitron.ch>
        <20181127225408.7553-2-j@bitron.ch>
        <20181128144230.GG30395@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181128144230.GG30395@redhat.com> (Oleg Nesterov's message of
        "Wed, 28 Nov 2018 15:42:31 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: =?utf-8?Q?J=C3=BCrg?= Billeter <j@bitron.ch>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 11/27, Jürg Billeter wrote:
>>
>> @@ -704,6 +713,9 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
>>  	struct task_struct *p, *n;
>>  	LIST_HEAD(dead);
>>  
>> +	if (group_dead && tsk->signal->kill_descendants_on_exit)
>> +		walk_process_tree(tsk, kill_descendant_visitor, NULL);
>
> Well, this is not exactly right, at least this is suboptimal in that
> other sub-threads can too call walk_process_tree(kill_descendant_visitor)
> later for no reason.

Oleg I think I am missing something.

Reading kernel/exit.c I see "group_dead = atomic_dec_and_test(&tsk->signal->live)".
Which seems like enough to ensure exactly one task/thread calls walk_process_tree.

Can you explain what I am missing?

Eric
