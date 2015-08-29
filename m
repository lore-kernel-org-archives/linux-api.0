From: Christoph Hellwig <hch@lst.de>
Subject: Re: Persistent Reservation API V3
Date: Sat, 29 Aug 2015 15:52:25 +0200
Message-ID: <20150829135225.GB13103@lst.de>
References: <1440608214-14497-1-git-send-email-hch@lst.de> <55E10BE4.6080400@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55E10BE4.6080400@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Aug 28, 2015 at 08:33:24PM -0500, Jeremy Linton wrote:
> Hello,
> 	So, looking at this, I don't see how it supports the algorithm I've been using
> for years. For that algorithm to successfully migrate PRs across multiple paths
> on a single machine without affecting other possible users (who may legitimately
> have PR'ed the same device) I need PR_IN SA 1, READ RESERVATIONS to assure the
> current node owns the reservation before attempting to preempt it on another
> path. This can also assure that the device hasn't been reserved with a legacy
> reservation.

Do you have any code describing this in more detail?  We could add the
read side as well if there is strong interest.

> 	So, this leads me to two more general questions. The first is why isn't the PR
> API simply exported to filesystems as a general reserve/release so that the PR
> happens during mount/dismount. Then DM and friends can be setup to transparently
> migrate or share the reservation, rather than depending on userspace to handle
> these operations...

The API can be used by file systems, and my upcoming NFS SCSI layout
support was the main reason to write this.

> 	Also, it seems to me the use of CLEAR is extremely dangerous in any environment
> where actual arbitration or sharing of the resource is taking place.

Yes, but having it as a specific API isn't any less dangerous than
having it issued using SG_IO.  Reservations really only make sense if
you assume every user of a LU is actually cooperating in some way
and not actively hostile.
