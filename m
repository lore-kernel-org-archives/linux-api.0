From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 1/3] mm/mincore: make mincore() more conservative
Date: Thu, 7 Mar 2019 06:46:00 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1903070643560.19912@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-2-vbabka@suse.cz> <20190306151351.f8ae1acae51ccad1a3537284@linux-foundation.org> <nycvar.YFH.7.76.1903070047360.19912@cbobk.fhfr.pm>
 <20190307004036.GA16785@nautica>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190307004036.GA16785@nautica>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>
List-Id: linux-api@vger.kernel.org

On Thu, 7 Mar 2019, Dominique Martinet wrote:

> > > 
> > > 	addr = 4095
> > > 	vma->vm_end = 4096
> > > 	pages = 1000
> > > 
> > > then `end' is 4096 and `(end - addr) << PAGE_SHIFT' is zero, but it
> > > should have been 1.
> > 
> > Good catch! It should rather be something like
> > 
> > 	unsigned long pages = (end >> PAGE_SHIFT) - (addr >> PAGE_SHIFT);
> 
> That would be 0 for addr = 0 and vma->vm_end = 1; I assume we would
> still want to count that as one page.

Yeah, that was bogus as well, ETOOTIRED yesterday, sorry for the noise. 
Both the variants are off.

> I'm not too familiar with this area of the code, but I think there's a
> handy macro we can use for this, perhaps
>   DIV_ROUND_UP(end - addr, PAGE_SIZE) ?
> 
> kernel/kexec_core.c has defined PAGE_COUNT() which seems more
> appropriate but I do not see a global equivalent
> #define PAGE_COUNT(x) (((x) + PAGE_SIZE - 1) >> PAGE_SHIFT)

I'll fix that up when doing the other changes requested by Andrew.

Thanks,

-- 
Jiri Kosina
SUSE Labs
