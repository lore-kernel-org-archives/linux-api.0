From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] block: invalidate the page cache when issuing
 BLKZEROOUT.
Date: Thu, 29 Sep 2016 07:56:03 +0200
Message-ID: <95e7b8a5-49dd-ea06-5fba-8831ef08ca5a@suse.de>
References: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
 <147510957761.8940.14476876584539116975.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <147510957761.8940.14476876584539116975.stgit@birch.djwong.org>
Sender: linux-block-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, bart.vanassche@sandisk.com, Christoph Hellwig <hch@lst.de>
List-Id: linux-api@vger.kernel.org

On 09/29/2016 02:39 AM, Darrick J. Wong wrote:
> Invalidate the page cache (as a regular O_DIRECT write would do) to avoid
> returning stale cache contents at a later time.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  block/ioctl.c |   18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
