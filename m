From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Wed, 16 Mar 2016 07:14:31 +1100
Message-ID: <20160315201431.GG30721@dastard>
References: <20160311135952.57a44931@lxorguk.ukuu.org.uk>
 <CA+55aFwX2GYYN53E9qaTym=gp1aRjSA5f1G+N5WEiRd1dOJhFA@mail.gmail.com>
 <CALCETrX5Hr6=yWPrNrh2u3YZNYmmv5ZdOQXcgNX5xr54N+Cfvw@mail.gmail.com>
 <CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w@mail.gmail.com>
 <20160311223047.GZ30721@dastard>
 <20160312003556.GF32214@thunk.org>
 <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
 <20160313233049.GA30721@dastard>
 <56E69398.7030508@redhat.com>
 <20160314144603.GO29218@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160314144603.GO29218@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Gregory Farnum <greg@gregs42.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 14, 2016 at 10:46:03AM -0400, Theodore Ts'o wrote:
> On Mon, Mar 14, 2016 at 06:34:00AM -0400, Ric Wheeler wrote:
> > I think that once we enter this mode, the local file system has effectively
> > ceded its role to prevent stale data exposure to the upper layer. In effect,
> > this ceases to become a normal file system for any enabled process if we
> > control this through fallocate() or for all processes if we do the brute
> > force mount option that would be file system wide.
> 
> Or we do this via group id, such that we are ceding responsibility for
> proventing stale data exposure to the processes running under that
> group id.  That process has the responsibility for making sure that it
> doesn't return any data from that file unless it has been written, and
> also to make sure the permissions of that file are not readable by
> processes that aren't in that group.  (For example, owned by user
> ceph, group ceph, with premissions 640).

Root can still change the group id of a file that has exposed stale
data and hence make it visible outside of the group based
containment wall. i.e. external actors can still unintentionally
expose stale data, even though the application might be correctly
contained and safe.

What we are missing is actual numbers that show that exposing stale
data is a /significant/ win for these applications that are
demanding it. And then we need evidence proving that the problem is
actually systemic and not just a hack around a bad implementation of
a feature...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
