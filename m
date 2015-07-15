From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 20/24] task_diag: Only add VMAs for thread_group leader
Date: Wed, 15 Jul 2015 15:31:07 +0200
Message-ID: <20150715133107.GA20539@redhat.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org> <1436172445-6979-21-git-send-email-avagin@openvz.org> <20150714174703.GA8088@redhat.com> <55A5BF0F.7090808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55A5BF0F.7090808-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/14, David Ahern wrote:
>
> On 7/14/15 1:47 PM, Oleg Nesterov wrote:
>>>
>>>   	if (show_flags & TASK_DIAG_SHOW_VMA) {
>>> +		/* if the request is to dump all threads of all processes
>>> +		 * only show VMAs for group leader.
>>> +		 */
>>> +		if (req->dump_strategy == TASK_DIAG_DUMP_ALL_THREAD &&
>>> +		    !thread_group_leader(tsk))
>>> +			goto done;
>>> +
>>
>> This doesn't look right, group leader can be a zombie with ->mm == NULL,
>
> Seriously?

Yes, the main thread can do sys_exit() / pthread_exit(), although this
is not that common.

> I'll find some way to track whether VMAs have been dumped for
> a pid.

In case I confused you, the thread_group_leader() check and "goto done"
above are fine, just you can't trust tsk->mm, so

>>>   		if (i >= n)
>>>   			err = fill_vma(tsk, skb, cb, &progress, show_flags);
>>
>> so this probably needs something like find_lock_task_mm().
>
> ok.

Yes, you just need to (try) find a subthread with ->mm != NULL if !tsk->mm,
find_lock_task_mm() can help.

Oleg.
