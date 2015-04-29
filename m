From: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Wed, 29 Apr 2015 19:44:57 +0100
Message-ID: <CAEVpBa+DPbhZeRsA=+Jnn7f1BqVZm9SU=ABjy6bAHbbMi_yn+g@mail.gmail.com>
References: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
	<CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
	<CAEVpBa+vjfR8p_fJQPXyrQCMYJOocQpTHmkTYmj7nOpGcce=Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEVpBa+vjfR8p_fJQPXyrQCMYJOocQpTHmkTYmj7nOpGcce=Pg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi all,

We've been investigating further and found a snag with the PFN-hiding
approach discussed last week - looks like it won't be enough on all
the architectures we support.  Our product runs on x86_32, x86_64 and
ARM.  For now, it looks like soft-dirty is only available on x86_64.
A patch that simply zeros out the physical addresses in
/proc/PID/pagemap will therefore help us on x86_64 but we'll still
have problems on other platforms[1].

For context, we were previously using pagemap as a cross-platform way
to get soft-dirty-like functionality.  Specifically, to ask "did a
process write to any pages since fork()" by comparing addresses and
deducing where CoW must have occurred.  In the absence of soft-dirty
and the physical addresses, it looks like we can't figure that out
with the remaining information in pagemap.

If the pagemap file included the "writeable" bit from the PTE, we
think we'd have all the information required to deduce what we need
(although I realise that's a bit of a nasty workaround).  If I
proposed including the PTE protection bits in pagemap, would that be
controversial?  I'm guessing yes but thought it was worth a shot ;-)
Would anybody be able to suggest a more tasteful approach?

Thanks,
Mark

[1] I'd note that using soft-dirty is clearly the right approach for
us on x64, where available and that ideally we'd use it on other
architectures - cross-arch support for soft-dirty is a slightly
different discussion, which I hope to post another thread for.

On Fri, Apr 24, 2015 at 5:43 PM, Mark Williamson
<mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org> wrote:
> Hi Mark,
>
> On Fri, Apr 24, 2015 at 4:26 PM, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> I'm curious, what do you use the physical page addresses for?
>>
>> Since you pointed to http://undo-software.com, which talks about
>> reversible debugging tools, I can guess you would use the soft-dirty
>> flag to implement copy-on-write snapshotting.  I'm guessing you might
>> use physical page addresses for determining when the same page is
>> mapped twice (in the same process or different processes)?
>
> That's pretty much it.  Actually, we're effectively using the physical
> addresses to emulate soft-dirty.  For certain operations (e.g. some
> system calls) we need to track what memory has changed since we last
> looked at the process state.  We have a mechanism that forks a child
> process, runs the system call, then refers to pagemap to figure out
> what's been modified.
>
> Currently, our mechanism compares the physical addresses of pages
> before and after the syscall so that we can see which pages got CoWed.
> This is perhaps a slightly "unconventional" use of the interface but
> we support kernels that predate the soft-dirty mechanism and (as far
> as we know) this is probably the best way we can answer "What got
> changed?" on those releases.
>
> Using the soft-dirty mechanism where available should make our code
> both cleaner and faster, so if we can fix the pagemap file to allow
> that then we'll be quite happy!
>
> Cheers,
> Mark
