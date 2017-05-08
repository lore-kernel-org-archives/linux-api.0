From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Mon, 8 May 2017 14:46:21 +0200
Message-ID: <20170508124621.GA20705@kroah.com>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170508073352.caqe3fqf7nuxypgi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook@chromium.o>
List-Id: linux-api@vger.kernel.org

On Mon, May 08, 2017 at 09:33:52AM +0200, Ingo Molnar wrote:
> 
> (added more Cc:s)
> 
> * Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Fri, Apr 28, 2017 at 8:32 AM, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > Ensure that a syscall does not return to user-mode with a kernel address
> > > limit. If that happens, a process can corrupt kernel-mode memory and
> > > elevate privileges [1].
> > >
> > > The CONFIG_ADDR_LIMIT_CHECK option disables the generic check so each
> > > architecture can create optimized versions. This option is enabled by
> > > default on s390 because a similar feature already exists.
> > >
> > > [1] https://bugs.chromium.org/p/project-zero/issues/detail?id=990
> > >
> > > Signed-off-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > Tested-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > 
> > Ingo: Do you want to take the set?
> 
> Yeah, so now I'm questioning the whole premise of the feature, sorry :-/
> 
> A big disavantage is that the "security check" will add 2-5 instructions to the 
> system call fast path. Every one of them, and essentially forever. Just to handle 
> a CVE that was caused by a buggy touch-screen driver helper function leaking 
> KERNEL_DS and which was fixed long ago ...
> 
> And yes, I realize that there were other such bugs and that such bugs might occur 
> in the future - but why not push the overhead of the security check to the kernel 
> build phase? I.e. I'm wondering how well we could do static analysis during kernel 
> build - would a limited mode of Sparse be good enough for that? Or we could add a 
> new static checker to tools/, built from first principles and used primarily for 
> extended syntactical checking.
> 
> For example I'd consider it a good practice to mandate that if a kernel function 
> sets KERNEL_DS then it must restore it as well. Any function that does not do 
> that, or is too complex for the static analysis to prove correctness for sure 
> should be considered buggy!
> 
> Are there any common kernel APIs outside set_fs() that set KERNEL_DS 
> intentionally? The overwhelming pattern ought to be:
> 
>         orig_fs = get_fs();
>         set_fs(KERNEL_DS);
> 	...
>         set_fs(orig_fs);
> 
> ... and even a relatively simple static analysis tool ought to be able to see 
> through that.
> 
> I'd even suggest we do it not like Sparse builds are done today, but in a more 
> integrated fashion: do static analysis as part of a typical kernel defconfig build 
> and not tolerate warnings but go for a 'zero warnings' policy like Linus uses for 
> modconfig builds.
> 
> _That_ solution I'd feel very, very good about - it would be so much better than 
> any runtime checks...
> 
> Not to mention that such an integrated static analysis facility would allow many 
> other things to be checked during build time, which we couldn't possibly check 
> runtime.

What about a simple coccinelle script to test for this type of thing?
We write it once, add it to the in-kernel body of tests, and then 0-day
runs it on all trees all the time.  That should catch this type of
issue, like all of the other "bad programming bus" that the tool
currently catches.

thanks,

greg k-h
