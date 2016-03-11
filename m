From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Fri, 11 Mar 2016 09:23:50 -0800
Message-ID: <CA+55aFwX2GYYN53E9qaTym=gp1aRjSA5f1G+N5WEiRd1dOJhFA@mail.gmail.com>
References: <20160302040947.16685.42926.stgit@birch.djwong.org>
	<CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
	<20160302225601.GB21890@birch.djwong.org>
	<CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
	<yq1bn6v8mqg.fsf@sermon.lab.mkp.net>
	<20160303180924.GA4116@infradead.org>
	<yq1vb5375oh.fsf@sermon.lab.mkp.net>
	<20160303223952.GE24012@thunk.org>
	<20160303231050.GU29057@dastard>
	<CAC6JEv-HeAoRxSmVghGvbX7G92yH00k-5F-48qEW13vAB1Q99g@mail.gmail.com>
	<20160309230819.GB3949@thunk.org>
	<56E18B9B.5070503@gmail.com>
	<CA+55aFyw1nN4ze3-AGGE27evOZuXnkJC9C-W5QRUR=zKHqObGg@mail.gmail.com>
	<56E24CA5.3030702@redhat.com>
	<20160311135952.57a44931@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160311135952.57a44931@lxorguk.ukuu.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Gregory Farnum <greg@gregs42.com>, Dave Chinner <david@fromorbit.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 5:59 AM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>
> > > We can do the security check at the filesystem level, because we have
> > > sb->s_bdev->bd_inode, and if you have read and write permissions to
> > > that inode, you might as well have permission to create a unsafe hole.
>
> Not if you don't have access to a block device node to open it, or there
> are SELinux rules that control the access. There are cases it isn't
> entirely the same thing as far as I can see. Consider within a container
> for example.

I agree that it's not the same thing, but I don't think it really ends
up mattering.

Either the container is properly separated and set up - in which case
the uid mapping is what protects you - or it isn't - in which case the
container could just mknod whatever hell node it wants anyway.

So we do pretty much have the permission model.

> The paranoid approach would IMHO to have a mount option so you can
> explicitly declare a file system mount should trust its owner/group and
> then that can also be used to wire up any other "unsafe" activities in a
> general "mounted for a special use" option.

I think that a mount option to enable it isn't a bad idea, but the
mount option should be something generic and not be about "this group
is special" which it sounds like google is currently using.

More like "enable hole punching" - which doesn't enable it
unconditionally, you'd still have the security checks.

             Linus
