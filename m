From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] block: require write_same and discard requests align
 to logical block size
Date: Tue, 15 Mar 2016 00:34:55 -0700
Message-ID: <20160315073455.GH11669@infradead.org>
References: <20160305005556.29738.66782.stgit@birch.djwong.org>
 <20160305005610.29738.18727.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160305005610.29738.18727.stgit@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, torvalds@linux-foundation.org, hch@infradead.org, tytso@mit.edu, martin.petersen@oracle.com, linux-api@vger.kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, bfields@fieldses.org, linux-fsdevel@vger.kernel.org, jlayton@poochiereds.net, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 04, 2016 at 04:56:10PM -0800, Darrick J. Wong wrote:
> Make sure that the offset and length arguments that we're using to
> construct WRITE SAME and DISCARD requests are actually aligned to the
> logical block size.  Failure to do this causes other errors in other
> parts of the block layer or the SCSI layer because disks don't support
> partial logical block writes.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
