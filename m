From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: aio poll, io_pgetevents and a new in-kernel poll API V3
Date: Thu, 18 Jan 2018 12:59:52 -0500
Message-ID: <x49o9lrt5d3.fsf@segfault.boston.devel.redhat.com>
References: <20180117192742.710-1-hch@lst.de>
        <x49bmhruq3k.fsf@segfault.boston.devel.redhat.com>
        <x497esfunfw.fsf@segfault.boston.devel.redhat.com>
        <20180118174228.GA27412@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180118174228.GA27412-jcswGhMUV9g@public.gmane.org> (Christoph Hellwig's message of
        "Thu, 18 Jan 2018 18:42:28 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:

> On Thu, Jan 18, 2018 at 11:44:03AM -0500, Jeff Moyer wrote:
>> Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>> 
>> > FYI, this kernel has issues.  It will boot up, but I don't have
>> > networking, and even rebooting doesn't succeed.  I'm looking into it.
>> 
>> A bisect lands on: eventfd: switch to ->poll_mask.  That's not super
>> helpful, though.  I did run the ltp eventfd2 tests, and they all pass.
>> 
>> The actual issue I get on boot is that several services don't start:
>>
>> [...]
>> 
>> Christoph, are you able to reproduce this?
>
> No, I can't reproduce any of that.  But I don't have a Fedora system
> either, so this might be a new systemd version doing funky things.
>
> The major change in this version was to call ->poll_mask before setting up
> the wait queue as well.  This does the right thing for poll and aio poll,
> but the more I dig into the epoll code the less sure I am it does the right
> thing for it, or in fact that epoll does the right thing in general..
>
> Do you still see it with the patch below applied?

No, that fixes it for me.

-Jeff

> diff --git a/fs/select.c b/fs/select.c
> index 707abe79536b..1784c1a29253 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -53,9 +53,9 @@ __poll_t vfs_poll(struct file *file, struct poll_table_struct *pt)
>  		head = vfs_get_poll_head(file, events);
>  		if (!head)
>  			return DEFAULT_POLLMASK;
> -		mask = file->f_op->poll_mask(file, events);
> -		if (mask)
> -			return mask;
> +//		mask = file->f_op->poll_mask(file, events);
> +//		if (mask)
> +//			return mask;
>  
>  		pt->_qproc(file, head, pt);
>  	}
