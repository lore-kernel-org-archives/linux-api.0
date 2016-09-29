From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 3/3] block: implement (some of) fallocate for block
 devices
Date: Thu, 29 Sep 2016 13:08:57 -0700
Message-ID: <423d057c-d2cc-9039-d8ee-c6526be3ae46@sandisk.com>
References: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
 <147510959149.8940.2897845352082568677.stgit@birch.djwong.org>
 <20160929021900.GA4901@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160929021900.GA4901-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "tytso-3s7WtUTddSA@public.gmane.org" <tytso-3s7WtUTddSA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org" <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/28/2016 07:19 PM, Darrick J. Wong wrote:
> After much discussion, it seems that the fallocate feature flag
> FALLOC_FL_ZERO_RANGE maps nicely to SCSI WRITE SAME; and the feature
> FALLOC_FL_PUNCH_HOLE maps nicely to the devices that have been
> whitelisted for zeroing SCSI UNMAP.  Punch still requires that
> FALLOC_FL_KEEP_SIZE is set.  A length that goes past the end of the
> device will be clamped to the device size if KEEP_SIZE is set; or will
> return -EINVAL if not.  Both start and length must be aligned to the
> device's logical block size.
>
> Since the semantics of fallocate are fairly well established already,
> wire up the two pieces.  The other fallocate variants (collapse range,
> insert range, and allocate blocks) are not supported.

For the FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | 
FALLOC_FL_NO_HIDE_STALE case, it's probably safer not to try to send a 
discard to block devices that do not support discard in order not to hit 
block driver bugs. But that's something we can still discuss later. Hence:

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
