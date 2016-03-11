From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Fri, 11 Mar 2016 10:25:30 -0800
Message-ID: <CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w@mail.gmail.com>
References: <20160302040947.16685.42926.stgit@birch.djwong.org>
	<CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
	<20160302225601.GB21890@birch.djwong.org>
	<CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
	<yq1bn6v8mqg.fsf@sermon.lab.mkp.net>
	<20160303180924.GA4116@infradead.org>
	<yq1vb5375oh.fsf@sermon.lab.mkp.net>
	<20160303223952.GE24012@thunk.org>
	<20160303231050.GU29057@dastard>
	<CAC6JEv-HeAoRxSmVghGvbX7G92yH00k-5F-48qEW13vAB1Q99g@mail.gmail.com>
	<20160309230819.GB3949@thunk.org>
	<56E18B9B.5070503@gmail.com>
	<CA+55aFyw1nN4ze3-AGGE27evOZuXnkJC9C-W5QRUR=zKHqObGg@mail.gmail.com>
	<56E24CA5.3030702@redhat.com>
	<20160311135952.57a44931@lxorguk.ukuu.org.uk>
	<CA+55aFwX2GYYN53E9qaTym=gp1aRjSA5f1G+N5WEiRd1dOJhFA@mail.gmail.com>
	<CALCETrX5Hr6=yWPrNrh2u3YZNYmmv5ZdOQXcgNX5xr54N+Cfvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrX5Hr6=yWPrNrh2u3YZNYmmv5ZdOQXcgNX5xr54N+Cfvw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Ric Wheeler <rwheeler@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Gregory Farnum <greg@gregs42.com>, Dave Chinner <david@fromorbit.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 9:30 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> What if we had an ioctl to do these data-leaking operations that took,
> as an extra parameter, an fd to the block device node.  They allow
> access if the fd points to the right inode and has FMODE_READ (and LSM
> checks say it's okay).  Sure, it's awkward, but it's much safer.

That sounds absolutely horrible.

I'd *much* prefer the suggestion from Alan to simply have a mount-time
option to enable it. That way, you will never get any surprises, and
no "subtle new behavior for somebody who set their system up in a way
that doesn't allow for this".

So you'd have to explicitly say "my setup is ok with hole punching".

                Linus
