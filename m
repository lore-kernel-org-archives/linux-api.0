From: josh@joshtriplett.org
Subject: Re: [PATCH] mm: Support compiling out madvise and fadvise
Date: Thu, 25 Sep 2014 11:27:02 -0700
Message-ID: <20140925182702.GB9360@cloud>
References: <20140922161109.GA25027@thin>
 <20140925172113.GA8209@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140925172113.GA8209@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 25, 2014 at 01:21:13PM -0400, Johannes Weiner wrote:
> On Mon, Sep 22, 2014 at 09:11:16AM -0700, Josh Triplett wrote:
> > @@ -3,7 +3,7 @@
> >  #
> >  
> >  mmu-y			:= nommu.o
> > -mmu-$(CONFIG_MMU)	:= fremap.o gup.o highmem.o madvise.o memory.o mincore.o \
> > +mmu-$(CONFIG_MMU)	:= fremap.o gup.o highmem.o memory.o mincore.o \
> >  			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
> >  			   vmalloc.o pagewalk.o pgtable-generic.o
> >  
> > @@ -11,7 +11,7 @@ ifdef CONFIG_CROSS_MEMORY_ATTACH
> >  mmu-$(CONFIG_MMU)	+= process_vm_access.o
> >  endif
> >  
> > -obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
> > +obj-y			:= filemap.o mempool.o oom_kill.o \
> >  			   maccess.o page_alloc.o page-writeback.o \
> >  			   readahead.o swap.o truncate.o vmscan.o shmem.o \
> >  			   util.o mmzone.o vmstat.o backing-dev.o \
> > @@ -28,6 +28,9 @@ else
> >  	obj-y		+= bootmem.o
> >  endif
> >  
> > +ifdef CONFIG_MMU
> > +	obj-$(CONFIG_ADVISE_SYSCALLS)	+= fadvise.o madvise.o
> > +endif
> 
> That makes fadvise MMU-only, but I don't see why it should be.
> 
> Was that intentional?

No.  Fixed in v2; will send out momentarily.  Thanks!

- Josh Triplett

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
