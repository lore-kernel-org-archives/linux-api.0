From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH v3 4/6] aio: Don't inherit aio ring memory at fork
Date: Wed, 15 Apr 2009 09:56:34 +0900 (JST)
Message-ID: <20090415091534.AC18.A69D9226@jp.fujitsu.com>
References: <20090414151924.C653.A69D9226@jp.fujitsu.com> <x49iql7z0k1.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <x49iql7z0k1.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>, Zach Brown <zach.brown@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, linux-api@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi!

> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
> 
> > AIO folks, Am I missing anything?
> >
> > ===============
> > Subject: [RFC][PATCH] aio: Don't inherit aio ring memory at fork
> >
> > Currently, mm_struct::ioctx_list member isn't copyed at fork. IOW aio context don't inherit at fork.
> > but only ring memory inherited. that's strange.
> >
> > This patch mark DONTFORK to ring-memory too.
> 
> Well, given that clearly nobody relies on io contexts being copied to
> the child, I think it's okay to make this change.  I think the current
> behaviour violates the principal of least surprise, but I'm having a
> hard time getting upset about that.  ;)

ok.
So, Can I get your Acked-by?

> > In addition, This patch has good side effect. it also fix
> > "get_user_pages() vs fork" problem.
> 
> Hmm, I don't follow you, here.  As I understand it, the get_user_pages
> vs. fork problem has to do with the pages used for the actual I/O, not
> the pages used to store the completion data.  So, could you elaborate a
> bit on what you mean by the above statement?

No.

The problem is, get_user_pages() increment page_count only.
but VM page-fault logic don't care page_count. (it only care page::_mapcount)
Then, fork and pagefault can change virtual-physical relationship although
get_user_pages() is called.

drawback worst aio scenario here
-----------------------------------------------------------------------
io_setup() and gup			inc page_count

fork					inc mapcount
					and make write-protect to pte

write ring from userland(*)		page fault and
					COW break.
					parent process get copyed page and
					child get original page owner-ship.

kmap and memcpy from kernel		change child page. (it mean data lost)

(*) Is this happend?

MADV_DONTFORK or down_read(mmap_sem) or down_read(mm_pinned_sem) 
or copy-at-fork mecanism(=Nick/Andrea patch) solve it.



> > I think "man fork" also sould be changed. it only say
> >
> >        *  The child does not inherit outstanding asynchronous I/O operations from
> >           its parent (aio_read(3), aio_write(3)).
> > but aio_context_t (return value of io_setup(2)) also don't inherit in current implementaion.
> 
> I can certainly make that change, as I have other changes I need to push
> to Michael, anyway.

thanks.



