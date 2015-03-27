From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 27 Mar 2015 09:39:42 -0700
Message-ID: <20150327093942.8ad38cd7.akpm@linux-foundation.org>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<20150327081822.GA28669@infradead.org>
	<20150327013516.8c6788be.akpm@linux-foundation.org>
	<20150327084833.GA7689@infradead.org>
	<20150327020159.eadd0ce1.akpm@linux-foundation.org>
	<20150327155854.GA5548@samba2>
	<20150327093046.53c2769a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150327093046.53c2769a.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeremy Allison <jra@samba.org>, Christoph Hellwig <hch@infradead.org>, Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Fri, 27 Mar 2015 09:30:46 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> I expect that this situation (first part in cache, latter part not in
> cache) is rare - for reasonably small requests the common cases will be
> "all cached" and "nothing cached".  So perhaps the best approach here
> is for samba to add special handling for the short read, to work out
> the reason for its occurrence.
> 
> Alternatively we could add another flag to pread2() to select this
> "throw away my data and return -EAGAIN" behaviour.  Presumably
> implemented with an i_size check, but it's gonna be racy.

Here's a better way:

	nr_read = pread2(buf, len);
	if (nr_read < len)
		nr_read += pread(buf + nr_read, len - nr_read);
	if (nr_read < len)
		we_hit_eof();
