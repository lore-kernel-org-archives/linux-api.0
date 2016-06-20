From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 2/3] block: require write_same and discard requests align
 to logical block size
Date: Mon, 20 Jun 2016 14:37:06 +0200
Message-ID: <3470c511-59f5-ff7d-b4b0-22d7d8a2a6e7@acm.org>
References: <146612624734.12764.4316680863289411106.stgit@birch.djwong.org>
 <146612626092.12764.773833541076937471.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <146612626092.12764.773833541076937471.stgit@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>
List-Id: linux-api@vger.kernel.org

On 06/17/2016 03:19 AM, Darrick J. Wong wrote:
> Make sure that the offset and length arguments that we're using to
> construct WRITE SAME and DISCARD requests are actually aligned to the
> logical block size.  Failure to do this causes other errors in other
> parts of the block layer or the SCSI layer because disks don't support
> partial logical block writes.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

