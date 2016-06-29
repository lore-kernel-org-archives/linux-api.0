From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] block: require write_same and discard requests align
	to logical block size
Date: Wed, 29 Jun 2016 00:58:06 -0400
Message-ID: <yq1oa6ksiap.fsf@sermon.lab.mkp.net>
References: <146612624734.12764.4316680863289411106.stgit@birch.djwong.org>
	<146612626092.12764.773833541076937471.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <146612626092.12764.773833541076937471.stgit@birch.djwong.org>
	(Darrick J. Wong's message of "Thu, 16 Jun 2016 18:17:41 -0700")
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

Darrick> Make sure that the offset and length arguments that we're using
Darrick> to construct WRITE SAME and DISCARD requests are actually
Darrick> aligned to the logical block size.  Failure to do this causes
Darrick> other errors in other parts of the block layer or the SCSI
Darrick> layer because disks don't support partial logical block writes.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
