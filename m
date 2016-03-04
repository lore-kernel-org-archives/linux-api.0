From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 3 Mar 2016 19:20:26 -0500
Message-ID: <20160304002026.GG24012@thunk.org>
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
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160303231050.GU29057@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 04, 2016 at 10:10:50AM +1100, Dave Chinner wrote:
> You can tempt all you want, but it does not change the basic fact
> that it is dangerous and compromises system security. As such, it
> does not belong in upstream kernels. Especially in this day and age
> where ensuring the fundamental integrity of our systems is more
> important than ever.

The fact of the matter is as there are more user-space servers for
cluster file systems which are trusted to do the right thing, and are
considered inside the TCB, the demand for this is going to strong.  We
do actually use a group id to provide access control to what is
admittedly a dangerous feature, so it's not available for all
userspace callers, and we didn't want the file server to run as root.

But I'll let the Ceph folks advocate internally for such a feature to
be shipped in RHEL if they feel strongly about it, and if later one we
want to come to an agreement about a better access control mechanism
than membership in a privileged group id passed in as a mount option,
I'm not wedded to that facility.  I didn't think it was worth cracking
open a new capability bit, but if we want to go down that route, or
some other route to provide the appropriate security controls, we
should definitely talk about it.

Cheers,

						- Ted
