From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Thu, 17 Mar 2016 10:47:29 -0700
Message-ID: <CA+55aFzbzXb9ApP5FnVZihWRpWGO1-YnJj_Giip5LfD6=uvf0w@mail.gmail.com>
References: <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
	<20160313233049.GA30721@dastard>
	<56E69398.7030508@redhat.com>
	<20160314144603.GO29218@thunk.org>
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
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC6JEv-CGaphHj6hVXUhFS+Dc4jS46nO1yOfKF5yA8AnDwqgOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>
Cc: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Martin Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 16, 2016 at 10:18 PM, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org> wrote:
>
> So we've not asked for NO_HIDE_STALE on the mailing lists, but I think
> it was one of the problems Sage had using xfs in his BlueStore
> implementation and was a big part of why it moved to pure userspace.
> FileStore might use NO_HIDE_STALE in some places but it would be
> pretty limited. When it came up at Linux FAST we were discussing how
> it and similar things had been problems for us in the past and it
> would've been nice if they were upstream.

Hmm.

So to me it really sounds like somebody should cook up a patch, but we
shouldn't put it in the upstream kernel until we get numbers and
actual "yes, we'd use this" from outside of google.

I say "outside of google", because inside of google not only do we not
get numbers, but google can maintain their own patch.

But maybe Ted could at least post the patch google uses, and somebody
in the Ceph community might want to at least try it out...

>                                                                What *is* a big deal for
> FileStore (and would be easy to take advantage of) is the thematically
> similar O_NOMTIME flag, which is also about reducing metadata updates
> and got blocked on similar stupid-user grounds (although not security
> ones): http://thread.gmane.org/gmane.linux.kernel.api/10727.

Hmm. I don't hate that patch, because the NOATIME thing really does
wonders on many loads. NOMTIME makes sense.

It's not like you can't do this with utimes() anyway.

That said, I do wonder if people wouldn't just prefer to expand on and
improve on the lazytime.

Is there some reason you guys didn't use that?

> As noted though, we've basically given up and are moving to a
> pure-userspace solution as quickly as we can.

That argues against worrying about this all in the kernel unless there
are other users.

                  Linus
