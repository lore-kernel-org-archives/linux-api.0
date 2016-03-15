From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Tue, 15 Mar 2016 16:06:10 -0700
Message-ID: <CA+55aFxCpza3_3J8kP9E0gLKHiSitZHjC4UMS_ZfZ_HBTC9=Bg@mail.gmail.com>
References: <CALCETrX5Hr6=yWPrNrh2u3YZNYmmv5ZdOQXcgNX5xr54N+Cfvw@mail.gmail.com>
	<CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w@mail.gmail.com>
	<20160311223047.GZ30721@dastard>
	<20160312003556.GF32214@thunk.org>
	<CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
	<20160313233049.GA30721@dastard>
	<56E69398.7030508@redhat.com>
	<20160314144603.GO29218@thunk.org>
	<20160315201431.GG30721@dastard>
	<CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
	<20160315223313.GH30721@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160315223313.GH30721@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>, Andy Lutomirski <luto@amacapital.net>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Gregory Farnum <greg@gregs42.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 3:33 PM, Dave Chinner <david@fromorbit.com> wrote:
>
>> There's no "group based containment wall" that is some kind of
>> absolute protection border.
>
> Precisely my point - it's being pitched as a generic containment
> mechanism, but it really isn't.

No it hasn't.

It has been pitched as

 "Companies are already doing this, and other groups are interested in it too".

What part of that is hard to understand?

At no point was it "generic containment" except in your mind.
Everybody else was very clear about the fact that stale data would be
visible. The only issue was to try to mitigate subtle mistakes.

And no, "Root reads a file that has possibly stale data in it" is not
a "subtle mistake". That's a rather obvious thing.

> Making Google's hack more widely available through the fallocate
> API is entirely dependent on proving that:
>
>         a) the performance problem still exists;
>         b) the performance problem exists across multiple
>            filesytsems and is not isolated to just ext4 or one specific
>            set of workloads;
>         c) the performance problem cannot be fixed;
>         d) ext4 can't implement a simple feature check to turn off
>            unwritten extents similar to XFS; and
>         e) if all else fails, that the API hack does not compromise the
>            security of general users unaware that applications might
>            be using this functionality.
>
> a), b), c) and d) have not been demonstrated, discussed or iterated -

The thing is, the onus of those shouldn't be on the people who already
have a solution that they are happy with.

The onus of that work should be on the people who are arguing against
it, and have alternate models they want to push.

So you can't ask people who already solved their issue to then try to
argue against their solution.

I do agree that it would be damn useful to have

 (a) numbers. No question about that.

 (b) we should have a better idea of exactly what the user needs are.
Because if we do expose this kind of functionality, it should be as
limited as possible - but that "as possible" very much depends on what
the usage models are.

And yes, "keep the patch entirely inside google" is obviously one good
way to limit the interface. But if there are really other groups that
want to explore this, then that sounds like a pretty horrible model
too.

                  Linus
