From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Thu, 26 Mar 2015 04:55:14 -0700
Message-ID: <20150326115514.GA12329@infradead.org>
References: <cover.1426528417.git.milosz@adfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <cover.1426528417.git.milosz@adfin.com>
Sender: owner-linux-aio@kvack.org
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 16, 2015 at 02:27:10PM -0400, Milosz Tanski wrote:
> This patchset introduces two new syscalls preadv2 and pwritev2. They are the
> same syscalls as preadv and pwrite but with a flag argument. Additionally,
> preadv2 implements an extra RWF_NONBLOCK flag. 

There was some arugment that we just don't wait and don't have the
classic unix "blocking" semantics.  Maybe it's time to bite the bullet
and rename it to RWF_DONTWAIT? (I personally dont really care).

Second this probably needs to be on top of Al's for-next tree:

	https://git.kernel.org/cgit/linux/kernel/git/viro/vfs.git/log/?h=for-next

Note that this has a flags field in struct kiocb, so we could just use
that for the flags.

Otherwise this version look fine to me, let's get it merged!

Al, are yo ready to pick this up?  I'd hate to miss another merge
window.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
