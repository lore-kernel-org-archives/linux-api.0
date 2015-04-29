From: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Wed, 29 Apr 2015 21:24:40 +0100
Message-ID: <CAEVpBa+3kH7YM2y9pMroEP6M9hSr0XRRz9iLfLNqZ5aO2grtHw@mail.gmail.com>
References: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
	<CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
	<CAEVpBa+vjfR8p_fJQPXyrQCMYJOocQpTHmkTYmj7nOpGcce=Pg@mail.gmail.com>
	<CAEVpBa+DPbhZeRsA=+Jnn7f1BqVZm9SU=ABjy6bAHbbMi_yn+g@mail.gmail.com>
	<20150429193622.GA11892@node.dhcp.inet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150429193622.GA11892-nhfs4B5ZimeFUdmeq17FyvUpdFzICT1y@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

On Wed, Apr 29, 2015 at 8:36 PM, Kirill A. Shutemov
<kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:
> On Wed, Apr 29, 2015 at 07:44:57PM +0100, Mark Williamson wrote:
>> Hi all,
 ... snip ...
>> For context, we were previously using pagemap as a cross-platform way
>> to get soft-dirty-like functionality.  Specifically, to ask "did a
>> process write to any pages since fork()" by comparing addresses and
>> deducing where CoW must have occurred.  In the absence of soft-dirty
>> and the physical addresses, it looks like we can't figure that out
>> with the remaining information in pagemap.
>>
>> If the pagemap file included the "writeable" bit from the PTE, we
>> think we'd have all the information required to deduce what we need
>> (although I realise that's a bit of a nasty workaround).  If I
>> proposed including the PTE protection bits in pagemap, would that be
>> controversial?  I'm guessing yes but thought it was worth a shot ;-)
>> Would anybody be able to suggest a more tasteful approach?
>
> Emm.. I have hard time to understand how writable bit is enough to get
> soft-dirty-alike functionality.

In the general case, you are of course correct - in our specific case
I *think* we'd be able to manage OK ...  (see below).

> Let's say we have anon-mapping with COW setup after the fork(). It's not
> writable PTEs to trigger COW on wp faults. But you can easily get to the
> same non-writable PTE after breaking COW: fork() again or
> mprotect(PROT_READ) and mprotect(PROT_READ|PROT_WRITE) back.

I believe we'll be able to get away with this in our particular
usecase.  The process is running in our debugger at the time and so we
can interpose on the system calls that are happening.  That should
give us the opportunity to check for CoW-breaking before the debuggee
is allowed to alter page protections itself.

It ends up not being full soft-dirty behaviour but it's similar enough
to tell us what we need to know.

Cheers,
Mark

> ?
>
>>
>> Thanks,
>> Mark
>>
>> [1] I'd note that using soft-dirty is clearly the right approach for
>> us on x64, where available and that ideally we'd use it on other
>> architectures - cross-arch support for soft-dirty is a slightly
>> different discussion, which I hope to post another thread for.
>
> --
>  Kirill A. Shutemov
