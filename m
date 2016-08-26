From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v10 0/3] fallocate for block devices
Date: Thu, 25 Aug 2016 22:15:52 -0400
Message-ID: <yq1shtsb7hj.fsf@sermon.lab.mkp.net>
References: <147216972158.7860.13484490862091226290.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <147216972158.7860.13484490862091226290.stgit@birch.djwong.org>
	(Darrick J. Wong's message of "Thu, 25 Aug 2016 17:02:01 -0700")
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, bart.vanassche@sandisk.com
List-Id: linux-api@vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:

Darrick,

Darrick> This is a redesign of the patch series that fixes various
Darrick> interface problems with the existing "zero out this part of a
Darrick> block device" code.  BLKZEROOUT2 is gone.

Looks good to me. Let's get this merged. Pretty please!

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
