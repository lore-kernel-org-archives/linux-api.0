From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Wed, 16 Mar 2016 10:52:16 +1100
Message-ID: <20160315235216.GI30721@dastard>
References: <20160311223047.GZ30721@dastard>
 <20160312003556.GF32214@thunk.org>
 <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
 <20160313233049.GA30721@dastard>
 <56E69398.7030508@redhat.com>
 <20160314144603.GO29218@thunk.org>
 <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard>
 <CA+55aFxCpza3_3J8kP9E0gLKHiSitZHjC4UMS_ZfZ_HBTC9=Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxCpza3_3J8kP9E0gLKHiSitZHjC4UMS_ZfZ_HBTC9=Bg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>, Andy Lutomirski <luto@amacapital.net>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Gregory Farnum <greg@gregs42.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 04:06:10PM -0700, Linus Torvalds wrote:
> On Tue, Mar 15, 2016 at 3:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> >> There's no "group based containment wall" that is some kind of
> >> absolute protection border.
> >
> > Precisely my point - it's being pitched as a generic containment
> > mechanism, but it really isn't.
> 
> No it hasn't.
> 
> It has been pitched as
> 
>  "Companies are already doing this, and other groups are interested in it too".
> 
> What part of that is hard to understand?
> 
> At no point was it "generic containment" except in your mind.
> Everybody else was very clear about the fact that stale data would be
> visible. The only issue was to try to mitigate subtle mistakes.
> 
> And no, "Root reads a file that has possibly stale data in it" is not
> a "subtle mistake". That's a rather obvious thing.
> 
> > Making Google's hack more widely available through the fallocate
> > API is entirely dependent on proving that:
> >
> >         a) the performance problem still exists;
> >         b) the performance problem exists across multiple
> >            filesytsems and is not isolated to just ext4 or one specific
> >            set of workloads;
> >         c) the performance problem cannot be fixed;
> >         d) ext4 can't implement a simple feature check to turn off
> >            unwritten extents similar to XFS; and
> >         e) if all else fails, that the API hack does not compromise the
> >            security of general users unaware that applications might
> >            be using this functionality.
> >
> > a), b), c) and d) have not been demonstrated, discussed or iterated -
> 
> The thing is, the onus of those shouldn't be on the people who already
> have a solution that they are happy with.
>
> The onus of that work should be on the people who are arguing against
> it, and have alternate models they want to push.

I hate having to quote the guidelines we are supposed to work by,
but this seems pretty clear cut. Section 2 of
Documentation/SubmittingPatches:

"Describe your problem.  Whether your patch is a one-line bug fix or
5000 lines of a new feature, there must be an underlying problem
that motivated you to do this work.  Convince the reviewer that
there is a problem worth fixing and that it makes sense for them to
read past the first paragraph.

Describe user-visible impact.  Straight up crashes and lockups are
pretty convincing, but not all bugs are that blatant.  Even if the
problem was spotted during code review, describe the impact you think
it can have on users.  Keep in mind that the majority of Linux
installations run kernels from secondary stable trees or
vendor/product-specific trees that cherry-pick only specific patches
from upstream, so include anything that could help route your change
downstream: provoking circumstances, excerpts from dmesg, crash
descriptions, performance regressions, latency spikes, lockups, etc.

Quantify optimizations and trade-offs.  If you claim improvements in
performance, memory consumption, stack footprint, or binary size,
include numbers that back them up.  But also describe non-obvious
costs.  Optimizations usually aren't free but trade-offs between CPU,
memory, and readability; or, when it comes to heuristics, between
different workloads.  Describe the expected downsides of your
optimization so that the reviewer can weigh costs against benefits.

Once the problem is established, describe what you are actually doing
about it in technical detail.  It's important to describe the change
in plain English for the reviewer to verify that the code is behaving
as you intend it to."

It is pretty clear that the onus is on the patch submitter to
provide justification for inclusion, not for the reviewer/Maintainer
to have to prove that the solution is unworkable. "Google uses this"
is not sufficient justification.

> So you can't ask people who already solved their issue to then try to
> argue against their solution.

I'm not asking Ted to argue against his solution. I'm the person who
is trying to poke holes in the "solution" being presented...

> I do agree that it would be damn useful to have
> 
>  (a) numbers. No question about that.
> 
>  (b) we should have a better idea of exactly what the user needs are.
> Because if we do expose this kind of functionality, it should be as
> limited as possible - but that "as possible" very much depends on what
> the usage models are.

It's not "damn useful" - it's an absolute requirement that numbers
are provided to back up the assertion that there is no other way to
solve this problem. Once it is established that there is no other
way to solve the performance problem, then we can talk whether we
want to trade off data safety and complexity for performance....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
