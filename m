From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] block: virtio-blk: support multi virt queues per
 virtio-blk device
Date: Tue, 15 Dec 2015 09:26:44 +0800
Message-ID: <CACVXFVMe-BB_S=doiZm0XYezzrYX_E4gc8_85N4BA=g5y8fAWw@mail.gmail.com>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
	<1402680562-8328-3-git-send-email-ming.lei@canonical.com>
	<CAJSP0QWaS--gPZ=ONFrXby1DQLw4R0RCro7bpHCdmucyjmqT_w@mail.gmail.com>
	<CACVXFVO0SybUKArQbKkj2+hbk6q_gt3SBooNNmw1jErRR8d07A@mail.gmail.com>
	<53A06475.7000308@redhat.com>
	<CACVXFVO6GDu7Cp=s7kn_XBE2EFnuh+XQs4UQKTFaCLi4_9jcgg@mail.gmail.com>
	<53A06E05.9060708@redhat.com>
	<CACVXFVMkV5R5GUjM7Y-U54SA-ENZZ26dbbv4K2_OYPdmmiuUqg@mail.gmail.com>
	<566E9A7E.3030203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <566E9A7E.3030203-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Virtualization <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Paolo,

On Mon, Dec 14, 2015 at 6:31 PM, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>
> On 18/06/2014 06:04, Ming Lei wrote:
>> For virtio-blk, I don't think it is always better to take more queues, and
>> we need to leverage below things in host side:
>>
>> - host storage top performance, generally it reaches that with more
>> than 1 jobs with libaio(suppose it is N, so basically we can use N
>> iothread per device in qemu to try to get top performance)
>>
>> - iothreads' loading(if iothreads are at full loading, increasing
>> queues doesn't help at all)
>>
>> In my test, I only use the current per-dev iothread(x-dataplane)
>> in qemu to handle 2 vqs' notification and precess all I/O from
>> the 2 vqs, and looks it can improve IOPS by ~30%.
>>
>> For virtio-scsi, the current usage doesn't make full use of blk-mq's
>> advantage too because only one vq is active at the same time, so I
>> guess the multi vqs' benefit won't be very much and I'd like to post
>> patches to support that first, then provide test data with
>> more queues(8, 16).
>
> Hi Ming Lei,
>
> would you like to repost these patches now that MQ support is in the kernel?
>
> Also, I changed my mind about moving linux-aio to AioContext.  I now
> think it's a good idea, because it limits the number of io_getevents
> syscalls. O:-)  So I would be happy to review your patches for that as well.

OK, I try to figure out a new version, and it might take a while since it is
close to festival season, :-)

Thanks,
