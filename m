From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 7/7] signal: Remove kernel interal si_code magic
Date: Tue, 18 Jul 2017 09:57:09 -0700
Message-ID: <CA+55aFyKsmf+BpYjcH30MGpHTDJ=zgYPx6kwyEB9CXXFxj_xsw@mail.gmail.com>
References: <87o9shg7t7.fsf_-_@xmission.com> <20170718140651.15973-7-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170718140651.15973-7-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Willy Tarreau <w@1wt.eu>, "linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 18, 2017 at 7:06 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> struct siginfo is a union and the kernel since 2.4 has been hiding a union
> tag in the high 16bits of si_code using the values:
> __SI_KILL
> __SI_TIMER
> __SI_POLL
> __SI_FAULT
> __SI_CHLD
> __SI_RT
> __SI_MESGQ
> __SI_SYS
>
> While this looks plausible on the surface, in practice this situation has
> not worked well.

So on the whole I think we just need to do this, but the part I really
hate about this series is still this the siginfo_layout() part.

I can well believe that it is needed for the compat case. siginfo is a
piece of crap crazy type, and re-ordering fields for compat is
something we are always going to have to do.

But for the native case, the *only* reason we do not just copy the
siginfo as-is seems to be that it's just too big, due to other bad
design decisions in siginfo ("let's make sure it's big enough by
allocating 512 bytes for it).

And afaik, absolutely nobody uses more than about 36 bytes of that
512-byte _sifields union (and that one use is SIGILL with three
pointers and three integers and some padding.

So why don't we just say "screw this idiotic layout crap, and just
unconditionally copy that much smaller maximum of bytes"?

Leave that layout thing purely for compat handling.

Yes, yes, there's a couple of small gotchas's:

 - "_sys_private" for posix timers, and it would have to be moved to
the end of the structure so that it doesn't get copied.

 - make sure those 36 bytes are cleared when allocating the siginfo
(this should be trivial) so that we don't leak any other memory.

But on the whole, it looks pretty straightforward to just get rid of
those stupid layout things, and make them purely about compat stuff.

Please?

The si_code stuff clearly needs to be done regardless, so much of this
patch series looks good to me.  But if we're doign this cleanup, can't
we please go that one extra step and get rid of the crazy "let's treat
the union as different types", and just treat it as a largely opaque
thing.

Pretty please?

                  Linus
