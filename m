From: Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH 0/2] block: virtio-blk: support multi vq per virtio-blk
Date: Sat, 14 Jun 2014 01:29:20 +0800
Message-ID: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

Hi,

This patches try to support multi virtual queues(multi-vq) in one
virtio-blk device, and maps each virtual queue(vq) to blk-mq's
hardware queue.

With this approach, both scalability and performance problems on
virtio-blk device get improved.

For verifying the improvement, I implements virtio-blk multi-vq over
qemu's dataplane feature, and both handling host notification
from each vq and processing host I/O are still kept in the per-device
iothread context, the changes are based on qemu v2.0.0 release, and
can be accessed from below tree:

	git://kernel.ubuntu.com/ming/qemu.git #v2.0.0-virtblk-dataplane-mq

For enabling the multi-vq feature, 'num_queues=N' need to be added into
'-device virtio-blk-pci ...' of qemu command line, and suggest to pass
'vectors=N+1' to keep one MSI irq vector per each vq, and the feature
depends on x-data-plane.

Fio(libaio, randread, iodepth=64, bs=4K, jobs=N) is run inside VM to
verify the improvement.

I just create a small quadcore VM and run fio inside the VM, and
num_queues of the virtio-blk device is set as 2, but looks the
improvement is still obvious.

1), about scalability
- without mutli-vq feature
	-- jobs=2, thoughput: 145K iops
	-- jobs=4, thoughput: 100K iops
- without mutli-vq feature
	-- jobs=2, thoughput: 186K iops
	-- jobs=4, thoughput: 199K iops

2), about thoughput
- without mutli-vq feature
	-- top thoughput: 145K iops
- with mutli-vq feature
    -- top thoughput: 199K iops

So even for one quadcore VM, if the virtqueue number is increased
from 1 to 2, both scalability and performance can get improved a
lot.

Thanks,
--
Ming Lei
