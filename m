From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v3 0/2] block: virtio-blk: support multi vq per virtio-blk
Date: Thu, 26 Jun 2014 17:41:46 +0800
Message-ID: <1403775708-22244-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

These patches try to support multi virtual queues(multi-vq) in one
virtio-blk device, and maps each virtual queue(vq) to blk-mq's
hardware queue.

With this approach, both scalability and performance on virtio-blk
device can get improved.

For verifying the improvement, I implements virtio-blk multi-vq over
qemu's dataplane feature, and both handling host notification
from each vq and processing host I/O are still kept in the per-device
iothread context, the change is based on qemu v2.0.0 release, and
can be accessed from below tree:

	git://kernel.ubuntu.com/ming/qemu.git #v2.0.0-virtblk-mq.1

For enabling the multi-vq feature, 'num_queues=N' need to be added into
'-device virtio-blk-pci ...' of qemu command line, and suggest to pass
'vectors=N+1' to keep one MSI irq vector per each vq, and the feature
depends on x-data-plane.

Fio(libaio, randread, iodepth=64, bs=4K, jobs=N) is run inside VM to
verify the improvement.

I just create a small quadcore VM and run fio inside the VM, and
num_queues of the virtio-blk device is set as 2, but looks the
improvement is still obvious. The host is 2 sockets, 8cores(16threads)
server.

1), about scalability
- jobs = 2, thoughput: +33%
- jobs = 4, thoughput: +100%

2), about top thoughput: +39%

So in my test, even for a quad-core VM, if the virtqueue number
is increased from 1 to 2, both scalability and performance can
get improved a lot.

In above qemu implementation of virtio-blk-mq device, only one
IOthread handles requests from all vqs, and the above throughput
data has been very close to same fio test in host side with single
job. So more improvement should be observed once more IOthreads are
used for handling requests from multi vqs.

TODO:
	- adjust vq's irq smp_affinity according to blk-mq hw queue's cpumask

V3:
	- fix use-after-free on vq->name reported by Michael

V2: (suggestions from Michael and Dave Chinner)
	- allocate virtqueues' pointers dynamically
	- make sure the per-queue spinlock isn't kept in same cache line
	- make each queue's name different

V1:
	- remove RFC since no one objects
	- add '__u8 unused' for pending as suggested by Rusty
	- use virtio_cread_feature() directly, suggested by Rusty

Thanks,
--
Ming Lei
