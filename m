From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Fri, 18 Mar 2016 00:19:59 -0700
Message-ID: <CA+55aFwYC6xOTXRGsTMc0jizybWcuZxUH4YYKfDNE-df4ixGaA@mail.gmail.com>
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
	<CA+55aFzbzXb9ApP5FnVZihWRpWGO1-YnJj_Giip5LfD6=uvf0w@mail.gmail.com>
	<CAC6JEv-MuU2sWSvftjHhOhZsE2Fz49Ffv6cm1FMnju5egcyvmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC6JEv-MuU2sWSvftjHhOhZsE2Fz49Ffv6cm1FMnju5egcyvmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>
Cc: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Martin Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 17, 2016 at 11:52 PM, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org> wrote:
>
> I wasn't really involved in this stuff but I gather from looking at
> http://www.spinics.net/lists/xfs/msg36869.html that any durability
> command other than fdatasync is going to write out the mtime updates
> to the inodes on disk. Given our durability requirements and the
> guarantees offered about when things actually hit disk, that doesn't
> work for us.

Fair enough. Yes, the lazytime thing doesn't help if you actually sync
the file explicitly, then you'd really do need something like NOMTIME
in order to not dirty the inode itself at all (together with
preallocation - otherwise the inode will be dirty due to the block
allocation updates).

             Linus
