From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 1/3] mm/mincore: make mincore() more conservative
Date: Thu, 7 Mar 2019 01:01:10 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1903070047360.19912@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-2-vbabka@suse.cz> <20190306151351.f8ae1acae51ccad1a3537284@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190306151351.f8ae1acae51ccad1a3537284@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>
List-Id: linux-api@vger.kernel.org

On Wed, 6 Mar 2019, Andrew Morton wrote:

> > The semantics of what mincore() considers to be resident is not completely
> > clear, but Linux has always (since 2.3.52, which is when mincore() was
> > initially done) treated it as "page is available in page cache".
> > 
> > That's potentially a problem, as that [in]directly exposes meta-information
> > about pagecache / memory mapping state even about memory not strictly belonging
> > to the process executing the syscall, opening possibilities for sidechannel
> > attacks.
> > 
> > Change the semantics of mincore() so that it only reveals pagecache information
> > for non-anonymous mappings that belog to files that the calling process could
> > (if it tried to) successfully open for writing.
> 
> "for writing" comes as a bit of a surprise.  Why not for reading?

I guess this is a rhetorical question from you :) but fair enough, good 
point, I'll explain this a bit more in the changelog and in the code 
comments.

> > @@ -189,8 +197,13 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
> >  	vma = find_vma(current->mm, addr);
> >  	if (!vma || addr < vma->vm_start)
> >  		return -ENOMEM;
> > -	mincore_walk.mm = vma->vm_mm;
> >  	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
> > +	if (!can_do_mincore(vma)) {
> > +		unsigned long pages = (end - addr) >> PAGE_SHIFT;
> 
> I'm not sure this is correct in all cases.   If
> 
> 	addr = 4095
> 	vma->vm_end = 4096
> 	pages = 1000
> 
> then `end' is 4096 and `(end - addr) << PAGE_SHIFT' is zero, but it
> should have been 1.

Good catch! It should rather be something like

	unsigned long pages = (end >> PAGE_SHIFT) - (addr >> PAGE_SHIFT);

I'll fix that up and resend tomorrow.

Thanks,

-- 
Jiri Kosina
SUSE Labs
