From: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Date: Mon, 19 Oct 2009 16:50:12 -0700
Message-ID: <20091019235012.GF27627@count0.beaverton.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com> <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com> <20091016180631.GA31036@us.ibm.com> <20091019174405.GE27627@count0.beaverton.ibm.com> <4ADCDAA8.5080408@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4ADCDAA8.5080408-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2009 at 06:31:20AM +0900, H. Peter Anvin wrote:
> On 10/20/2009 02:44 AM, Matt Helsley wrote:
>>> |
>>> | I know I'm late to this discussion, but why the name clone3()? It's
>>> | not consistent with any other convention used fo syscall naming,
>
> This assumption, of course, is just plain wrong.  Look at the wait  
> system calls, for example.  However, when a small integer is used like  
> that, it pretty much always reflects numbers of arguments.
>
>>> | AFAICS. I think a name like clone_ext() or clonex() (for extended)
>>> | might make more sense.
>>>
>>> Sure, we talked about calling it clone_extended() and I can go back
>>> to that.
>>>
>>> Only minor concern with that name was if this new call ever needs to
>>> be extended, what would we call it :-). With clone3() we could add a
>>> real/fake parameter and call it clone4() :-p
>>
>> Perhaps clone64 (somewhat like stat64 for example)?
>>
>
> I think that doesn't exactly reflect the nature of the changes.

Yes. Without adopting an impractical encoding scheme it's quite
unlikely a small number like 3 or 64 could exactly reflect all the
changes :). I don't think that's a realistic objection though so...

> clone3() is actually pretty good.

I agree.

Cheers,
	-Matt Helsley
