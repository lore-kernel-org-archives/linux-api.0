From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Tue, 15 Mar 2016 13:43:01 -0700
Message-ID: <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
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
	<20160315201431.GG30721@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160315201431.GG30721@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 1:14 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>
> Root can still change the group id of a file that has exposed stale
> data and hence make it visible outside of the group based
> containment wall.

Ok, Dave, now you're just being ridiculous.

The issue has never been - and *should* never be - that stale data
cannot get out.

The only issue is that we shouldn't make it ridiculously easy to make
silly mistakes.

There's no "group based containment wall" that is some kind of
absolute protection border.

Put another way: this is not about theoretical leaks - because those
are totally irrelevant (in theory, the original discard writer had
access to all that stale data anyway). This is about making it a
practical interface that doesn't have serious hidden gotchas.

So stop making silly theoretical arguments that make no sense.

We should make sure that we have _practical_ rules that are sensible,
but also not painful enough for the people who want to use this in
_practice_.

Reality trumps everything else.

If google is already using this kind of interface, then that is
_reality_. Take that into account.

             Linus
