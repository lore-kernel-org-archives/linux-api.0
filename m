From: Jeremy Linton <jlinton-WMdfZNuR64nqlBn2x/YWAg@public.gmane.org>
Subject: Re: Persistent Reservation API V3
Date: Fri, 28 Aug 2015 20:33:24 -0500
Message-ID: <55E10BE4.6080400@tributary.com>
References: <1440608214-14497-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440608214-14497-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,
	So, looking at this, I don't see how it supports the algorithm I've been using
for years. For that algorithm to successfully migrate PRs across multiple paths
on a single machine without affecting other possible users (who may legitimately
have PR'ed the same device) I need PR_IN SA 1, READ RESERVATIONS to assure the
current node owns the reservation before attempting to preempt it on another
path. This can also assure that the device hasn't been reserved with a legacy
reservation.

	So, this leads me to two more general questions. The first is why isn't the PR
API simply exported to filesystems as a general reserve/release so that the PR
happens during mount/dismount. Then DM and friends can be setup to transparently
migrate or share the reservation, rather than depending on userspace to handle
these operations...
	Also, it seems to me the use of CLEAR is extremely dangerous in any environment
where actual arbitration or sharing of the resource is taking place.


	thanks,

On 8/26/2015 11:56 AM, Christoph Hellwig wrote:
> This series adds support for a simplified Persistent Reservation API
> to the block layer.  The intent is that both in-kernel and userspace
> consumers can use the API instead of having to hand craft SCSI or NVMe
> command through the various pass through interfaces.  It also adds
> DM support as getting reservations through dm-multipath is a major
> pain with the current scheme.
> 
> NVMe support currently isn't included as I don't have a multihost
> NVMe setup to test on, but Keith offered to test it and I'll have
> a patch for it shortly.
> 
> The ioctl API is documented in Documentation/block/pr.txt, but to
> fully understand the concept you'll have to read up the SPC spec,
> PRs are too complicated that trying to rephrase them into different
> terminology is just going to create confusion.
> 
> Note that Mike wants to include the DM patches so through the DM
> tree, so they are only included for reference.
> 
> I also have a set of simple test tools available at:
> 
> 	git://git.infradead.org/users/hch/pr-tests.git
> 
> Changes since V2:
>   - added an ignore flag to the reserve opertion as well, and redid
>     the ioctl API to have general flags fields
>   - rebased on top of the latest block layer tree updates
> Changes since V1:
>   - rename DM ->ioctl to ->prepare_ioctl
>   - rename dm_get_ioctl_table to dm_get_live_table_for_ioctl
>   - merge two DM patches into one
>   - various spelling fixes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 
