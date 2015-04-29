From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Wed, 29 Apr 2015 22:36:22 +0300
Message-ID: <20150429193622.GA11892@node.dhcp.inet.fi>
References: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
 <CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
 <CAEVpBa+vjfR8p_fJQPXyrQCMYJOocQpTHmkTYmj7nOpGcce=Pg@mail.gmail.com>
 <CAEVpBa+DPbhZeRsA=+Jnn7f1BqVZm9SU=ABjy6bAHbbMi_yn+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAEVpBa+DPbhZeRsA=+Jnn7f1BqVZm9SU=ABjy6bAHbbMi_yn+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Cc: Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 29, 2015 at 07:44:57PM +0100, Mark Williamson wrote:
> Hi all,
> 
> We've been investigating further and found a snag with the PFN-hiding
> approach discussed last week - looks like it won't be enough on all
> the architectures we support.  Our product runs on x86_32, x86_64 and
> ARM.  For now, it looks like soft-dirty is only available on x86_64.
> A patch that simply zeros out the physical addresses in
> /proc/PID/pagemap will therefore help us on x86_64 but we'll still
> have problems on other platforms[1].
> 
> For context, we were previously using pagemap as a cross-platform way
> to get soft-dirty-like functionality.  Specifically, to ask "did a
> process write to any pages since fork()" by comparing addresses and
> deducing where CoW must have occurred.  In the absence of soft-dirty
> and the physical addresses, it looks like we can't figure that out
> with the remaining information in pagemap.
> 
> If the pagemap file included the "writeable" bit from the PTE, we
> think we'd have all the information required to deduce what we need
> (although I realise that's a bit of a nasty workaround).  If I
> proposed including the PTE protection bits in pagemap, would that be
> controversial?  I'm guessing yes but thought it was worth a shot ;-)
> Would anybody be able to suggest a more tasteful approach?

Emm.. I have hard time to understand how writable bit is enough to get
soft-dirty-alike functionality.

Let's say we have anon-mapping with COW setup after the fork(). It's not
writable PTEs to trigger COW on wp faults. But you can easily get to the
same non-writable PTE after breaking COW: fork() again or
mprotect(PROT_READ) and mprotect(PROT_READ|PROT_WRITE) back.

?

> 
> Thanks,
> Mark
> 
> [1] I'd note that using soft-dirty is clearly the right approach for
> us on x64, where available and that ideally we'd use it on other
> architectures - cross-arch support for soft-dirty is a slightly
> different discussion, which I hope to post another thread for.

-- 
 Kirill A. Shutemov
