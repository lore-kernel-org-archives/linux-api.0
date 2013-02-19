From: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 them from a queue
Date: Tue, 19 Feb 2013 13:39:42 +0400
Message-ID: <CANaxB-yS5pFNBDe8v7jhRDk=zcxavR=Oxn_mD7wD2ygJKjs=fQ@mail.gmail.com>
References: <1360768595-31943-1-git-send-email-avagin@openvz.org>
	<511E8223.6010506@redhat.com>
	<20130215194356.GA12413@redhat.com>
	<511E9480.5070202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511E9480.5070202-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pedro Alves <palves-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2013/2/16 Pedro Alves <palves-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Forgot to reply to this bit:
>
> On 02/15/2013 07:43 PM, Oleg Nesterov wrote:
>>> We'd miss the poke
>>> > variant, but that looks like something that could be always be added
>>> > later.
>> Yes. _POKE_ or _QUEUE_ or _DEQUEUE_, we can add more features if user-
>> space wants them.
>
> In general, IMO, I agree with Roland at https://lkml.org/lkml/2002/12/20/84
> in that it's good to have setters for completeness, so that you can
> change all the state via ptrace that you can read via ptrace.
>
> But I'm not doing any of this work, hence my "could always be
> added later" comment instead of actually requesting it.  But if
> we had it, we could make e.g., gdb inspect the signal queues,
> and then be able to tweak a realtime signal before it is
> delivered.

PTRACE_POKESIGINFO is more complicated than PTRACE_PEEKSIGINFO.
Looks like PTRACE_POKESIGINFO should replace a siginfo with the
specified sequence number. Should it be able to change signo? If it is
able, what to do with signalfd, which already got a notification about
the previous signal?..

My opinion is that it "could always be added later", when we will
understand what exactly we want to have.

>
> --
> Pedro Alves
