From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Sat, 24 Apr 2010 11:01:35 -0700
Message-ID: <m11ve4wwzk.fsf@fess.ebiederm.org>
References: <20100421012749.GA21338@us.ibm.com>
	<20100421012908.GB24251@us.ibm.com> <20100421030406.GB10258@kroah.com>
	<20100421034532.GA9254@us.ibm.com> <m1zl0xo1m9.fsf@fess.ebiederm.org>
	<20100424033614.GA4180@us.ibm.com>
	<n2s13426df11004240925id540ed94mc2ebafada0099ec4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <n2s13426df11004240925id540ed94mc2ebafada0099ec4-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org> (ron minnich's message of "Sat\, 24 Apr 2010 09\:25\:08 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ron minnich <rminnich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ashwin Ganti <ashwin.ganti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, rsc-kPPrOchjzlEAvxtiuMwx3w@public.gmane.org, ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jt.beard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, oleg-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

ron minnich <rminnich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> On Fri, Apr 23, 2010 at 8:36 PM, Serge E. Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> w=
rote:
>
>> An fs actually seems overkill for two write-only files for
>> process-related information. =C2=A0Would these actually be candidate=
s
>> for new /proc files?
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0/proc/grantcred - replaces /dev/caphash, =
for privileged
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tasks to tell=
 the kernel about new setuid
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0capabilities
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0/proc/self/usecred - replaces /dev/capuse=
 for unprivileged
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tasks to make=
 use of a setuid capability
>
> An fs is fine.
>
> To relate this to Plan 9, where it all began, might be useful. There'=
s
> no equivalent in Plan 9 to Linux/Unix devices of the major/minor
> number etc. variety. In-kernel drivers and out-of-kernel servers both
> end up providing the services (i.e. file name spaces) that we see in =
a
> Linux file system. So the Plan 9 driver for the capability device
> really does match closely in function and interface to a Linux
> kernel-based file system.
>
> Hence, making devcap a file system is entirely appropriate, because i=
t
> best fits the way it works in Plan 9: a kernel driver that provides
> two files.
>
> It's pretty easy to write a Linux VFS anyway, so it makes sense from
> that point of view.
>
> Eric, that was a great suggestion.

A fs provides user space policy control of naming.  I.e. where the two =
files go.
That can also be a very big deal.  Especially when files are writable.

You have no idea how much I am frustrated by sysfs right now, because
it does not provide userspace policy control and instead mandates a
sometimes inappropriate naming convention.

Eric
