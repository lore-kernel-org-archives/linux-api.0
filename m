From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 17 Mar 2016 08:36:47 -0400
Message-ID: <20160317123647.GI23593@thunk.org>
References: <20160314144603.GO29218@thunk.org>
 <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard>
 <20160315225224.GD23848@thunk.org>
 <20160316015139.GC5826@birch.djwong.org>
 <7674C689-C07E-4D38-85EB-4FD9B55CBB35@dilger.ca>
 <20160317001502.GF23593@thunk.org>
 <56E9FB73.6040803@redhat.com>
 <CAC6JEv-CGaphHj6hVXUhFS+Dc4jS46nO1yOfKF5yA8AnDwqgOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAC6JEv-CGaphHj6hVXUhFS+Dc4jS46nO1yOfKF5yA8AnDwqgOw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gregory Farnum <greg@gregs42.com>
Cc: sandeen@redhat.com, Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ric Wheeler <rwheeler@redhat.com>, Andy Lutomirski <luto@amacapital.net>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Martin Petersen <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 16, 2016 at 10:18:19PM -0700, Gregory Farnum wrote:
> would've been nice if they were upstream. What *is* a big deal for
> FileStore (and would be easy to take advantage of) is the thematically
> similar O_NOMTIME flag, which is also about reducing metadata updates
> and got blocked on similar stupid-user grounds (although not security
> ones): http://thread.gmane.org/gmane.linux.kernel.api/10727.

Try mounting with the lazytime mount option.  That should give you the
nearly all of the metaata update reduction for free.  It is slightly
better optimized for in ext4. but it should work for xfs and btrfs as
well.  The mtime will still get updated on disk about once a day (or
if memory pressure pushes the inode out of memory or on an unmount),
but the in-memory inode has the correct timestamps, so stat will
return the correct mtime value and so the result is POSIX compliant
for those people who still care such things.

(Actually, if you need to pass POSIX conformance testing you should
use strictatime,lazytime so that atime is updated when POSIX mandates
it to be updated.)

						- Ted
