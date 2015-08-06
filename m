From: Christoph Hellwig <hch@lst.de>
Subject: Re: Persistent Reservation API
Date: Thu, 6 Aug 2015 15:45:58 +0200
Message-ID: <20150806134558.GD1646@lst.de>
References: <1438672271-11309-1-git-send-email-hch@lst.de> <alpine.LNX.2.00.1508041742360.15930@localhost.lm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1508041742360.15930@localhost.lm.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, linux-api@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 04, 2015 at 06:04:04PM +0000, Keith Busch wrote:
> On Tue, 4 Aug 2015, Christoph Hellwig wrote:
>> NVMe support currently isn't included as I don't have a multihost
>> NVMe setup to test on, but if I can find a volunteer to test it I'm
>> happy to write the code for it.
>
> Looks pretty good so far. I'd be happy to give try it out with NVMe
> subsystems.

Thanks, I'll prepare a version once I get a few free minutes.
