From: Christoph Hellwig <hch@lst.de>
Subject: Re: Persistent Reservation API V2
Date: Fri, 21 Aug 2015 08:59:54 +0200
Message-ID: <20150821065954.GA14559@lst.de>
References: <1439360604-16192-1-git-send-email-hch@lst.de> <alpine.LNX.2.00.1508202317270.15930@localhost.lm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1508202317270.15930@localhost.lm.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@fb.com>, linux-api@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 20, 2015 at 11:56:36PM +0000, Keith Busch wrote:

> NVMe can also specify
> if whether or not a reservation should persist through power-loss.

SCSI does as well, it's the APTPL flag.  However reservations not persistent
through a power loss are basically useless, so I decided to force them on
in the API.  From the documentation:

"All implementations are expected to ensure the reservations survive
 a power loss"

So I would prefer not to add it, or if we really have to as a negative flag
to specifically opt out of the APTPL behavior.

> with it. For example, NVMe can ignore existing keys when acquiring a
> reservation in addition to registering a new key.

This sounds like a sensible addition to me, and I wouldn't be surprised
if future SPC versions will add this flag.
