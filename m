From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Fri, 12 May 2017 23:57:55 +0100
Message-ID: <20170512225755.GU390@ZenIV.linux.org.uk>
References: <CAGXu5j+EatK=DYONRkgovwLgytAnbG8jnAZaMSLckZFNVj3gig@mail.gmail.com>
 <20170512075458.09a3a1ce@mschwideX1>
 <CAGXu5jL9vUrn4kpjO+qa4cHmWBypeqP17OGbrMs=5Nz0YpQMZw@mail.gmail.com>
 <CA+55aFzbiBqsYb7vwO=+L4Vp_GOgPu+DBOrq4fBnyzq5DbBehg@mail.gmail.com>
 <CAGXu5j+xmyJ6RhtPw9rUgs7k3sZ1KKWffvyGGG--oPfu9W42ng@mail.gmail.com>
 <20170512202106.GO22219@n2100.armlinux.org.uk>
 <20170512210645.GS390@ZenIV.linux.org.uk>
 <CAGXu5jJu=VTqp2tzkPB4RAVxdGC+_SSQwrUwdzWpu24AA-zEcg@mail.gmail.com>
 <20170512214144.GT390@ZenIV.linux.org.uk>
 <1494625675.29205.21.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494625675.29205.21.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-s390 <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Catalin
List-Id: linux-api@vger.kernel.org

On Fri, May 12, 2017 at 05:47:55PM -0400, Rik van Riel wrote:

> > Seriously, look at these beasts.  Overwriting ->addr_limit is nowhere
> > near
> > the top threat.  If attacker can overwrite thread_info, you have
> > lost.
> 
> That is why THREAD_INFO_IN_TASK exists. It moves
> the struct thread_info to a location away from the
> stack, which means a stack overflow will not overwrite
> the thread_info.

... in which case such attacks on ->addr_limit also become a non-issue.

AFAICS, we are mixing several unrelated issues here:
	* amount of places where set_fs() is called.  Sure, reducing it
is a good idea and we want to move to primitives like kernel_write() et.al.
Fewer users => lower odds of screwing it up.
	* making sure that remaining callers are properly paired.  Ditto.
	* switching to ->read_iter()/->write_iter() where it makes sense.
Again, no problem with that.
	* providing sane environment for places like perf/oprofile.  Again,
a good idea, and set_fs(USER_DS) is only a part of what's needed there.
	* switching _everything_ to ->read_iter()/->write_iter().  Flat-out
insane and AFAICS nobody is signing up for that.
	* getting rid of set_fs() entirely.  I'm afraid that it's not feasible
without the previous one and frankly, I don't see much point.
	* sanity-checking on return to userland.  Maybe useful, maybe not.
	* taking thread_info out of the way of stack overflows.  Reasonable,
but has very little to do with the rest of that.
	* protecting against Lovecraftian horrors slithering in from the outer
space only to commit unspeakable acts against ->addr_limit and ignoring much
tastier targets next to it, but then what do you expect from degenerate
spawn of Great Old Ones - sanity?
