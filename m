From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v7 4/6] block: loop: prepare for supporing direct IO
Date: Wed, 29 Jul 2015 03:33:52 -0400
Message-ID: <CACVXFVMkU0TLxys_e3arGChdmgM-P2zQhPBfYx5kUXGbUtd_8A@mail.gmail.com>
References: <1437061068-26118-1-git-send-email-ming.lei@canonical.com>
	<1437061068-26118-5-git-send-email-ming.lei@canonical.com>
	<20150727084020.GA28336@infradead.org>
	<CACVXFVOvnVHNtTkt_kiNZu9BuZHZ==EF4y3qXx+Qo=LHoytODQ@mail.gmail.com>
	<20150727094530.GA15507@infradead.org>
	<CACVXFVMKycx768HtAJXMgEZNjsQrNm_f3UzW9kUysSHAMM5FPQ@mail.gmail.com>
	<20150727173331.GA17594@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150727173331.GA17594@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Justin M. Forbes" <jforbes@fedoraproject.org>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jul 27, 2015 at 1:33 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jul 27, 2015 at 05:53:33AM -0400, Ming Lei wrote:
>> Because size has to be 4k aligned too.
>
> Yes.  But again I don't see any reason to limit us to a hardcoded 512
> byte block size here, especially considering the patches to finally

>From loop block's view, the request size can be any count of 512-byte
sectors, then the transfer size to backing device can't  guarantee to be
4k aligned always.

> allow enabling other block sizes from userspace.

I have some questions about the patchset, and looks the author doesn't
reply it yet.

On Mon, Jul 27, 2015 at 6:06 PM, Dave Chinner <david@fromorbit.com> wrote:
>> Because size has to be 4k aligned too.
>
> So check that, too. Any >= 4k block size filesystem should be doing
> mostly 4k aligned and sized IO...

I guess you mean we only use direct IO for the 4k aligned and sized IO?
If so, that won't be efficient because the page cache has to be flushed
during the switch.

Thanks,
Ming



> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
