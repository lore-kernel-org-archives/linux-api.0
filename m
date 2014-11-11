From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Tue, 11 Nov 2014 17:49:38 -0500
Message-ID: <20141111224938.GA4112@thunk.org>
References: <cover.1415636409.git.milosz@adfin.com>
 <20141111064417.GT23575@dastard>
 <CANP1eJHfWT0Foe+weB1SJkJ10JnOge_g=E8CXBsQNPW7i2+4NA@mail.gmail.com>
 <x49ioilbrfx.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <x49ioilbrfx.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Milosz Tanski <milosz@adfin.com>, Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 11, 2014 at 12:03:14PM -0500, Jeff Moyer wrote:
> 
> I think he's referring to xfstests.  Still, I think that's the wrong
> place for functional testing.  ltp would be better, imo.

I disagree; xfstests is the right place for adding these tests, because
these patches seem to require fs-specific support, and file system
developers are already using xfstests when checking for regressions.
Using xfstests is already part of most of the file system developers'
workflow; ltp is not. 

So if you want to make sure we notice regressions, it really needs to
go into xfstests.  If you insist on putting it in ltp, then one of us
will then have to make a copy of the tests and put it in xfstests.

Cheers,

						- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
