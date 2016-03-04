From: Thomas Schoebel-Theuer <tst-0Nly+W1lFbFDiq0p6IFu4YQuADTiUCJX@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Fri, 4 Mar 2016 03:30:08 +0100
Message-ID: <56D8F330.5060408@schoebel-theuer.de>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
 <20160302040947.16685.42926.stgit@birch.djwong.org>
 <CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
 <20160302225601.GB21890@birch.djwong.org>
 <CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
 <yq1bn6v8mqg.fsf@sermon.lab.mkp.net> <20160303180924.GA4116@infradead.org>
 <yq1vb5375oh.fsf@sermon.lab.mkp.net> <20160303225646.GT29057@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160303225646.GT29057@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/03/2016 11:56 PM, Dave Chinner wrote:
> That "new kind of write command" would enable delayed allocation
> algorithms to continue to work at the filesystem level on block
> devices that freespace management completely is offloaded to...
> Cheers, Dave. 

This would advocate a uniform /internal/ interface (family) across both
fs and block layers, similiar in spirit to my old Athomux research
prototype long ago (see www.athomux.net).

This allows for recursive nesting in complex (distributed) storage/fs
hierarchies.

It would be nice if that internal interface (family) would be (partly /
fully) asynchronous with callbacks. In ideal case, it should be
compatible with workqueues (no need for blocking threads anymore).

Uniformity is only needed at concept level. There might remain different
flavours of concrete interfaces at different subsystems, if the number
of subsystems remains as small as possible, and interfacing is close to
trivial.

I would like to support this also in future versions of MARS (see
github.com/schoebel/mars).

Cheers, Thomas
