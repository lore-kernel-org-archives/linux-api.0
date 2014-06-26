From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v2 0/2] block: virtio-blk: support multi vq per virtio-blk
Date: Thu, 26 Jun 2014 13:28:13 +0800
Message-ID: <CACVXFVN4_uRKF4vsvACF43d9Km1rY8Qomwbs+6j2=PFz2eB2+w@mail.gmail.com>
References: <1403748526-1923-1-git-send-email-ming.lei@canonical.com>
	<53ABAA34.6070006@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53ABAA34.6070006-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Virtualization <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 26, 2014 at 1:05 PM, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
> On 2014-06-25 20:08, Ming Lei wrote:
>>
>> Hi,
>>
>> These patches try to support multi virtual queues(multi-vq) in one
>> virtio-blk device, and maps each virtual queue(vq) to blk-mq's
>> hardware queue.
>>
>> With this approach, both scalability and performance on virtio-blk
>> device can get improved.
>>
>> For verifying the improvement, I implements virtio-blk multi-vq over
>> qemu's dataplane feature, and both handling host notification
>> from each vq and processing host I/O are still kept in the per-device
>> iothread context, the change is based on qemu v2.0.0 release, and
>> can be accessed from below tree:
>>
>>         git://kernel.ubuntu.com/ming/qemu.git #v2.0.0-virtblk-mq.1
>>
>> For enabling the multi-vq feature, 'num_queues=N' need to be added into
>> '-device virtio-blk-pci ...' of qemu command line, and suggest to pass
>> 'vectors=N+1' to keep one MSI irq vector per each vq, and the feature
>> depends on x-data-plane.
>>
>> Fio(libaio, randread, iodepth=64, bs=4K, jobs=N) is run inside VM to
>> verify the improvement.
>>
>> I just create a small quadcore VM and run fio inside the VM, and
>> num_queues of the virtio-blk device is set as 2, but looks the
>> improvement is still obvious.
>>
>> 1), about scalability
>> - without mutli-vq feature
>>         -- jobs=2, thoughput: 145K iops
>>         -- jobs=4, thoughput: 100K iops
>> - with mutli-vq feature
>>         -- jobs=2, thoughput: 193K iops
>>         -- jobs=4, thoughput: 202K iops
>>
>> 2), about thoughput
>> - without mutli-vq feature
>>         -- thoughput: 145K iops
>> - with mutli-vq feature
>>         -- thoughput: 202K iops
>
>
> Of these numbers, I think it's important to highlight that the 2 thread case
> is 33% faster and the 2 -> 4 thread case scales linearly (100%) while the
> pre-patch case sees negative scaling going from 2 -> 4 threads (-39%).

This is because my qemu implementation on multi vq only uses
single iothread to handle requests from all vqs, and the only iothread
is already at full load now, that said on host side the
same fio test(single job) results is ~200K iops too.

>
> I haven't run your patches yet, but from looking at the code, it looks good.
> It's pretty straightforward. See feel free to add my reviewed-by.

Thanks a lot.

>
> Rusty, do you want to ack this (and I'll slurp it up for 3.17) or take this
> yourself? Or something else?

That is great if this can be merged to 3.17.

Thanks,
--
Ming Lei
