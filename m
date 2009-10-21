From: Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Date: Wed, 21 Oct 2009 06:26:16 +0200
Message-ID: <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com>
References: <20091013044925.GA28181@us.ibm.com>
	 <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com>
	 <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>
	 <20091016180631.GA31036@us.ibm.com>
	 <20091019174405.GE27627@count0.beaverton.ibm.com>
	 <4ADCDAA8.5080408@zytor.com>
	 <20091019235012.GF27627@count0.beaverton.ibm.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091019235012.GF27627-52DBMbEzqgQ/wnmkkaCWp/UQ3DHhIser@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2009 at 1:50 AM, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> wro=
te:
> On Tue, Oct 20, 2009 at 06:31:20AM +0900, H. Peter Anvin wrote:
>> On 10/20/2009 02:44 AM, Matt Helsley wrote:
>>>> |
>>>> | I know I'm late to this discussion, but why the name clone3()? I=
t's
>>>> | not consistent with any other convention used fo syscall naming,
>>
>> This assumption, of course, is just plain wrong. =A0Look at the wait
>> system calls, for example. =A0However, when a small integer is used =
like
>> that, it pretty much always reflects numbers of arguments.
>>
>>>> | AFAICS. I think a name like clone_ext() or clonex() (for extende=
d)
>>>> | might make more sense.
>>>>
>>>> Sure, we talked about calling it clone_extended() and I can go bac=
k
>>>> to that.
>>>>
>>>> Only minor concern with that name was if this new call ever needs =
to
>>>> be extended, what would we call it :-). With clone3() we could add=
 a
>>>> real/fake parameter and call it clone4() :-p
>>>
>>> Perhaps clone64 (somewhat like stat64 for example)?
>>>
>>
>> I think that doesn't exactly reflect the nature of the changes.
>
> Yes. Without adopting an impractical encoding scheme it's quite
> unlikely a small number like 3 or 64 could exactly reflect all the
> changes :). I don't think that's a realistic objection though so...
>
>> clone3() is actually pretty good.
>
> I agree.

My question here is: what does "3" actually mean? In general, system
calls have not followed any convention of numbering to indicate
successive versions -- clone2() being the one possible exception that
I know of.

The only other conventions used for numbering new versions of system
calls relates either to arguments size (e.g., 32 versus 64) or to
their number number of arguments (dup2(), dup3(), wait3(), wait4(),
accept4(), eventfd2(), inotify_init1(), epoll_create1(), evetfd2(),
signalfd4()). The former convention makes some sense, but the latter
is rather questionable, for a couple of reasons. One is that the
number of arguments for the system call may change in the future
(several of the newer system calls have a flags argument which could
be used to indeicate the presence of an additional, optional
argument). Another reason that the latter convention is questionable
is that the number of arguments exposed to userspace by glibc may be
different from the number of arguments in the raw syscall. For
example, signafd4() has 4 arguments, but the glibc interface
(signalfd() http://www.kernel.org/doc/man-pages/online/pages/man2/signa=
lfd.2.html)
has 3.

Using the name clone3() follows no historical convention, which is why
it seems unwise to me. Thus my suggestion of clonex() (like e.g.,
adjtimex()), though quite possibly there could be some better name.

Sukadev, you wrote "With clone3() we could add areal/fake parameter
and call it clone4()". This rasies for me the question: should
clone3() have a flags argument, so as to allow these types of
extensions (i.e., not for clone flags, but rather to indicate changes
in the system call interface). Yes, I understand there is a 64-bit
flags in 'struct clone_struct', but I wonder whether there is any
virtue in having an additional flags argument in the base signature of
the function, as per the following:
http://www.kernel.org/doc/man-pages/online/pages/man2/dup3.2.html
http://www.kernel.org/doc/man-pages/online/pages/man2/signalfd4.2.html
http://www.kernel.org/doc/man-pages/online/pages/man2/eventfd2.2.html
see also
http://linux-man-pages.blogspot.com/2008/10/recent-changes-in-file-desc=
riptor.html

By the way, one further thought: why "struct clone_struct"? We know
it's a struct. Therefore, it seems pointless to include that in the
name. Something like "struct clone_args" would seem less redundant and
slightly more meaningful as a name.

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
