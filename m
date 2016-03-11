From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Fri, 11 Mar 2016 10:27:39 -0500
Message-ID: <20160311152739.GC32214@thunk.org>
References: <20160303180924.GA4116@infradead.org>
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
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160311135952.57a44931-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 01:59:52PM +0000, One Thousand Gnomes wrote:
> > > We can do the security check at the filesystem level, because we have
> > > sb->s_bdev->bd_inode, and if you have read and write permissions to
> > > that inode, you might as well have permission to create a unsafe hole.
> 
> Not if you don't have access to a block device node to open it, or there
> are SELinux rules that control the access. There are cases it isn't
> entirely the same thing as far as I can see. Consider within a container
> for example.

In a container shouldn't be a problem so long as we use uid mapping
when making the group id check.

> The paranoid approach would IMHO to have a mount option so you can
> explicitly declare a file system mount should trust its owner/group and
> then that can also be used to wire up any other "unsafe" activities in a
> general "mounted for a special use" option.

Indeed, that's what we're currently doing.  We've acutally been using
different gid's for each "privileged" operation, though, since we want
to have fine-grained access controls.

The process who can perform an operation which can result in the
ability to read stale data might not need (and therefore should not be
given) access to be able to issue TCG/Opal management commands to the
HDD, for example.

	 	    	     	    	 - Ted
