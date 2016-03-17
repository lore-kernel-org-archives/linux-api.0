From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 17 Mar 2016 13:50:49 -0400
Message-ID: <56EAEE79.4030809@redhat.com>
References: <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
 <20160313233049.GA30721@dastard> <56E69398.7030508@redhat.com>
 <20160314144603.GO29218@thunk.org> <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard> <20160315225224.GD23848@thunk.org>
 <20160316015139.GC5826@birch.djwong.org>
 <7674C689-C07E-4D38-85EB-4FD9B55CBB35@dilger.ca>
 <20160317001502.GF23593@thunk.org> <56E9FB73.6040803@redhat.com>
 <CAC6JEv-CGaphHj6hVXUhFS+Dc4jS46nO1yOfKF5yA8AnDwqgOw@mail.gmail.com>
 <CA+55aFzbzXb9ApP5FnVZihWRpWGO1-YnJj_Giip5LfD6=uvf0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzbzXb9ApP5FnVZihWRpWGO1-YnJj_Giip5LfD6=uvf0w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Gregory Farnum <greg@gregs42.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Andy Lutomirski <luto@amacapital.net>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Martin Petersen <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On 03/17/2016 01:47 PM, Linus Torvalds wrote:
> On Wed, Mar 16, 2016 at 10:18 PM, Gregory Farnum <greg@gregs42.com> wrote:
>> So we've not asked for NO_HIDE_STALE on the mailing lists, but I think
>> it was one of the problems Sage had using xfs in his BlueStore
>> implementation and was a big part of why it moved to pure userspace.
>> FileStore might use NO_HIDE_STALE in some places but it would be
>> pretty limited. When it came up at Linux FAST we were discussing how
>> it and similar things had been problems for us in the past and it
>> would've been nice if they were upstream.
> Hmm.
>
> So to me it really sounds like somebody should cook up a patch, but we
> shouldn't put it in the upstream kernel until we get numbers and
> actual "yes, we'd use this" from outside of google.
>
> I say "outside of google", because inside of google not only do we not
> get numbers, but google can maintain their own patch.
>
> But maybe Ted could at least post the patch google uses, and somebody
> in the Ceph community might want to at least try it out...
>
>>                                                                 What *is* a big deal for
>> FileStore (and would be easy to take advantage of) is the thematically
>> similar O_NOMTIME flag, which is also about reducing metadata updates
>> and got blocked on similar stupid-user grounds (although not security
>> ones): http://thread.gmane.org/gmane.linux.kernel.api/10727.
> Hmm. I don't hate that patch, because the NOATIME thing really does
> wonders on many loads. NOMTIME makes sense.
>
> It's not like you can't do this with utimes() anyway.
>
> That said, I do wonder if people wouldn't just prefer to expand on and
> improve on the lazytime.
>
> Is there some reason you guys didn't use that?
>
>> As noted though, we've basically given up and are moving to a
>> pure-userspace solution as quickly as we can.
> That argues against worrying about this all in the kernel unless there
> are other users.
>
>                    Linus

Just a note, when Greg says "user space solution", Ceph is looking at writing 
directly to raw block devices which is kind of a through back to early 
enterprise database trends.

Ric

