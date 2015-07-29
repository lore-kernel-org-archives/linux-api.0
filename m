From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 4/6] block: loop: prepare for supporing direct IO
Date: Wed, 29 Jul 2015 18:41:02 +1000
Message-ID: <20150729084102.GB16638@dastard>
References: <1437061068-26118-1-git-send-email-ming.lei@canonical.com>
 <1437061068-26118-5-git-send-email-ming.lei@canonical.com>
 <20150727084020.GA28336@infradead.org>
 <CACVXFVOvnVHNtTkt_kiNZu9BuZHZ==EF4y3qXx+Qo=LHoytODQ@mail.gmail.com>
 <20150727094530.GA15507@infradead.org>
 <CACVXFVMKycx768HtAJXMgEZNjsQrNm_f3UzW9kUysSHAMM5FPQ@mail.gmail.com>
 <20150727173331.GA17594@infradead.org>
 <CACVXFVMkU0TLxys_e3arGChdmgM-P2zQhPBfYx5kUXGbUtd_8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVMkU0TLxys_e3arGChdmgM-P2zQhPBfYx5kUXGbUtd_8A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Justin M. Forbes" <jforbes@fedoraproject.org>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 29, 2015 at 03:33:52AM -0400, Ming Lei wrote:
> On Mon, Jul 27, 2015 at 1:33 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Mon, Jul 27, 2015 at 05:53:33AM -0400, Ming Lei wrote:
> >> Because size has to be 4k aligned too.
> >
> > Yes.  But again I don't see any reason to limit us to a hardcoded 512
> > byte block size here, especially considering the patches to finally
> 
> From loop block's view, the request size can be any count of 512-byte
> sectors, then the transfer size to backing device can't  guarantee to be
> 4k aligned always.

In theory, yes. In practise, doesn't happen very often.

> > allow enabling other block sizes from userspace.
> 
> I have some questions about the patchset, and looks the author doesn't
> reply it yet.
> 
> On Mon, Jul 27, 2015 at 6:06 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> Because size has to be 4k aligned too.
> >
> > So check that, too. Any >= 4k block size filesystem should be doing
> > mostly 4k aligned and sized IO...
> 
> I guess you mean we only use direct IO for the 4k aligned and sized IO?
> If so, that won't be efficient because the page cache has to be flushed
> during the switch.

It will be extremely rare for a 4k block size filesystem to do
anything other than 4k aligned and sized IO. Think about it for a
minute: what does the page cache do to unaligned IO patterns (i.e.
buffered IO)?  It does IO in page sizes, and so if the application
if doing badly aligned or sized IO with buffered IO, then the
underlying device will only ever size page sized and aligned IO.

Hence sector aligned IO will only come from applications doing
direct IO.  If the application is doing direct IO and it's not
properly aligned, then it already is going to get sucky performance
because most filesystem serialise sub-block size direct IO because
concurrent sub-block IOs to the same block usually leads to data
corruption.

So, really, sector aligned/sized direct IO is a sucky performance
path before we even get to the loop device, so we don't really need
to care how fast the loop device handles this case. The loop device
just needs to ensure that it doesn't corrupt data when badly aligned
IOs come in... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
