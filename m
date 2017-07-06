From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/2] afs: Add metadata xattrs
Date: Thu, 06 Jul 2017 17:14:11 +0100
Message-ID: <31934.1499357651@warthog.procyon.org.uk>
References: <20170706152304.GA10584@infradead.org> <149935261019.29744.8564287571048506851.stgit@warthog.procyon.org.uk> <149935262759.29744.6299062653432480230.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170706152304.GA10584@infradead.org>
Content-ID: <31933.1499357651.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> NAK.  Don't overload xattrs with magic behavior just to avoid the need
> to do proper syscalls or ioctls.

How?  This has to work on non-files, files you can't open and mountpoints.
You can't do an ioctl() on a file opened O_PATH:

	if (unlikely(f->f_flags & O_PATH)) {
		f->f_mode = FMODE_PATH;
		f->f_op = &empty_fops;
		return 0;
	}

and you can't specify AT_NO_AUTOMOUNT or AT_NO_FOLLOW to openat(), so ioctl()
is of no use here.

Do you advocate introducing a pioctl() call?  Linus was dead-set against that
as I recall.

I could invent a bunch of AFS-specific syscalls, but I'd rather not do that or
I suppose bring my fsinfo() patches up to scratch - but you didn't like those
either.

Note that using xattrs for fs info is not without precedent in Linux - cifs,
for example.

David
