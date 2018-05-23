From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: YAaioRace (was Re: [PATCH 08/31] aio: implement IOCB_CMD_POLL)
Date: Wed, 23 May 2018 02:43:18 +0100
Message-ID: <20180523014318.GI30522@ZenIV.linux.org.uk>
References: <20180522113108.25713-1-hch@lst.de>
 <20180522113108.25713-9-hch@lst.de>
 <20180522220524.GE30522@ZenIV.linux.org.uk>
 <20180523004530.GG30522@ZenIV.linux.org.uk>
 <20180523004904.GH30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180523004904.GH30522@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-api@vger.kernel.org

On Wed, May 23, 2018 at 01:49:04AM +0100, Al Viro wrote:

> > Looks like we want to call ->ki_cancel() *BEFORE* removing from the list,
> > as well as doing fput() after aio_complete().  The same ordering, BTW, goes
> > for aio_read() et.al.
> > 
> > Look:
> > CPU1:	io_cancel() grabs ->ctx_lock, finds iocb and removes it from the list.
> > CPU2:	aio_rw_complete() on that iocb.  Since the sucker is not in the list
> > anymore, we do NOT spin on ->ctx_lock and proceed to free iocb
> > CPU1:	pass freed iocb to ->ki_cancel().  BOOM.
> 
> BTW, it seems that the mainline is vulnerable to this one.  I might be
> missing something, but...

It is, but with a different attack vector - io_cancel(2) won't do it (it
does not remove from the list at all), but io_destroy(2) bloody well will.

IMO, we need this in mainline; unless somebody has a problem with it, to
#fixes it goes:

fix io_destroy()/aio_complete() race

If io_destroy() gets to cancelling everything that can be cancelled and
gets to kiocb_cancel() calling the function driver has left in ->ki_cancel,
it becomes vulnerable to a race with IO completion.  At that point req
is already taken off the list and aio_complete() does *NOT* spin until
we (in free_ioctx_users()) releases ->ctx_lock.  As the result, it proceeds
to kiocb_free(), freing req just it gets passed to ->ki_cancel().

Fix is simple - remove from the list after the call of kiocb_cancel().  All
instances of ->ki_cancel() already have to cope with the being called with
iocb still on list - that's what happens in io_cancel(2).

Cc: stable@kernel.org
Fixes: 0460fef2a921 "aio: use cancellation list lazily"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/aio.c b/fs/aio.c
index 8061d9787e54..49f53516eef0 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -634,9 +634,8 @@ static void free_ioctx_users(struct percpu_ref *ref)
 	while (!list_empty(&ctx->active_reqs)) {
 		req = list_first_entry(&ctx->active_reqs,
 				       struct aio_kiocb, ki_list);
-
-		list_del_init(&req->ki_list);
 		kiocb_cancel(req);
+		list_del_init(&req->ki_list);
 	}
 
 	spin_unlock_irq(&ctx->ctx_lock);

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
