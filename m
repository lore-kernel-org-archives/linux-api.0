From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
Date: Tue, 11 Nov 2014 12:03:14 -0500
Message-ID: <x49ioilbrfx.fsf@segfault.boston.devel.redhat.com>
References: <cover.1415636409.git.milosz@adfin.com>
	<20141111064417.GT23575@dastard>
	<CANP1eJHfWT0Foe+weB1SJkJ10JnOge_g=E8CXBsQNPW7i2+4NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CANP1eJHfWT0Foe+weB1SJkJ10JnOge_g=E8CXBsQNPW7i2+4NA@mail.gmail.com>
	(Milosz Tanski's message of "Tue, 11 Nov 2014 11:02:00 -0500")
Sender: owner-linux-aio@kvack.org
To: Milosz Tanski <milosz@adfin.com>
Cc: Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Milosz Tanski <milosz@adfin.com> writes:

>> Can you write a test (or set of) for fstests that exercises this new
>> functionality? I'm not worried about performance, just
>> correctness....
>
> Sure thing. Can you point me at the fstests repo? A quick google
> search reveals lots of projects named fstests, most of them abandoned.

I think he's referring to xfstests.  Still, I think that's the wrong
place for functional testing.  ltp would be better, imo.

Cheers,
Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
