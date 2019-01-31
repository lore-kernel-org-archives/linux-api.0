From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT
 is set for the I/O
Date: Thu, 31 Jan 2019 12:32:23 +0100
Message-ID: <20190131113223.GU18811@dhcp22.suse.cz>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz>
 <20190130124420.1834-3-vbabka@suse.cz>
 <20190131095644.GR18811@dhcp22.suse.cz>
 <nycvar.YFH.7.76.1901311114260.6626@cbobk.fhfr.pm>
 <20190131102348.GT18811@dhcp22.suse.cz>
 <nycvar.YFH.7.76.1901311129420.3281@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1901311129420.3281@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu 31-01-19 11:30:24, Jiri Kosina wrote:
> On Thu, 31 Jan 2019, Michal Hocko wrote:
> 
> > > > > diff --git a/mm/filemap.c b/mm/filemap.c
> > > > > index 9f5e323e883e..7bcdd36e629d 100644
> > > > > --- a/mm/filemap.c
> > > > > +++ b/mm/filemap.c
> > > > > @@ -2075,8 +2075,6 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
> > > > >  
> > > > >  		page = find_get_page(mapping, index);
> > > > >  		if (!page) {
> > > > > -			if (iocb->ki_flags & IOCB_NOWAIT)
> > > > > -				goto would_block;
> > > > >  			page_cache_sync_readahead(mapping,
> > > > >  					ra, filp,
> > > > >  					index, last_index - index);
> > > > 
> > > > Maybe a stupid question but I am not really familiar with this path but
> > > > what exactly does prevent a sync read down page_cache_sync_readahead
> > > > path?
> > > 
> > > page_cache_sync_readahead() only submits the read ahead request(s), it 
> > > doesn't wait for it to finish.
> > 
> > OK, I guess my question was not precise. What does prevent taking fs
> > locks down the path?
> 
> Well, RWF_NOWAIT doesn't mean the kernel can't reschedule while executing 
> preadv2(), right? It just means it will not wait for the arrival of the 
> whole data blob into pagecache in case it's not there.

No, it can reschedule for sure but the man page says: 
: If this flag is specified, the preadv2() system call will return
: instantly if it would have to read data from the backing storage or wait
: for a lock.

I assume that the lock is meant to be a filesystem lock here.
-- 
Michal Hocko
SUSE Labs
