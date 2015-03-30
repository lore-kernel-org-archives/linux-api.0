From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Mon, 30 Mar 2015 14:33:53 -0700
Message-ID: <20150330143353.6467b7f4b78d30eaadedb9ec@linux-foundation.org>
References: <20150326202824.65d03787.akpm@linux-foundation.org>
	<20150327081822.GA28669@infradead.org>
	<20150327013516.8c6788be.akpm@linux-foundation.org>
	<20150327084833.GA7689@infradead.org>
	<20150327020159.eadd0ce1.akpm@linux-foundation.org>
	<20150327155854.GA5548@samba2>
	<20150330073604.GB22229@infradead.org>
	<20150330132625.52b1250527ca3dcda79e349e@linux-foundation.org>
	<20150330203227.GA4987@samba2>
	<20150330133758.d2788f6de72f121170ff0301@linux-foundation.org>
	<20150330204937.GB4987@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150330204937.GB4987@samba2>
Sender: linux-arch-owner@vger.kernel.org
To: Jeremy Allison <jra@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>, Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Mon, 30 Mar 2015 13:49:37 -0700 Jeremy Allison <jra@samba.org> wrote:

> > This implies that the samba main thread also has to avoid any memory
> > allocations both direct and within syscall and pagefault - those will
> > occasionally exhibit similar worse-case latency. Is this done now?
> 
> We don't do anything special around allocations in syscall.
> For aio read we do talloc (internal memory allocator) the
> return chunk before going into the pthread pread, so I
> suppose this could block. Haven't seen this as a reported
> problem though. I suppose you can say "well exactly the
> same thing is true of fincore()" :-).

yup.  If we tickle the page's referenced bit in fincore() then the race
will only happen under the most withering memory loads, and it sounds
like the main thread will be suffering allocation stalls before that
point anyway.
