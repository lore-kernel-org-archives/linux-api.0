From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Fri, 12 May 2017 17:16:44 -0400
Message-ID: <1494623804.4521.2.camel@gmail.com>
References: <CAJcbSZFswDWZoK-1UK+xkRMJ4ttSYbtH2Y5WD5_aPR-8ru6t8A@mail.gmail.com>
         <CAJcbSZEoRyewUtBHvqmNZL9FtT_q42Vmmd-EuC50x-ZRASiHHg@mail.gmail.com>
         <CA+55aFwvQfs_X+paQF6Luc0Rq+W3J2fKuHRou7=ANcquDdXdDA@mail.gmail.com>
         <20170512072802.5a686f23@mschwideX1>
         <CAGXu5j+EatK=DYONRkgovwLgytAnbG8jnAZaMSLckZFNVj3gig@mail.gmail.com>
         <20170512075458.09a3a1ce@mschwideX1>
         <CAGXu5jL9vUrn4kpjO+qa4cHmWBypeqP17OGbrMs=5Nz0YpQMZw@mail.gmail.com>
         <CA+55aFzbiBqsYb7vwO=+L4Vp_GOgPu+DBOrq4fBnyzq5DbBehg@mail.gmail.com>
         <CAGXu5j+xmyJ6RhtPw9rUgs7k3sZ1KKWffvyGGG--oPfu9W42ng@mail.gmail.com>
         <20170512202106.GO22219@n2100.armlinux.org.uk>
         <20170512210645.GS390@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170512210645.GS390-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-s390 <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?Ren=E9?= Nyffenegger <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Paul E . McKenne
List-Id: linux-api@vger.kernel.org

On Fri, 2017-05-12 at 22:06 +0100, Al Viro wrote:
> On Fri, May 12, 2017 at 09:21:06PM +0100, Russell King - ARM Linux
> wrote:
> > On Fri, May 12, 2017 at 12:30:02PM -0700, Kees Cook wrote:
> > > I'm clearly not explaining things well enough. I shouldn't say
> > > "corruption", I should say "malicious manipulation". The
> > > methodology
> > > of attacks against the stack are quite different from the other
> > > kinds
> > > of attacks like use-after-free, heap overflow, etc. Being able to
> > > exhaust the kernel stack (either due to deep recursion or
> > > unbounded
> > > alloca())
> > 
> > I really hope we don't have alloca() use in the kernel.  Do you have
> > evidence to support that assertion?
> > 
> > IMHO alloca() (or similar) should not be present in any kernel code
> > because we have a limited stack - we have kmalloc() etc for that
> > kind
> > of thing.
> 
> No alloca(), but there are VLAs.  Said that, the whole "what if they
> can bugger thread_info and/or task_struct and go after set_fs() state"
> is idiocy, of course - in that case the box is fucked, no matter what.

VMAP_STACK + -fstack-check would prevent exploiting even an unbounded
VLA / alloca size vs. it being an arbitrary write. -fstack-check
guarantees that there's one byte per page as the stack grows, although
there are some unfortunate GCC bugs making it less than perfect right
now... but they recently started caring about it more including making
it near zero overhead as it was always supposed to be.
