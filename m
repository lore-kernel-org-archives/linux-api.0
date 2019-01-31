From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT
 is set for the I/O
Date: Thu, 31 Jan 2019 10:56:44 +0100
Message-ID: <20190131095644.GR18811@dhcp22.suse.cz>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz>
 <20190130124420.1834-3-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190130124420.1834-3-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Jiri Kosina <jkosina@suse.cz>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, Jiri Kosina <jikos@kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[Cc fs-devel]

On Wed 30-01-19 13:44:19, Vlastimil Babka wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> 
> preadv2(RWF_NOWAIT) can be used to open a side-channel to pagecache contents, as
> it reveals metadata about residency of pages in pagecache.
> 
> If preadv2(RWF_NOWAIT) returns immediately, it provides a clear "page not
> resident" information, and vice versa.
> 
> Close that sidechannel by always initiating readahead on the cache if we
> encounter a cache miss for preadv2(RWF_NOWAIT); with that in place, probing
> the pagecache residency itself will actually populate the cache, making the
> sidechannel useless.

I guess the current wording doesn't disallow background IO to be
triggered for EAGAIN case. I am not sure whether that breaks clever
applications which try to perform larger IO for those cases though.

> Originally-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Dominique Martinet <asmadeus@codewreck.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Kevin Easton <kevin@guarana.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Cyril Hrubis <chrubis@suse.cz>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Daniel Gruss <daniel@gruss.cc>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/filemap.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 9f5e323e883e..7bcdd36e629d 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2075,8 +2075,6 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
>  
>  		page = find_get_page(mapping, index);
>  		if (!page) {
> -			if (iocb->ki_flags & IOCB_NOWAIT)
> -				goto would_block;
>  			page_cache_sync_readahead(mapping,
>  					ra, filp,
>  					index, last_index - index);

Maybe a stupid question but I am not really familiar with this path but
what exactly does prevent a sync read down page_cache_sync_readahead
path?
-- 
Michal Hocko
SUSE Labs
