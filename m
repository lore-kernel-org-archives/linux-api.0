From: Jeremy Allison <jra@samba.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 27 Mar 2015 09:39:08 -0700
Message-ID: <20150327163908.GB5548@samba2>
References: <cover.1426528417.git.milosz@adfin.com>
 <20150326202824.65d03787.akpm@linux-foundation.org>
 <20150327081822.GA28669@infradead.org>
 <20150327013516.8c6788be.akpm@linux-foundation.org>
 <20150327084833.GA7689@infradead.org>
 <20150327020159.eadd0ce1.akpm@linux-foundation.org>
 <20150327155854.GA5548@samba2>
 <20150327093046.53c2769a.akpm@linux-foundation.org>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150327093046.53c2769a.akpm@linux-foundation.org>
Sender: owner-linux-aio@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Allison <jra@samba.org>, Christoph Hellwig <hch@infradead.org>, Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 27, 2015 at 09:30:46AM -0700, Andrew Morton wrote:
> 
> But from an interface perspective the behaviour you're asking for is
> insane, frankly - if the kernel copied out 8k of data then pread2()
> should return 8k.  Otherwise there's no way for userspace to know that
> the 8k copy actually happened and we have just wasted a great pile of
> CPU doing a pointless memcpy.

Why would it do the copy in the first place if we asked (for example)
for 16k, but only 8k was available ? Just return EAGAIN and have
done with it.

> I expect that this situation (first part in cache, latter part not in
> cache) is rare - for reasonably small requests the common cases will be
> "all cached" and "nothing cached".  So perhaps the best approach here
> is for samba to add special handling for the short read, to work out
> the reason for its occurrence.

We can do that, but as Volker says this is a very hot code path.

> I take it from your comments that nobody has actually wired up pread2()
> into samba yet?  That's a bit disturbing, because if we later want to
> go and change something like this short-read behaviour, we're screwed -
> it's a non back-compat userspace-visible change.

It's been done as a test, so the code exists and has run (and improved
perforamance as I recall). Not much point commiting it without kernel
support :-).

> And a note on cosmetics: why are we using EAGAIN here rather than
> EWOULDBLOCK?  They have the same numerical value, but EWOULDBLOCK is a
> better name - EAGAIN says "run it again", but that won't work.

Sounds good to me !

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
