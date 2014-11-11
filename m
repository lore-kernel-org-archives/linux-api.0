From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] block: Introduce blkdev_issue_zeroout_discard() function
Date: Mon, 10 Nov 2014 21:33:48 -0500
Message-ID: <yq1tx264gab.fsf@sermon.lab.mkp.net>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
	<1415336894-15327-4-git-send-email-martin.petersen@oracle.com>
	<20141111000433.GA10047@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20141111000433.GA10047@birch.djwong.org> (Darrick J. Wong's
	message of "Mon, 10 Nov 2014 16:04:33 -0800")
Sender: linux-scsi-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:

Darrick> Can this be plumbed into a BLK* ioctl too?  I'll write a patch,
Darrick> if this is ok with everyone:

Darrick> ...and make it zap the page cache per earlier discussion.  This
Darrick> seems to be a good fit with what we've been discussing for
Darrick> mke2fs.

That sounds good to me. I'll get the updated patch out tomorrow.

-- 
Martin K. Petersen	Oracle Linux Engineering
