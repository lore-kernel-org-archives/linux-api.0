From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Thu, 17 Mar 2016 10:59:21 -0700
Message-ID: <CA+55aFzVgxUrBdW3oHHzZ302ppzw_Fnynxi4_BPLQ-1xOOLQHw@mail.gmail.com>
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
	<56EAEE79.4030809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <56EAEE79.4030809@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Gregory Farnum <greg@gregs42.com>, Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Andy Lutomirski <luto@amacapital.net>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Martin Petersen <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 17, 2016 at 10:50 AM, Ric Wheeler <rwheeler@redhat.com> wrote:
>>
>> That argues against worrying about this all in the kernel unless there
>> are other users.
>
> Just a note, when Greg says "user space solution", Ceph is looking at
> writing directly to raw block devices which is kind of a through back to
> early enterprise database trends.

Right, I understand. But that makes it kind of pointless to worry
about NO_HIDE_STALE, since it wouldn't get used anyway. The issues
with filesystem preallocation just don't exist.

Of course, if there are other possible users, we should keep this on
the table, but ...

                 Linus
