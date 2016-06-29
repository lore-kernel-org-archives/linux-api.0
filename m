From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] block: invalidate the page cache when issuing
	BLKZEROOUT.
Date: Wed, 29 Jun 2016 00:57:27 -0400
Message-ID: <yq1shvwsibs.fsf@sermon.lab.mkp.net>
References: <146612624734.12764.4316680863289411106.stgit@birch.djwong.org>
	<146612625412.12764.6647932282740152837.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <146612625412.12764.6647932282740152837.stgit@birch.djwong.org>
	(Darrick J. Wong's message of "Thu, 16 Jun 2016 18:17:34 -0700")
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-api@vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:

Darrick> Invalidate the page cache (as a regular O_DIRECT write would
Darrick> do) to avoid returning stale cache contents at a later time.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
