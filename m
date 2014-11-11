From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
Date: Tue, 11 Nov 2014 18:21:23 -0500
Message-ID: <x49bnod1fyk.fsf@segfault.boston.devel.redhat.com>
References: <cover.1415636409.git.milosz@adfin.com>
	<20141111064417.GT23575@dastard>
	<CANP1eJHfWT0Foe+weB1SJkJ10JnOge_g=E8CXBsQNPW7i2+4NA@mail.gmail.com>
	<x49ioilbrfx.fsf@segfault.boston.devel.redhat.com>
	<20141111214240.GV23575@dastard>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20141111214240.GV23575@dastard> (Dave Chinner's message of "Wed,
	12 Nov 2014 08:42:40 +1100")
Sender: owner-linux-aio@kvack.org
To: Dave Chinner <david@fromorbit.com>
Cc: Milosz Tanski <milosz@adfin.com>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Tue, Nov 11, 2014 at 12:03:14PM -0500, Jeff Moyer wrote:
>> Milosz Tanski <milosz@adfin.com> writes:
>> 
>> >> Can you write a test (or set of) for fstests that exercises this new
>> >> functionality? I'm not worried about performance, just
>> >> correctness....
>> >
>> > Sure thing. Can you point me at the fstests repo? A quick google
>> > search reveals lots of projects named fstests, most of them abandoned.
>> 
>> I think he's referring to xfstests.  Still, I think that's the wrong
>> place for functional testing.  ltp would be better, imo.
>
> I don't follow. Can you explain why is xfstests be the wrong place
> to exercise this functionality and what makes ltp a better choice?

Right, I should have made a case for that.  ltp already has test cases
for system calls such as readv/writev (though they are woefully
inadequate).  It simply looked like a better fit to me.  For some reason
I view xfstests as a regression test suite, but I know that isn't
strictly true.

If you feel xfstests is a better place, and Ted makes a good case for
that choice, then that's fine with me.  I'm not, as Ted worried,
insisting on putting test cases into ltp.  :)  I was expressing my
opinion, and am happy for the dialog.

Cheers,
Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
