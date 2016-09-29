From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] block: implement (some of) fallocate for block
 devices
Date: Thu, 29 Sep 2016 07:57:13 +0200
Message-ID: <7f5bf66e-cbe7-3ec3-3325-0a2e01a54593@suse.de>
References: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
 <147510959149.8940.2897845352082568677.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <147510959149.8940.2897845352082568677.stgit@birch.djwong.org>
Sender: linux-block-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, bart.vanassche@sandisk.com
List-Id: linux-api@vger.kernel.org

On 09/29/2016 02:39 AM, Darrick J. Wong wrote:
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
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: Incorporate feedback from Christoph & Linus.  Tentatively add
> a requirement that the fallocate arguments be aligned to logical block
> size, and put in a few XXX comments ahead of LSF discussion.
> v3: Forward port to 4.7.
> v4: Forward port to 4.8.
> ---
>  fs/block_dev.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/open.c      |    3 +-
>  2 files changed, 80 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
