From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v7 4/6] block: loop: prepare for supporing direct IO
Date: Thu, 30 Jul 2015 04:01:39 -0400
Message-ID: <CACVXFVPqLMoT0j_GUvd6EeMYBSz2qs4ELDZtDx1vNVrK8qguEQ@mail.gmail.com>
References: <1437061068-26118-1-git-send-email-ming.lei@canonical.com>
	<1437061068-26118-5-git-send-email-ming.lei@canonical.com>
	<20150727084020.GA28336@infradead.org>
	<CACVXFVOvnVHNtTkt_kiNZu9BuZHZ==EF4y3qXx+Qo=LHoytODQ@mail.gmail.com>
	<20150727094530.GA15507@infradead.org>
	<CACVXFVMKycx768HtAJXMgEZNjsQrNm_f3UzW9kUysSHAMM5FPQ@mail.gmail.com>
	<20150727173331.GA17594@infradead.org>
	<CACVXFVMkU0TLxys_e3arGChdmgM-P2zQhPBfYx5kUXGbUtd_8A@mail.gmail.com>
	<20150729084102.GB16638@dastard>
	<CACVXFVMOuCk0bHZfrV=VZWLtgsa4oWxrpnu6aoB1LKZ50UMhZA@mail.gmail.com>
	<20150729220829.GM3902@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150729220829.GM3902@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Justin M. Forbes" <jforbes-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 29, 2015 at 6:08 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> On Wed, Jul 29, 2015 at 07:21:47AM -0400, Ming Lei wrote:
>> On Wed, Jul 29, 2015 at 4:41 AM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>> > On Wed, Jul 29, 2015 at 03:33:52AM -0400, Ming Lei wrote:
>> >> On Mon, Jul 27, 2015 at 1:33 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> >> > On Mon, Jul 27, 2015 at 05:53:33AM -0400, Ming Lei wrote:
>> >> >> Because size has to be 4k aligned too.
>> >> >
>> >> > Yes.  But again I don't see any reason to limit us to a hardcoded 512
>> >> > byte block size here, especially considering the patches to finally
>> >>
>> >> From loop block's view, the request size can be any count of 512-byte
>> >> sectors, then the transfer size to backing device can't  guarantee to be
>> >> 4k aligned always.
>> >
>> > In theory, yes. In practise, doesn't happen very often.
>> >
>> >> > allow enabling other block sizes from userspace.
>> >>
>> >> I have some questions about the patchset, and looks the author doesn't
>> >> reply it yet.
>> >>
>> >> On Mon, Jul 27, 2015 at 6:06 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>> >> >> Because size has to be 4k aligned too.
>> >> >
>> >> > So check that, too. Any >= 4k block size filesystem should be doing
>> >> > mostly 4k aligned and sized IO...
>> >>
>> >> I guess you mean we only use direct IO for the 4k aligned and sized IO?
>> >> If so, that won't be efficient because the page cache has to be flushed
>> >> during the switch.
>> >
>> > It will be extremely rare for a 4k block size filesystem to do
>> > anything other than 4k aligned and sized IO. Think about it for a
>> > minute: what does the page cache do to unaligned IO patterns (i.e.
>> > buffered IO)?  It does IO in page sizes, and so if the application
>> > if doing badly aligned or sized IO with buffered IO, then the
>> > underlying device will only ever size page sized and aligned IO.
>> >
>> > Hence sector aligned IO will only come from applications doing
>> > direct IO.  If the application is doing direct IO and it's not
>> > properly aligned, then it already is going to get sucky performance
>> > because most filesystem serialise sub-block size direct IO because
>> > concurrent sub-block IOs to the same block usually leads to data
>> > corruption.
>>
>> The blocksize of filesysten over loop can be 512, 1024, 2048, and
>> suppose sector size of backing device is 4096, then filesystem
>> can see aligned direct IO when IO size/offset from application is aligned
>> with fs block size, but loop still can't do direct IO for all this
>> kind of requests
>> against backing file.
>
> Sure, but again you're talking about a fairly rare configuration.
> The vast majority of filesystems use 4k block sizes, just like the
> vast majority of applications use buffered IO. Don't jump through
> hoops to optimise a case that probably doesn't need optimising. Make
> it work correctly first, then optimise performance later when
> someone has a need for it to be really fast.

OK, I will support 1024, 2048 and 4096 sector size in v8.

>
>> Another case is that application may access loop block directly, such
>> as 'dd if=/dev/loopN', but it may not be common, and maybe it needn't
>> to consider.
>
> 'dd if=/dev/loopN bs=4k....'
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
