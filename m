From: Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Date: Thu, 22 Oct 2009 12:40:10 +0200
Message-ID: <cfd18e0f0910220340n7c655daap78e395136c56f882@mail.gmail.com>
References: <20091013044925.GA28181@us.ibm.com>
	 <20091016042041.GA7220@us.ibm.com>
	 <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>
	 <20091016180631.GA31036@us.ibm.com>
	 <20091019174405.GE27627@count0.beaverton.ibm.com>
	 <4ADCDAA8.5080408@zytor.com>
	 <20091019235012.GF27627@count0.beaverton.ibm.com>
	 <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com>
	 <4ADF06B7.50508@zytor.com> <20091021194440.GA1283@us.ibm.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091021194440.GA1283-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Sukadev,

On Wed, Oct 21, 2009 at 9:44 PM, Sukadev Bhattiprolu
<sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> H. Peter Anvin [hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org] wrote:
>> On 10/21/2009 01:26 PM, Michael Kerrisk wrote:
>>>
>>> My question here is: what does "3" actually mean? In general, syste=
m
>>> calls have not followed any convention of numbering to indicate
>>> successive versions -- clone2() being the one possible exception th=
at
>>> I know of.
>>>
>>
>> "3" is number of arguments.
>
> To me, it is a version number.

See my precending mail. Isn't the number of arguments "2".

> mmap() and mmap2() both have 6 parameters.
>
> Besides if wait4() were born before wait3(), would it still be wait4(=
) :-)
> But I see that it is hard to get one-convention-that-fits-all.

Yes -- that's exactly right.

>> It's better than "extended" or something
>> like that simply because "extended" just means "more than", and a nu=
mber
>> at least tells you *how much more than*.
>
> And extended assumes we wont extend again.

Well, if we do things right in this design, we may not need to ever
extend (by creating a new syscall) again. That's why I mentioned the
"flags" argument idea. Did you give this some thought?

> An informal poll of reviewers has clone3() with a slight advantage :-=
)
>
> =A0 =A0 =A0 =A0clone_extended() camp: Serge Hallyn, Kerrisk, Louis Ri=
lling,
> =A0 =A0 =A0 =A0clone3(): Sukadev, H. Peter Anvin, Oren, Matt Helsley.
>
> I like clone3() but am not insisting on it. I just want a name...

And I'm not really insisting on a change. As you rightly point out,
there is much inconsistency in the naming conventions that have been
used over the years.

But, because there has been no consistency in the use of numbers, and
because the number of arguments that are presented in a glibc
interface may differ from the number of arguments in an underlying
syscall (several precedents: signalfd4(), pselect(), ppoll()), I'm
inclined to think that clonex() or clone_ext() is slighly better than
clone3(). But, certainly, my arguments are not compelling.

Thanks,

Michael

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
