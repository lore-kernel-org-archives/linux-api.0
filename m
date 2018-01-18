From: Christoph Hellwig <hch@lst.de>
Subject: Re: aio poll, io_pgetevents and a new in-kernel poll API V3
Date: Thu, 18 Jan 2018 18:42:28 +0100
Message-ID: <20180118174228.GA27412@lst.de>
References: <20180117192742.710-1-hch@lst.de> <x49bmhruq3k.fsf@segfault.boston.devel.redhat.com> <x497esfunfw.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <x497esfunfw.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 18, 2018 at 11:44:03AM -0500, Jeff Moyer wrote:
> Jeff Moyer <jmoyer@redhat.com> writes:
> 
> > FYI, this kernel has issues.  It will boot up, but I don't have
> > networking, and even rebooting doesn't succeed.  I'm looking into it.
> 
> A bisect lands on: eventfd: switch to ->poll_mask.  That's not super
> helpful, though.  I did run the ltp eventfd2 tests, and they all pass.
> 
> The actual issue I get on boot is that several services don't start:
>
> [...]
> 
> Christoph, are you able to reproduce this?

No, I can't reproduce any of that.  But I don't have a Fedora system
either, so this might be a new systemd version doing funky things.

The major change in this version was to call ->poll_mask before setting up
the wait queue as well.  This does the right thing for poll and aio poll,
but the more I dig into the epoll code the less sure I am it does the right
thing for it, or in fact that epoll does the right thing in general..

Do you still see it with the patch below applied?

diff --git a/fs/select.c b/fs/select.c
index 707abe79536b..1784c1a29253 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -53,9 +53,9 @@ __poll_t vfs_poll(struct file *file, struct poll_table_struct *pt)
 		head = vfs_get_poll_head(file, events);
 		if (!head)
 			return DEFAULT_POLLMASK;
-		mask = file->f_op->poll_mask(file, events);
-		if (mask)
-			return mask;
+//		mask = file->f_op->poll_mask(file, events);
+//		if (mask)
+//			return mask;
 
 		pt->_qproc(file, head, pt);
 	}

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
