From: Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Tue, 15 Mar 2016 19:30:14 -0500
Message-ID: <56E8A916.8050702@redhat.com>
References: <20160311223047.GZ30721@dastard>
 <20160312003556.GF32214@thunk.org>
 <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
 <20160313233049.GA30721@dastard> <56E69398.7030508@redhat.com>
 <20160314144603.GO29218@thunk.org> <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard>
 <CA+55aFxCpza3_3J8kP9E0gLKHiSitZHjC4UMS_ZfZ_HBTC9=Bg@mail.gmail.com>
 <20160315235216.GI30721@dastard>
 <CA+55aFxZ=feGd+QGdhCN28kjd2XJO3PCj9NBoJJZ5E8_WMJiMA@mail.gmail.com>
Reply-To: sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFxZ=feGd+QGdhCN28kjd2XJO3PCj9NBoJJZ5E8_WMJiMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 3/15/16 7:06 PM, Linus Torvalds wrote:
> On Tue, Mar 15, 2016 at 4:52 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>> >
>> > It is pretty clear that the onus is on the patch submitter to
>> > provide justification for inclusion, not for the reviewer/Maintainer
>> > to have to prove that the solution is unworkable.
> I agree, but quite frankly, performance is a good justification.
> 
> So if Ted can give performance numbers, that's justification enough.
> We've certainly taken changes with less.

I've been away from ext4 for a while, so I'm really not on top of the
mechanics of the underlying problem at the moment.

But I would say that in addition to numbers showing that ext4 has trouble
with unwritten extent conversion, we should have an explanation of
why it can't be solved in a way that doesn't open up these concerns.

XFS certainly has different mechanisms, but is the demonstrated workload
problematic on XFS (or btrfs) as well?  If not, can ext4 adopt any of the
solutions that make the workload perform better on other filesystems?

Adding the risk and complexity of the stale data exposure should be
considered as a last resort, after the above questions have been answered.

-Eric
