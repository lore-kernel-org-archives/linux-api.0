From: Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Wed, 9 Mar 2016 14:20:31 -0800
Message-ID: <CAC6JEv-HeAoRxSmVghGvbX7G92yH00k-5F-48qEW13vAB1Q99g@mail.gmail.com>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
	<20160302040947.16685.42926.stgit@birch.djwong.org>
	<CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
	<20160302225601.GB21890@birch.djwong.org>
	<CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
	<yq1bn6v8mqg.fsf@sermon.lab.mkp.net>
	<20160303180924.GA4116@infradead.org>
	<yq1vb5375oh.fsf@sermon.lab.mkp.net>
	<20160303223952.GE24012@thunk.org>
	<20160303231050.GU29057@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160303231050.GU29057@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 3, 2016 at 3:10 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrot=
e:
> On Thu, Mar 03, 2016 at 05:39:52PM -0500, Theodore Ts'o wrote:
>> On Thu, Mar 03, 2016 at 01:54:54PM -0500, Martin K. Petersen wrote:
>> > >>>>> "Christoph" =3D=3D Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wri=
tes:
>> >
>> > Christoph>  - FALLOC_FL_PUNCH_HOLE assures zeroes are returned, bu=
t
>> > Christoph> space is deallocated as much as possible -
>> > Christoph> FALLOC_FL_ZERO_RANGE assures zeroes are returned, AND b=
locks
>> > Christoph> are actually allocated
>> >
>> > That works for me. I think it would be great if we could have cons=
istent
>> > interfaces for fs and block. The more commonality the merrier.
>>
>> So a question I have is do we want to add a "discard-as-a-hint" anal=
og
>> for fallocate?
>
> Well defined, reliable behaviour only, please. If the device can't
> provide the required hardware offload, then it needs to use the
> generic, slow implementation of the functionality or report
> EOPNOTSUPP.
>
>> P.S.  Speaking of things that are powerful and too dangerous for
>> application programmers, after the Linux FAST workshop, I was having
>> dinner with the Ceph developers and Ric Wheeler, and we were talking
>> about things they really needed.  Turns out they also could use an
>> FALLOC_FL_NO_HIDE_STALE functionality.
>
> For better or for worse, Ceph is moving away from using filesystems
> for its back end object store, so the use of such a hack in Ceph
> has a very limited life.

Well, let's be clear: the reason Ceph is moving away from using local
filesystems is because we couldn't get the overheads of using them
down to what we considered an acceptable level. There are always going
to be some inefficiencies from it of course (since you have two
metadata streams) but the more issues get addressed, the fewer
userspace filesystems will feel or run up against the need to do their
own block device management. :) If none of them get fixed the same
scenario will just repeat itself =E2=80=94 a userspace filesystem rises=
, it
tries to get features it needs into the kernel, it eventually gives up
and drops the kernel out of the loop, and then the fact that nobody's
using the kernel in this scenario will be considered a reason not to
make it work better.

I really am sensitive to the security concerns, just know that if it's
a permanent blocker you're essentially blocking out a growing category
of disk users (who run on an awfully large number of disks!).
-Greg

>
>> I told them I had an
>> out-of-tree patch that had that functionality, and even Ric Wheeler
>> started getting tempted....  :-)
>
> You can tempt all you want, but it does not change the basic fact
> that it is dangerous and compromises system security. As such, it
> does not belong in upstream kernels. Especially in this day and age
> where ensuring the fundamental integrity of our systems is more
> important than ever.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
