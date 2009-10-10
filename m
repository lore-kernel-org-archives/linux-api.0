From: Bryan Donlan <bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Fri, 9 Oct 2009 22:57:14 -0400
Message-ID: <3e8340490910091957t21eb16e0r63eba2314ddb83a8@mail.gmail.com>
References: <20091009134354.12A7.A69D9226@jp.fujitsu.com> <20091009171344.3fc5f28b.akpm@linux-foundation.org>
	<3e8340490910091922g7891b31al649e91f15ffae687@mail.gmail.com>
	<20091009194250.eb76e338.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091009194250.eb76e338.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 9, 2009 at 10:42 PM, Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:

>> >> + __ __ __ __ __ __ __ __ __ __ __ __ __ __ res +=3D access_proce=
ss_vm(task, mm->env_start,
>
> Your email client is converting tabs to non-ascii crap. =A0gmail. =A0=
Sigh.

Weird ... I'll have to see if I can do something about that :/

> OK.
>
> But there's no way in which the reader of either the patch or the
> resulting code can discover this subtlety.

I didn't write the log message or the code - I just mentioned these
same issues back in the lkml thread :) But yes, this should be
mentioned somewhere.

>> The solution is to use the seqlock to detect this, and prevent the
>> secret information from ever making it back to process B's userspace=
=2E
>> Note that it's not enough to just recheck arg_start, as process A ma=
y
>> reassign the proctitle area back to its original position after havi=
ng
>> it somewhere else for a while.
>
> Well seqlock is _a_ solution. =A0Another is to use a mutex or an rwse=
m
> around the whole operation.
>
> With the code as you propose it, what happens if a process sits in a
> tight loop running setproctitle? =A0Do other processes running `ps' g=
et
> stuck in a livelock until the offending process gets scheduled out?

It does seem like a maximum spin count should be put in there - and
maybe a timeout as well (since with FUSE etc it's possible to engineer
page faults that take arbitrarily long).
Also, it occurs to me that:

> +     do {
> +             seq =3D read_seqbegin(&mm->arg_lock);
> +
> +             len =3D mm->arg_end - mm->arg_start;
> +             if (len > PAGE_SIZE)
> +                     len =3D PAGE_SIZE;

If arg_end or arg_start are modified after this, is it truly safe to
assume that len will remain <=3D PAGE_SIZE without a memory barrier
before the conditional?
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
