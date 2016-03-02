From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5.1 0/2] create BLKZEROOUT ioctl that invalidates page cache
Date: Wed, 02 Mar 2016 10:15:02 +0100
Message-ID: <1889689.0axyUkdxkf@wuerfel>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160302040932.16685.62789.stgit@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, martin.petersen@oracle.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, bfields@fieldses.org, linux-fsdevel@vger.kernel.org, jlayton@poochiereds.net
List-Id: linux-api@vger.kernel.org

On Tuesday 01 March 2016 20:09:32 Darrick J. Wong wrote:
> This is (yet another) repost of the patch series that fixes the
> existing BLKZEROOUT ioctl to invalidate the page cache if the zeroing
> command to the underlying device succeeds.  This patch is against
> 4.5-rc6 and hasn't changed much in months.
> 
> The new BLKZEROOUT ioctl has the same semantics as the old one, but it
> invalidates the page cache to prevent surprising results, just like
> how dio writes invalidate page cache.
> 
> I've incorporated all the feedback I've received into these patches,
> but haven't heard yea or nay or anything at all from the maintainer.
> Will someone please pick this up for 4.6?
> 
> Comments and questions are, as always, welcome.

I'm missing the background on this, just saw the patch fly by,
so sorry if this has been asked before:

Why do you want to invalidate the cache? Is this to save RAM
or is something else going to write here and you have to invalidate
it for correctness?

If you just want to save RAM, would it be possible to instead
point the page cache to the empty zero page to speed up subsequent
reads? Maybe that just causes more complexity than it helps.

	Arnd
