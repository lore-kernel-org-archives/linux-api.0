From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range
 of blocks
Date: Fri, 11 Mar 2016 13:59:52 +0000
Message-ID: <20160311135952.57a44931@lxorguk.ukuu.org.uk>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56E24CA5.3030702@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, Gregory Farnum <greg@gregs42.com>, Dave Chinner <david@fromorbit.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-api@vger.kernel.org

> > We can do the security check at the filesystem level, because we have
> > sb->s_bdev->bd_inode, and if you have read and write permissions to
> > that inode, you might as well have permission to create a unsafe hole.

Not if you don't have access to a block device node to open it, or there
are SELinux rules that control the access. There are cases it isn't
entirely the same thing as far as I can see. Consider within a container
for example.

The paranoid approach would IMHO to have a mount option so you can
explicitly declare a file system mount should trust its owner/group and
then that can also be used to wire up any other "unsafe" activities in a
general "mounted for a special use" option.

Alan
