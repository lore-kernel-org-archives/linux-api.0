From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 0/5] AIO add per-command iopriority
Date: Tue, 22 May 2018 19:30:19 +0100
Message-ID: <20180522183019.GD30522@ZenIV.linux.org.uk>
References: <20180522175221.2391-1-adam.manzanares@wdc.com>
 <da84d129-4dcd-c861-bfc4-62cd425e60e3@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <da84d129-4dcd-c861-bfc4-62cd425e60e3@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: adam.manzanares@wdc.com, linux-fsdevel@vger.kernel.org, bcrl@kvack.org, mingo@kernel.org, tglx@linutronix.de, kstewart@linuxfoundation.org, peterz@infradead.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, bigeasy@linutronix.de, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, hch@infradread.org, jmoyer@redhat.com
List-Id: linux-api@vger.kernel.org

On Tue, May 22, 2018 at 11:55:04AM -0600, Jens Axboe wrote:
> On 5/22/18 11:52 AM, adam.manzanares@wdc.com wrote:
> > From: Adam Manzanares <adam.manzanares@wdc.com>
> > 
> > This is the per-I/O equivalent of the ioprio_set system call.
> > See the following link for performance implications on a SATA HDD:
> > https://lkml.org/lkml/2016/12/6/495
> > 
> > First patch factors ioprio_check_cap function out of ioprio_set system call to
> > also be used by the aio ioprio interface.
> > 
> > Second patch converts kiocb ki_hint field to a u16 to avoid kiocb bloat.
> > 
> > Third patch passes ioprio hint from aio iocb to kiocb and initializes kiocb
> > ioprio value appropriately when it is not explicitly set.
> > 
> > Fourth patch enables the feature for blkdev.
> > 
> > Fifth patch enables the feature for iomap direct IO
> 
> LGTM, you can add:
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> 
> Al, are you picking this series up, or should I?

Probably better if I do, once I finish reviewing Christoph's patchset -
we already have a bunch of stuff around fs/aio.c in this cycle...
