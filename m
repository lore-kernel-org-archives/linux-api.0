From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 3 Mar 2016 12:02:05 -0500
Message-ID: <20160303170205.GD24012@thunk.org>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
 <20160302040947.16685.42926.stgit@birch.djwong.org>
 <CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
 <20160302225601.GB21890@birch.djwong.org>
 <CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 02, 2016 at 03:49:53PM -0800, Linus Torvalds wrote:
> > No.  This is not about enabling use of "that idiotic discard behavior", for
> > that there's BLKDISCARD.  This ioctl does NOT use the handwavy old TRIM
> > advisory request thing that could return "fuzzy wuzzy" without violating the
> > specs.
> 
> So you agree that we could just make BLKZEROOUT always use trim?

There is a massive bug in the SATA specs about trim, which is that it
is considered advisory.  So the storage device can throw it away
whenever it feels like it.  (In practice, when it's too busy doing
other things).

The thing is, this fuzzy wuzzy definition of trim in the SATA specs is
more and more a SATA-specific bug.  The eMMC 5.1 spec has a reliable
trim, and SCSI has WRITE SAME.  So it's just SATA which has this crazy
definition of trim.

(In practice there is no real difference between trim and discard;
it's just a matter of terminology; in order to determine whether or
not trim/discard is reliable you really have to pay close attention to
the specs, on in the case of SATA, use a whitelist of drive models,
which is crazy.)

					- Ted
