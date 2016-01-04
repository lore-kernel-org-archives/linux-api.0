From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: selective block polling and preadv2/pwritev2 revisited
Date: Mon, 4 Jan 2016 17:39:50 +0100
Message-ID: <20160104163949.GA17409@lst.de>
References: <1450966464-6847-1-git-send-email-hch@lst.de> <568A889E.4020204@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <568A889E.4020204-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 04, 2016 at 04:58:38PM +0200, Sagi Grimberg wrote:
> Hi Christoph,
>
>> Note that there are plenty of other use cases for preadv2/pwritev2 as well,
>> but I'd like to concentrate on this one for now.  Example are: non-blocking
>> reads (the original purpose), per-I/O O_SYNC, user space support for T10
>> DIF/DIX applications tags and probably some more.
>
> So I'm trying to understand how can integrity metadata be used here.
> Will the user-app append the meta-data to the data iovec (given there
> is no metadata iovec)? If so, how will we separate data from metadata?

The idea that was floated aroud a few times was to have a flag where
the first half of the vectors would be the data, and the second half
the metadata.
