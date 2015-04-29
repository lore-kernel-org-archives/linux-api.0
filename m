From: Mark Williamson <mwilliamson@undo-software.com>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Wed, 29 Apr 2015 20:23:01 +0100
Message-ID: <CAEVpBaJSX5-j=ONn=MQ1nOs+wX62jEAWaS3EcNdPJBuySad9gQ@mail.gmail.com>
References: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
	<CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
	<CAEVpBa+vjfR8p_fJQPXyrQCMYJOocQpTHmkTYmj7nOpGcce=Pg@mail.gmail.com>
	<CAEVpBa+DPbhZeRsA=+Jnn7f1BqVZm9SU=ABjy6bAHbbMi_yn+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEVpBa+DPbhZeRsA=+Jnn7f1BqVZm9SU=ABjy6bAHbbMi_yn+g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Seaborn <mseaborn@chromium.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pavel Emelyanov <xemul@parallels.com>, Konstantin Khlebnikov <khlebnikov@openvz.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>, Finn Grimwood <fgrimwood@undo-software.com>, Daniel James <djames@undo-software.com>
List-Id: linux-api@vger.kernel.org

Hi again,

On Wed, Apr 29, 2015 at 7:44 PM, Mark Williamson
<mwilliamson@undo-software.com> wrote:
> We've been investigating further and found a snag with the PFN-hiding
> approach discussed last week - looks like it won't be enough on all
> the architectures we support.  Our product runs on x86_32, x86_64 and
> ARM.  For now, it looks like soft-dirty is only available on x86_64.
> A patch that simply zeros out the physical addresses in
> /proc/PID/pagemap will therefore help us on x86_64 but we'll still
> have problems on other platforms[1].

Another thought occurs - although we *strictly* want to know "what got
written to", we might be able to get by with a superset of that, such
as "what got accessed, read or write"...

Thus, we could investigate clearing the Referenced bit (which I
understand we can do through /proc/PID/clear_refs) and then just treat
any subsequently-referenced pages as being potentially modified.  It's
not ideal but it might be enough to get by...

I still feel a little nervous with this, since we support distros
(e.g. RHEL5) that are too old to have clear_refs.  Still, it would
result in less disruption to the format of pagemap.

Thanks,
Mark

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
>
> Thanks,
> Mark
>
> [1] I'd note that using soft-dirty is clearly the right approach for
> us on x64, where available and that ideally we'd use it on other
> architectures - cross-arch support for soft-dirty is a slightly
> different discussion, which I hope to post another thread for.
>
> On Fri, Apr 24, 2015 at 5:43 PM, Mark Williamson
> <mwilliamson@undo-software.com> wrote:
>> Hi Mark,
>>
>> On Fri, Apr 24, 2015 at 4:26 PM, Mark Seaborn <mseaborn@chromium.org> wrote:
>>> I'm curious, what do you use the physical page addresses for?
>>>
>>> Since you pointed to http://undo-software.com, which talks about
>>> reversible debugging tools, I can guess you would use the soft-dirty
>>> flag to implement copy-on-write snapshotting.  I'm guessing you might
>>> use physical page addresses for determining when the same page is
>>> mapped twice (in the same process or different processes)?
>>
>> That's pretty much it.  Actually, we're effectively using the physical
>> addresses to emulate soft-dirty.  For certain operations (e.g. some
>> system calls) we need to track what memory has changed since we last
>> looked at the process state.  We have a mechanism that forks a child
>> process, runs the system call, then refers to pagemap to figure out
>> what's been modified.
>>
>> Currently, our mechanism compares the physical addresses of pages
>> before and after the syscall so that we can see which pages got CoWed.
>> This is perhaps a slightly "unconventional" use of the interface but
>> we support kernels that predate the soft-dirty mechanism and (as far
>> as we know) this is probably the best way we can answer "What got
>> changed?" on those releases.
>>
>> Using the soft-dirty mechanism where available should make our code
>> both cleaner and faster, so if we can fix the pagemap file to allow
>> that then we'll be quite happy!
>>
>> Cheers,
>> Mark
