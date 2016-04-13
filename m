From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] block: require write_same and discard requests align
 to logical block size
Date: Wed, 13 Apr 2016 07:23:08 -0700
Message-ID: <20160413142308.GA8429@infradead.org>
References: <20160413040121.10562.98998.stgit@birch.djwong.org>
 <20160413040135.10562.74550.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160413040135.10562.74550.stgit@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 12, 2016 at 09:01:35PM -0700, Darrick J. Wong wrote:
> Make sure that the offset and length arguments that we're using to
> construct WRITE SAME and DISCARD requests are actually aligned to the
> logical block size.  Failure to do this causes other errors in other
> parts of the block layer or the SCSI layer because disks don't support
> partial logical block writes.

FYI, Bart has just been posting a patchset in that includes this, but
goes further.  Can you take a look at it?
