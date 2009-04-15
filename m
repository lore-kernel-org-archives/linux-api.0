From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH v3 4/6] aio: Don't inherit aio ring memory at fork
Date: Wed, 15 Apr 2009 12:00:16 +0900 (JST)
Message-ID: <20090415115858.AC31.A69D9226@jp.fujitsu.com>
References: <20090415091534.AC18.A69D9226@jp.fujitsu.com> <x49tz4qiqks.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <x49tz4qiqks.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>, Zach Brown <zach.brown@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, linux-api@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi

> > drawback worst aio scenario here
> > -----------------------------------------------------------------------
> > io_setup() and gup			inc page_count
> >
> > fork					inc mapcount
> > 					and make write-protect to pte
> >
> > write ring from userland(*)		page fault and
> > 					COW break.
> > 					parent process get copyed page and
> > 					child get original page owner-ship.
> >
> > kmap and memcpy from kernel		change child page. (it mean data lost)
> >
> > (*) Is this happend?
> 
> I guess it's possible, but I don't know of any programs that do this.

Yup, I also think this isn't happen in real world.

> 
> > MADV_DONTFORK or down_read(mmap_sem) or down_read(mm_pinned_sem) 
> > or copy-at-fork mecanism(=Nick/Andrea patch) solve it.
> 
> OK, thanks for the explanation.
> 
> +	/*
> +	 * aio context doesn't inherit while fork. (see mm_init())
> +	 * Then, aio ring also mark DONTFORK.
> +	 */
> 
> Would you mind if I did some word-smithing on that comment?  Something
> like:
> 	/*
> 	 * The io_context is not inherited by the child after fork()
>          * (see mm_init).  Therefore, it makes little sense for the
>          * completion ring to be inherited.
>          */
> 
> +	ret = sys_madvise(info->mmap_base, info->mmap_size, MADV_DONTFORK);
> +	BUG_ON(ret);
> +
> 
> It appears there's no other way to set the VM_DONTCOPY flag, so I guess
> calling sys_madvise is fine.  I'm not sure I agree with the BUG_ON(ret),
> however, as EAGAIN may be feasible.
> 
> So, fix that up and you can add my reviewed-by.  I think you should push
> this patch independent of the other patches in this series.

Done :)




--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
