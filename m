From: Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Wed, 16 Mar 2016 22:18:19 -0700
Message-ID: <CAC6JEv-CGaphHj6hVXUhFS+Dc4jS46nO1yOfKF5yA8AnDwqgOw@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E9FB73.6040803-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Martin Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 16, 2016 at 5:33 PM, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> I may have lost the thread at this point, with poor Darrick's original
> patch submission devolving into a long thread about a NO_HIDE_STALE patch
> used at Google, but I don't *think* Ceph ever asked for NO_HIDE_STALE.
>
> At least I can't find any indication of that.
>
> Am I missing something?  cc'ing Greg on this one in case I am.

Brief background:
Ceph currently has two big local storage subsystems: FileStore and
BlueStore. FileStore is the one that's been around for forever and is
currently stable/production-ready/bla bla bla. This one represents
RADOS objects as actual files and while it's *mostly* just converting
object operations into posix FS ones, it does rely on a few pieces of
the fs namespace and posix ops to do its work.
BlueStore is our new, pure userspace solution (Sage started this about
8 months ago, I think?). It started out using xfs basically as a block
allocator, but at this point it's just doing raw block access 100% in
userspace.

So we've not asked for NO_HIDE_STALE on the mailing lists, but I think
it was one of the problems Sage had using xfs in his BlueStore
implementation and was a big part of why it moved to pure userspace.
FileStore might use NO_HIDE_STALE in some places but it would be
pretty limited. When it came up at Linux FAST we were discussing how
it and similar things had been problems for us in the past and it
would've been nice if they were upstream. What *is* a big deal for
FileStore (and would be easy to take advantage of) is the thematically
similar O_NOMTIME flag, which is also about reducing metadata updates
and got blocked on similar stupid-user grounds (although not security
ones): http://thread.gmane.org/gmane.linux.kernel.api/10727.
As noted though, we've basically given up and are moving to a
pure-userspace solution as quickly as we can. So no, Ceph isn't likely
to be a big user of these interfaces as it's too late for us. Adding
them would be an investment for future distributed storage systems
more than current ones. Maybe that's not worth it, or maybe there are
better places to keep them in the kernel. (I think I saw a reference
to some hypothetical shared block allocator? That would be *awesome*.)

=========
Separately. In the particular case of the extents and data leaks, a
coworker of mine suggested you could tag any files which *ever* had
unwritten extents with something that prevents them being read by a
user who doesn't have raw block access (and, even better, let us apply
that flag on file create)...that's a weird new security rule for
people to know and requires space for tagging (no idea how bad that
is), but would work in any use cases we have and would not leak
anything the user doesn't already have access to.
-Greg
