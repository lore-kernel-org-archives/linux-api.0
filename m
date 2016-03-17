From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Wed, 16 Mar 2016 20:59:23 -0400
Message-ID: <20160317005923.GH23593@thunk.org>
References: <56E69398.7030508@redhat.com>
 <20160314144603.GO29218@thunk.org>
 <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard>
 <20160315225224.GD23848@thunk.org>
 <20160316015139.GC5826@birch.djwong.org>
 <7674C689-C07E-4D38-85EB-4FD9B55CBB35@dilger.ca>
 <20160317001502.GF23593@thunk.org>
 <56E9FB73.6040803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56E9FB73.6040803@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: sandeen@redhat.com
Cc: Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ric Wheeler <rwheeler@redhat.com>, Andy Lutomirski <luto@amacapital.net>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Gregory Farnum <greg@gregs42.com>, Martin Petersen <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 16, 2016 at 07:33:55PM -0500, Eric Sandeen wrote:
> I may have lost the thread at this point, with poor Darrick's original
> patch submission devolving into a long thread about a NO_HIDE_STALE patch
> used at Google, but I don't *think* Ceph ever asked for NO_HIDE_STALE.
> 
> At least I can't find any indication of that.
> 
> Am I missing something?  cc'ing Greg on this one in case I am.

This came up at dinner after the Linux FAST conference where the Ric
Wheeler, some Ceph folks, and I were at dinner, and they were
discussing creating a userspace file systems because they couldn't get
kernel file system developers to be responsive for their needs.  I
pointed out what I had implemented at Google for our cluster file
system, which includes NO_HIDE_STALE_FL and the BLKDISCARD ioctl to
work on ext4 files, both of which I had kept out of tree because they
were rejected last time and Ric Wheeler had threated to patch them out
of the RHEL kernel if they went in upstream.

When Ric indicated that he was now a bit more accepting of these
patches now that he was responsible for managing people who needed the
functionality, I thought it was time to revisit the topic ---
especially since Tao Bao has been using the same patches for their
hadoopfs servers, and at the very least I should offer the patches to
the Ceph folks to see if they could get them into RHEL, and perhaps
take another run at getting the patches upstream.

						- Ted
