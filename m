From: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Tue, 29 Oct 2019 10:28:53 +0100
Message-ID: <20191029092852.GD18773@rapoport-lnx>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <1572171452-7958-2-git-send-email-rppt@kernel.org>
 <d6ac08fe-23f3-c2d5-24c4-88e68f3fd4d0@intel.com>
 <20191028180808.GA17669@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191028180808.GA17669@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 28, 2019 at 11:08:08AM -0700, Matthew Wilcox wrote:
> On Mon, Oct 28, 2019 at 10:12:44AM -0700, Dave Hansen wrote:
> > Some other random thoughts:
> > 
> >  * The page flag is probably not a good idea.  It would be probably
> >    better to set _PAGE_SPECIAL on the PTE and force get_user_pages()
> >    into the slow path.
> >  * This really stops being "normal" memory.  You can't do futexes on it,
> >    cant splice it.  Probably need a more fleshed-out list of
> >    incompatible features.
> >  * As Kirill noted, each 4k page ends up with a potential 1GB "blast
> >    radius" of demoted pages in the direct map.  Not cool.  This is
> >    probably a non-starter as it stands.
> >  * The global TLB flushes are going to eat you alive.  They probably
> >    border on a DoS on larger systems.
> >  * Do we really want this user interface to dictate the kernel
> >    implementation?  In other words, do we really want MAP_EXCLUSIVE,
> >    or do we want MAP_SECRET?  One tells the kernel what do *do*, the
> >    other tells the kernel what the memory *IS*.
> >  * There's a lot of other stuff going on in this area: XPFO, SEV, MKTME,
> >    Persistent Memory, where the kernel direct map is a liability in some
> >    way.  We probably need some kind of overall, architected solution
> >    rather than five or ten things all poking at the direct map.
> 
> Another random set of thoughts:
> 
>  - Should devices be permitted to DMA to/from MAP_SECRET pages?

I can't say I have a clear cut yes or no here. One possible use case for
such pages is to read a secrets from storage directly into them. On the
other side, DMA to/from a device can be used to exploit those secrets...

>  - How about GUP?

Do you mean GUP for "remote" memory? I'd say no.

>  - Can I ptrace my way into another process's secret pages?

No.

>  - What if I splice() the page into a pipe?

I think it should fail.

-- 
Sincerely yours,
Mike.
