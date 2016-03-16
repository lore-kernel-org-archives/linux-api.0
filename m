From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Tue, 15 Mar 2016 17:06:00 -0700
Message-ID: <CA+55aFxZ=feGd+QGdhCN28kjd2XJO3PCj9NBoJJZ5E8_WMJiMA@mail.gmail.com>
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
	<20160315235216.GI30721@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160315235216.GI30721@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>, Andy Lutomirski <luto@amacapital.net>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Gregory Farnum <greg@gregs42.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 4:52 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> It is pretty clear that the onus is on the patch submitter to
> provide justification for inclusion, not for the reviewer/Maintainer
> to have to prove that the solution is unworkable.

I agree, but quite frankly, performance is a good justification.

So if Ted can give performance numbers, that's justification enough.
We've certainly taken changes with less.

And with your "we should _not_ do this" argument, the onus is clearly on you.

> "Google uses this" is not sufficient justification.

Not per se, no, but it's a very traditional and time-honored model for
"should we merge this".

It's traditionally been things like "Redhat merged it in their distro
kernel, because they have customers that want/need it". That is *the*
reason many big projects got merged, ranging from filesystems to
drivers etc. Take reiserfs, for example: it got merged because SuSE
was actively using it.

So "this feature is being used in real life" is a big hint that the
standard upstream kernel may be missing something important. People
arguing against things like that has been a big problem in the past.
It took people _years_ to get over the whole Android thing. We need to
merge stuff that people are using and depend on, because _not_ merging
them just causes more and more distance between peoples kernels, and
makes it even harder to merge in the future.

I do agree that we want to have hard numbers.

And I do think that we should strive for the whole "we want to merge"
phase to be a time when we also look at "can we improve the
interfaces". But that can - and often does - go too far. Again, we had
_years_ of pointless masturbation over the whole Android thing, just
because people were making up new interfaces.

               Linus
