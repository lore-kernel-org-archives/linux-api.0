From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Tue, 13 Oct 2009 04:03:45 +0900 (JST)
Message-ID: <20091013031853.C744.A69D9226@jp.fujitsu.com>
References: <2f11576a0910092332s6e0e3dcs35864e3a2164be0@mail.gmail.com> <3e8340490910100011u17497293o613334c64f1543c8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3e8340490910100011u17497293o613334c64f1543c8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Donlan <bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Timo Sirainen <tss-X3B1VOXEql0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

Sorry for the delaying.

> On Sat, Oct 10, 2009 at 2:32 AM, KOSAKI Motohiro
> <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
>=20
> >> It does seem like a maximum spin count should be put in there - an=
d
> >> maybe a timeout as well (since with FUSE etc it's possible to engi=
neer
> >> page faults that take arbitrarily long).
> >> Also, it occurs to me that:
> >
> > makes sense.
> > I like maximum spin rather than timeout.
>=20
> I'm worried about the scenario where process A sets its cmdline buffe=
r
> to point to a page which will take a _VERY_ long time to pagein (mayb=
e
> forever), and then process B goes to try to read its cmdline. What
> happens now?

Honestly, I don't worry about so much. if attacker want DoS attack, for=
k bomb is
efficient than this way. then, attacker never use this.


> Process A can arrange for this to happen by using a FUSE filesystem
> that sits on a read forever. And since the first thing the admin's
> likely to do to track down the problem is 'ps awux', this is liable t=
o
> be a rather nasty DoS...

Probably, I haven't understand this paragraph. Why is this FUSE related=
 issue?

> Of course, this is no worse than it is now - it's already possible to
> replace the page in question. But we should think about ways this
> could be fixed for good...

Plus, please look my mesurement data as another post. seqlock implement=
ation is very fast
although contention occured.



> >>> + =A0 =A0 do {
> >>> + =A0 =A0 =A0 =A0 =A0 =A0 seq =3D read_seqbegin(&mm->arg_lock);
> >>> +
> >>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D mm->arg_end - mm->arg_start;
> >>> + =A0 =A0 =A0 =A0 =A0 =A0 if (len > PAGE_SIZE)
> >>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D PAGE_SIZE;
> >>
> >> If arg_end or arg_start are modified after this, is it truly safe =
to
> >> assume that len will remain <=3D PAGE_SIZE without a memory barrie=
r
> >> before the conditional?
> >
> > 1) access_process_vm() doesn't return error value.
> > 2) read_seqretry(&mm->arg_lock, seq)) check seq, not mm->arg_start =
or len.
> >
> > then, if arg_{start,end} is modified, access_process_vm() may retur=
n 0
> > and strnlen
> > makes bad calculation, but read_seqretry() can detect its modify
> > rightly. I think.
>=20
> No, I'm worried about what if the compiler decides to rewrite like so=
:
> if (mm->arg_end - mm->arg_start > PAGE_SIZE)
>   len =3D PAGE_SIZE;
> else /* here we reload arg_end/arg_start! */
>   len =3D mm->arg_end - mm->arg_start;
>=20
> Now we might write into buffer more than PAGE_SIZE bytes, which is
> probably a buffer overrun into kernel space...

Rgiht. I'll fix this issue at next spin.
Thank you.
