From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Persistent Reservation API V4
Date: Wed, 28 Oct 2015 14:48:33 -0400
Message-ID: <20151028184833.GA21955@redhat.com>
References: <1444911052-9423-1-git-send-email-hch@lst.de>
 <20151028184356.GA21933@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151028184356.GA21933@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@fb.com, linux-scsi@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, keith.busch@intel.com, dm-devel@redhat.com
List-Id: linux-api@vger.kernel.org

On Wed, Oct 28 2015 at  2:43pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Oct 15 2015 at  8:10am -0400,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > This series adds support for a simplified Persistent Reservation API
> > to the block layer.  The intent is that both in-kernel and userspace
> > consumers can use the API instead of having to hand craft SCSI or NVMe
> > command through the various pass through interfaces.  It also adds
> > DM support as getting reservations through dm-multipath is a major
> > pain with the current scheme.
> > 
> > The ioctl API is documented in Documentation/block/pr.txt, but to
> > fully understand the concept you'll have to read up the SPC spec,
> > PRs are too complicated that trying to rephrase them into different
> > terminology is just going to create confusion.
> > 
> > Note that Mike wants to include the DM patches so through the DM
> > tree, so they are only included for reference.
> 
> I looked at these again and the DM changes look good.  Any update on
> if/when the block changes will land?

I should've looked at Jens' tree before asking.. I now see Jens has
for-4.4/reservations

I'll rebase accordingly and pick up the DM changes.
