From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Tue, 9 May 2017 13:10:07 +0200
Message-ID: <20170509111007.GA14702@kroah.com>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508075209.7aluvpwildw325rf@gmail.com>
 <1494256932.1167.1.camel@gmail.com>
 <CAGXu5jL61K0bRSEg9a_LswNyrt3K1J57REbWVcvAXT54zWwtMA@mail.gmail.com>
 <20170509065619.wmqa6z6w3n6xpvrw@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170509065619.wmqa6z6w3n6xpvrw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini@re>
List-Id: linux-api@vger.kernel.org

On Tue, May 09, 2017 at 08:56:19AM +0200, Ingo Molnar wrote:
> 
> * Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> 
> > > There's the option of using GCC plugins now that the infrastructure was 
> > > upstreamed from grsecurity. It can be used as part of the regular build 
> > > process and as long as the analysis is pretty simple it shouldn't hurt compile 
> > > time much.
> > 
> > Well, and that the situation may arise due to memory corruption, not from 
> > poorly-matched set_fs() calls, which static analysis won't help solve. We need 
> > to catch this bad kernel state because it is a very bad state to run in.
> 
> If memory corruption corrupted the task state into having addr_limit set to 
> KERNEL_DS then there's already a fair chance that it's game over: it could also 
> have set *uid to 0, or changed a sensitive PF_ flag, or a number of other 
> things...
> 
> Furthermore, think about it: there's literally an infinite amount of corrupted 
> task states that could be a security problem and that could be checked after every 
> system call. Do we want to check every one of them?

Ok, I'm all for not checking lots of stuff all the time, just to protect
from crappy drivers that.  Especially as we _can_ audit and run checks
on the source code for them in the kernel tree.

But, and here's the problem, outside of the desktop/enterprise world,
there are a ton of out-of-tree code that is crap.  The number of
security/bug fixes and kernel crashes for out-of-tree code in systems
like Android phones is just so high it's laughable.

When you have a device that is running 3.2 million lines of kernel code,
yet the diffstat of the tree compared to mainline adds 3 million lines
of code, there is bound to be a ton of issues/problems there.

So this is an entirely different thing we need to try to protect
ourselves from.  A long time ago I laughed when I saw that Microsoft had
to do lots of "hardening" of their kernel to protect themselves from
crappy drivers, as I knew we didn't have to do that because we had the
source for them and could fix the root issues.  But that has changed and
now we don't all have that option.  That code is out-of-tree because the
vendor doesn't care, and doesn't want to take any time at all to do
anything resembling a real code review[1].

So, how about options like the ones being proposed here, go behind a new
config option:
	CONFIG_PROTECT_FROM_CRAPPY_DRIVERS
that device owners can enable if they do not trust their vendor-provided
code (hint, I sure don't.)  That way the "normal" path that all of us
are used to running will be fine, but if you want to take the speed hit
to try to protect yourself, then you can do that as well.

Anyway, just an idea...

thanks,

greg k-h

[1] I am working really hard with lots of vendors to try to fix their
    broken development model, but that is going to take years to resolve
    as their device pipelines are years long, and changing their
    mindsets takes a long time...
