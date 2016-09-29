From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/3] block: invalidate the page cache when issuing
	BLKZEROOUT.
Date: Wed, 28 Sep 2016 18:16:13 -0700
Message-ID: <58a6bc29-42d5-92f2-30bf-89168faa8eb0@sandisk.com>
References: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
	<147510957761.8940.14476876584539116975.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <147510957761.8940.14476876584539116975.stgit@birch.djwong.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk, akpm@linux-foundation.org
Cc: hch@infradead.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-api@vger.kernel.org

On 09/28/16 17:39, Darrick J. Wong wrote:
> Invalidate the page cache (as a regular O_DIRECT write would do) to avoid
> returning stale cache contents at a later time.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
