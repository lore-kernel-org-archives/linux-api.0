From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] block: virtio-blk: support multi virt queues per
 virtio-blk device
Date: Tue, 17 Jun 2014 23:50:57 +0800
Message-ID: <CACVXFVO0SybUKArQbKkj2+hbk6q_gt3SBooNNmw1jErRR8d07A@mail.gmail.com>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
	<1402680562-8328-3-git-send-email-ming.lei@canonical.com>
	<CAJSP0QWaS--gPZ=ONFrXby1DQLw4R0RCro7bpHCdmucyjmqT_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJSP0QWaS--gPZ=ONFrXby1DQLw4R0RCro7bpHCdmucyjmqT_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Hajnoczi <stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Virtualization <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 17, 2014 at 10:40 AM, Stefan Hajnoczi <stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sat, Jun 14, 2014 at 1:29 AM, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
>> Firstly this patch supports more than one virtual queues for virtio-blk
>> device.
>>
>> Secondly this patch maps the virtual queue to blk-mq's hardware queue.
>>
>> With this approach, both scalability and performance problem can be improved.
>>
>> Signed-off-by: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> ---
>>  drivers/block/virtio_blk.c |   75 ++++++++++++++++++++++++++++++++------------
>>  1 file changed, 55 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index f63d358..e0d077d 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -16,6 +16,8 @@
>>
>>  #define PART_BITS 4
>>
>> +#define MAX_NUM_VQ 16
>
> It would be nice to allocate virtqueues dynamically instead of
> hardcoding the limit.  virtio-scsi also allocates virtqueues
> dynamically.

virtio-scsi may have lots of LUN, but virtio-blk only has one disk
which needn't lots of hardware queues.

Also it doesn't matter since it isn't part of ABI.

If change on virtio_blk_config is agreed, both host side and
guest side can choose to support dynamic length or pre-defined
length freely.

Thanks,
--
Ming Lei
