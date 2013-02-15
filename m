From: Pedro Alves <palves-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 them from a queue
Date: Fri, 15 Feb 2013 19:53:33 +0000
Message-ID: <511E923D.7050704@redhat.com>
References: <1360768595-31943-1-git-send-email-avagin@openvz.org> <511E8223.6010506@redhat.com> <20130215194356.GA12413@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130215194356.GA12413-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/15/2013 07:43 PM, Oleg Nesterov wrote:
> On 02/15, Pedro Alves wrote:
>>
>> Not sure I'm reading the patch right, but it looks like GDB would
>> be able to use this as alternative to PTRACE_GET_SIGINFO variant
> 
> No, it is different. PTRACE_GETSIGINFO reports the siginfo for the signal
> which was already dequeued (ignoring the fact ->last_siginfo != NULL doesn't
> necessarily mean we report a signal), while this patch allows to look at
> the pending signals which were not reported yet.

Ah, I had assumed queue position 0 would be the dequeued signal.

>> I wouldn't mind if this was added unconditionally
>> instead of wrapped on CONFIG_CHECKPOINT_RESTORE.
> 
> I agree. If you think gdb can use this new feature,  CONFIG_ can go away.

I think so -- we can add a gdb command to dump the list of
pending signals, which I think is something that'd be useful.

> 
>> We'd miss the poke
>> variant, but that looks like something that could be always be added
>> later.
> 
> Yes. _POKE_ or _QUEUE_ or _DEQUEUE_, we can add more features if user-
> space wants them.

-- 
Pedro Alves
