From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Tue, 29 Oct 2019 09:13:43 -0600
Message-ID: <20191029151343.GE32132@cisco>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <2236FBA76BA1254E88B949DDB74E612BA4EEC0CE@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612BA4EEC0CE@IRSMSX102.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "x86@kernel.org" <x86@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>, Alan Cox <alan@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Hi Elena, Mike,

On Tue, Oct 29, 2019 at 11:25:12AM +0000, Reshetova, Elena wrote:
> > The patch below aims to allow applications to create mappins that have
> > pages visible only to the owning process. Such mappings could be used to
> > store secrets so that these secrets are not visible neither to other
> > processes nor to the kernel.
> 
> Hi Mike, 
> 
> I have actually been looking into the closely related problem for the past 
> couple of weeks (on and off). What is common here is the need for userspace
> to indicate to kernel that some pages contain secrets. And then there are
> actually a number of things that kernel can do to try to protect these secrets
> better. Unmap from direct map is one of them. Another thing is to map such
> pages as non-cached, which can help us to prevent or considerably restrict
> speculation on such pages. The initial proof of concept for marking pages as
> "UNCACHED" that I got from Dave Hansen was actually based on mlock2() 
> and a new flag for it for this purpose. Since then I have been thinking on what
> interface suits the use case better and actually selected going with new madvise() 
> flag instead because of all possible implications for fragmentation and performance. 
> My logic was that we better allocate the secret data explicitly (using mmap()) 
> to make sure that no other process data accidentally gets to suffer.
> Imagine I would allocate a buffer to hold a secret key, signal with mlock
>  to protect it and suddenly my other high throughput non-secret buffer 
> (which happened to live on the same page by chance) became very slow
>  and I don't even have an easy way (apart from mmap()ing it!) to guarantee
>  that it won't be affected.
> 
> So, I ended up towards smth like:
> 
>   secret_buffer =  mmap(NULL, PAGE_SIZE, ...)
>    madvise(secret_buffer, size, MADV_SECRET)
> 
> I have work in progress code here:
>  https://github.com/ereshetova/linux/commits/madvise
> 
> I haven't sent it for review, because it is not ready yet and I am now working
> on trying to add the page wiping functionality. Otherwise it would be useless
> to protect the page during the time it is used in userspace, but then allow it
> to get reused by a different process later after it has been released back and
> userspace was stupid enough not to wipe the contents (or was crashed on 
> purpose before it was able to wipe anything out). 

I was looking at this and thinking that wiping during do_exit() might
be a nice place, but I haven't tried anything yet.

> We have also had some discussions with Tycho that XPFO can be also
> applied selectively for such "SECRET" marked pages and I know that he has also
> did some initial prototyping on this, so I think it would be great to decide
> on userspace interface first and then see how we can assemble together all
> these features. 

Yep! Here's my tree with the direct un-mapping bits ported from XPFO:
https://github.com/tych0/linux/commits/madvise

As noted in one of the commit messages I think the bit math for page
prot flags needs a bit of work, but the test passes, so :)

In any case, I'll try to look at Mike's patches later today.

Cheers,

Tycho
