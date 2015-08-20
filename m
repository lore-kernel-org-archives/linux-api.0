From: Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Persistent Reservation API V2
Date: Thu, 20 Aug 2015 23:56:36 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1508202317270.15930@localhost.lm.intel.com>
References: <1439360604-16192-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439360604-16192-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 11 Aug 2015, Christoph Hellwig wrote:
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

Hi Christoph,

I wrote an nvme implementation and it seems to work as expected with your
pr-tests (minor modification to open an nvme target). While API appears to
work as designed, there are a few features of NVMe that are unreachable
with it. For example, NVMe can ignore existing keys when acquiring a
reservation in addition to registering a new key. NVMe can also specify
if whether or not a reservation should persist through power-loss.

Anyway, I don't think SCSI has these same options. Should this new IOCTL
API accommodate the common subset to maintain its simplicity, or make
it more expressive for all features? The more important question might
be if there are any users requiring these features, and I honestly don't
know that right now.
