From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Sat, 12 Mar 2016 02:19:45 -0500
Message-ID: <20160312071945.GA3419@thunk.org>
References: <56E18B9B.5070503@gmail.com>
 <CA+55aFyw1nN4ze3-AGGE27evOZuXnkJC9C-W5QRUR=zKHqObGg@mail.gmail.com>
 <56E24CA5.3030702@redhat.com>
 <20160311135952.57a44931@lxorguk.ukuu.org.uk>
 <CA+55aFwX2GYYN53E9qaTym=gp1aRjSA5f1G+N5WEiRd1dOJhFA@mail.gmail.com>
 <CALCETrX5Hr6=yWPrNrh2u3YZNYmmv5ZdOQXcgNX5xr54N+Cfvw@mail.gmail.com>
 <CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w@mail.gmail.com>
 <20160311223047.GZ30721@dastard>
 <20160312003556.GF32214@thunk.org>
 <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Andy Lutomirski <luto@amacapital.net>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Ric Wheeler <rwheeler@redhat.com>, Gregory Farnum <greg@gregs42.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 04:44:16PM -0800, Linus Torvalds wrote:
> On Fri, Mar 11, 2016 at 4:35 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > At the end of the day it's about whether you trust the userspace
> > program or not.
> 
> There's a big difference between "give the user rope", and "tie the
> rope in a noose and put a banana peel so that the user might stumble
> into the rope and hang himself", though.

So let's see.  The user application has to explicitly request
NO_HIDE_STALE via an fallocate flag --- so it requires changing the
source code and recompiling the application.  And then, the system
administrator has to pass in a mount option specifying a group that
the application has to run under.  And then the application has to run
setgid with that group's privileges.

I hardly think that can be considered handing the user a pre-tied
noose.

Sure, the application can do something stupid --- but I'd arguing
giving root to some junior sysadmin is far more likely to cause
problems.

Cheers,

						- Ted
