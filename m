From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Mon, 08 May 2017 11:22:12 -0400
Message-ID: <1494256932.1167.1.camel@gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com>
         <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
         <20170508073352.caqe3fqf7nuxypgi@gmail.com>
         <20170508075209.7aluvpwildw325rf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170508075209.7aluvpwildw325rf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?Ren=E9?= Nyffenegger <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Josh Poimboeuf <jpoimboe@redhat.c>
List-Id: linux-api@vger.kernel.org

On Mon, 2017-05-08 at 09:52 +0200, Ingo Molnar wrote:
> 
> ... it's just not usable in that form for a regular maintenance flow.
> 
> So what would be more useful is to add a specific Sparse check that
> only checks 
> KERNEL_DS, to add it as a regular (.config driven) build option and
> make sure the 
> kernel build has zero warnings.
> 
> From that point on we can declare that this kind of bug won't occur
> anymore, if 
> the Sparse implementation of the check is correct.
> 
> But there's a (big) problem with that development model: Sparse is not
> part of the 
> kernel tree and adding a feature to it while making the kernel depend
> on that 
> brand new feature is a logistical nightmare. The overhead is quite
> similar to 
> adding new features to a compiler - it happens at a glacial pace and
> is only done 
> for major features really, at considerable expense. I don't think this
> is an 
> adequate model for 'extended syntax checking' of the kernel,
> especially when it 
> comes to correctness that has such obvious security impact.
> 
> Thanks,
> 
> 	Ingo

There's the option of using GCC plugins now that the infrastructure was
upstreamed from grsecurity. It can be used as part of the regular build
process and as long as the analysis is pretty simple it shouldn't hurt
compile time much.

The problem with doing that is I don't think there are people with much
experience with GCC contributing upstream and it's going to be more work
to develop/maintain than some kind of specialized DSL for analysis. I
think a few static analysis plugins are used as part of maintaining
grsecurity for solving issues like finding false positives for the
REFCOUNT overflow checking feature, so it's something that's already
being done in practice elsewhere.
