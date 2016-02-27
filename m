From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 6/7] blk-mq: enable polling support by default
Date: Sat, 27 Feb 2016 09:56:48 +0100
Message-ID: <20160227085648.GA4255@lst.de>
References: <1456160876-14560-1-git-send-email-hch@lst.de> <1456160876-14560-7-git-send-email-hch@lst.de> <x49fuwfmcb5.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <x49fuwfmcb5.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Feb 26, 2016 at 03:44:30PM -0500, Jeff Moyer wrote:
> Hi, Christoph,
> 
> Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:
> 
> > Now that applications need to explicitly ask for polling we can enable it
> > by default in blk-mq drivers.
> 
> I don't think this is a good idea.  I'd just enable it in nvme and the
> micron driver for now.

I think my wording was a bit unclear - the flag to enable polling is
enabled everywhere.  You still need to implement the poll blk_mq operation,
which currently only NVMe implements.
