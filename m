From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache only)
Date: Thu, 26 Mar 2015 15:12:32 -0400
Message-ID: <CANP1eJGpgXUv626KQb6kduJgMaOzU5hH9GLGBM-QSVUBagoG8w@mail.gmail.com>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326115514.GA12329@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20150326115514.GA12329@infradead.org>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 26, 2015 at 7:55 AM, Christoph Hellwig <hch@infradead.org> wrote:
>
> On Mon, Mar 16, 2015 at 02:27:10PM -0400, Milosz Tanski wrote:
> > This patchset introduces two new syscalls preadv2 and pwritev2. They are the
> > same syscalls as preadv and pwrite but with a flag argument. Additionally,
> > preadv2 implements an extra RWF_NONBLOCK flag.
>
> There was some arugment that we just don't wait and don't have the
> classic unix "blocking" semantics.  Maybe it's time to bite the bullet
> and rename it to RWF_DONTWAIT? (I personally dont really care).


Sure. It is in line with the MSG_DONTWAIT flag for sendmsg() which
this whole idea is based on anyways.

>
>
> Second this probably needs to be on top of Al's for-next tree:
>
>         https://git.kernel.org/cgit/linux/kernel/git/viro/vfs.git/log/?h=for-next
>
> Note that this has a flags field in struct kiocb, so we could just use
> that for the flags.


Okay I started rebasing the patches on-top of that. I did see that
there is a new flags field "ki_flags". I see that there's already a
IOCB_EVENTFD flag.

Did you see you Andres' question about making the flags a enum? I
usually wouldn't do that, because C++ is stronger when it comes enums,
you can't combine them then assignment them to an enum without a cast.
But in the kernel this doesn't matter.

>
>
> Otherwise this version look fine to me, let's get it merged!
>
> Al, are yo ready to pick this up?  I'd hate to miss another merge
> window.


Just got back from vacation today, I'll try to get this out before the
end of the week. I also have to make some adjustments to xfs-tests (to
push preadv2 into xfs_io).


-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
