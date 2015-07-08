From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH V3 3/5] mm: mlock: Introduce VM_LOCKONFAULT and add
 mlock flags to enable it
Date: Wed, 8 Jul 2015 15:17:50 -0600
Message-ID: <20150708151750.75e65859@lwn.net>
References: <1436288623-13007-1-git-send-email-emunson@akamai.com>
	<1436288623-13007-4-git-send-email-emunson@akamai.com>
	<20150708132351.61c13db6@lwn.net>
	<20150708203456.GC4669@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20150708203456.GC4669@akamai.com>
Sender: sparclinux-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vlastimil Babka <vbabka@suse.cz>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 8 Jul 2015 16:34:56 -0400
Eric B Munson <emunson@akamai.com> wrote:

> > Quick, possibly dumb question: I've been beating my head against these for
> > a little bit, and I can't figure out what's supposed to happen in this
> > case:
> > 
> > 	mlock2(addr, len, MLOCK_ONFAULT);
> > 	munlock2(addr, len, MLOCK_LOCKED);
> > 
> > It looks to me like it will clear VM_LOCKED without actually unlocking any
> > pages.  Is that the intended result?  
> 
> This is not quite right, what happens when you call munlock2(addr, len,
> MLOCK_LOCKED); is we call apply_vma_flags(addr, len, VM_LOCKED, false).

>From your explanation, it looks like what I said *was* right...what I was
missing was the fact that VM_LOCKED isn't set in the first place.  So that
call would be a no-op, clearing a flag that's already cleared.

One other question...if I call mlock2(MLOCK_ONFAULT) on a range that
already has resident pages, I believe that those pages will not be locked
until they are reclaimed and faulted back in again, right?  I suspect that
could be surprising to users.

Thanks,

jon
