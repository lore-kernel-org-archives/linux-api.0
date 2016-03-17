From: Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 17 Mar 2016 09:49:15 -0400
Message-ID: <56EAB5DB.8080106@redhat.com>
References: <56E69398.7030508@redhat.com> <20160314144603.GO29218@thunk.org>
 <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard>
 <CA+55aFxCpza3_3J8kP9E0gLKHiSitZHjC4UMS_ZfZ_HBTC9=Bg@mail.gmail.com>
 <20160315235216.GI30721@dastard>
 <CA+55aFxZ=feGd+QGdhCN28kjd2XJO3PCj9NBoJJZ5E8_WMJiMA@mail.gmail.com>
 <56E8A916.8050702@redhat.com>
 <20160316005117.GA34410@clm-mbp.thefacebook.com>
 <20160316222343.GA53649@clm-mbp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160316222343.GA53649-HIXDwvFErZjFYCXBM6kdu7fOX0fSgVTm@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/16/2016 06:23 PM, Chris Mason wrote:
> On Tue, Mar 15, 2016 at 05:51:17PM -0700, Chris Mason wrote:
>> On Tue, Mar 15, 2016 at 07:30:14PM -0500, Eric Sandeen wrote:
>>> On 3/15/16 7:06 PM, Linus Torvalds wrote:
>>>> On Tue, Mar 15, 2016 at 4:52 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>>>>>> It is pretty clear that the onus is on the patch submitter to
>>>>>> provide justification for inclusion, not for the reviewer/Maintainer
>>>>>> to have to prove that the solution is unworkable.
>>>> I agree, but quite frankly, performance is a good justification.
>>>>
>>>> So if Ted can give performance numbers, that's justification enough.
>>>> We've certainly taken changes with less.
>>> I've been away from ext4 for a while, so I'm really not on top of the
>>> mechanics of the underlying problem at the moment.
>>>
>>> But I would say that in addition to numbers showing that ext4 has trouble
>>> with unwritten extent conversion, we should have an explanation of
>>> why it can't be solved in a way that doesn't open up these concerns.
>>>
>>> XFS certainly has different mechanisms, but is the demonstrated workload
>>> problematic on XFS (or btrfs) as well?  If not, can ext4 adopt any of the
>>> solutions that make the workload perform better on other filesystems?
>> When I've benchmarked this in the past, doing small random buffered writes
>> into an preallocated extent was dramatically (3x or more) slower on xfs
>> than doing them into a fully written extent.  That was two years ago,
>> but I can redo it.
> So I re-ran some benchmarks, with 4K O_DIRECT random ios on nvme (4.5
> kernel).  This is O_DIRECT without O_SYNC.  I don't think xfs will do
> commits for each IO into the prealloc file?  O_SYNC makes it much
> slower, so hopefully I've got this right.
>
> The test runs for 60 seconds, and I used an iodepth of 4:
>
> prealloc file: 32,000 iops
> overwrite:    121,000 iops
>
> If I bump the iodepth up to 512:
>
> prealloc file: 33,000 iops
> overwrite:   279,000 iops
>
> For streaming writes, XFS converts prealloc to written much better when
> the IO isn't random.  You can start seeing the difference at 16K
> sequential O_DIRECT writes, but really its not a huge impact.  The worst
> case is 4K:
>
> prealloc file: 227MB/s
> overwrite:     340MB/s
>
> I can't think of sequential workloads where this will matter, since they
> will either end up with bigger IO or the performance impact won't get
> noticed.
>
> -chris

I think that these numbers are the interesting ones, see a 4x slow down is 
certainly significant.

If you do the same patch after hacking XFS preallocation as Dave suggested with 
xfs_db, do we get most of the performance back?

Ric
