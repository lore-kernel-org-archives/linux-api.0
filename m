From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 6/7] blk-mq: enable polling support by default
Date: Mon, 29 Feb 2016 09:27:13 -0500
Message-ID: <x49wppnmw1q.fsf@segfault.boston.devel.redhat.com>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
	<1456160876-14560-7-git-send-email-hch@lst.de>
	<x49fuwfmcb5.fsf@segfault.boston.devel.redhat.com>
	<20160227085648.GA4255@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160227085648.GA4255@lst.de> (Christoph Hellwig's message of
	"Sat, 27 Feb 2016 09:56:48 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, axboe@fb.com, milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Fri, Feb 26, 2016 at 03:44:30PM -0500, Jeff Moyer wrote:
>> Hi, Christoph,
>> 
>> Christoph Hellwig <hch@lst.de> writes:
>> 
>> > Now that applications need to explicitly ask for polling we can enable it
>> > by default in blk-mq drivers.
>> 
>> I don't think this is a good idea.  I'd just enable it in nvme and the
>> micron driver for now.
>
> I think my wording was a bit unclear - the flag to enable polling is
> enabled everywhere.  You still need to implement the poll blk_mq operation,
> which currently only NVMe implements.

Oh, duh.  Yeah, this is fine, then.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
