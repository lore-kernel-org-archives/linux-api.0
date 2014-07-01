From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/2] block: virtio-blk: support multi vq per virtio-blk
Date: Mon, 30 Jun 2014 21:01:07 -0600
Message-ID: <53B22473.8010709@kernel.dk>
References: <1403775708-22244-1-git-send-email-ming.lei@canonical.com>	<CACVXFVMHPdEzai32jRmLt7qGMFcUqFb8OunF0tzySpKoLWWiwQ@mail.gmail.com>
	<CACVXFVMb4UXRYSp6nvjDQrDRcLP6rJ3_3QHYMzKv9MoogsU66w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <CACVXFVMb4UXRYSp6nvjDQrDRcLP6rJ3_3QHYMzKv9MoogsU66w@mail.gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Ming Lei <ming.lei@canonical.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org, Linux Virtualization <virtualization@lists.linux-foundation.org>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

On 2014-06-30 19:36, Ming Lei wrote:
> Hi Jens and Rusty,
>
> On Thu, Jun 26, 2014 at 8:04 PM, Ming Lei <ming.lei@canonical.com> wrote:
>> On Thu, Jun 26, 2014 at 5:41 PM, Ming Lei <ming.lei@canonical.com> wrote:
>>> Hi,
>>>
>>> These patches try to support multi virtual queues(multi-vq) in one
>>> virtio-blk device, and maps each virtual queue(vq) to blk-mq's
>>> hardware queue.
>>>
>>> With this approach, both scalability and performance on virtio-blk
>>> device can get improved.
>>>
>>> For verifying the improvement, I implements virtio-blk multi-vq over
>>> qemu's dataplane feature, and both handling host notification
>>> from each vq and processing host I/O are still kept in the per-device
>>> iothread context, the change is based on qemu v2.0.0 release, and
>>> can be accessed from below tree:
>>>
>>>          git://kernel.ubuntu.com/ming/qemu.git #v2.0.0-virtblk-mq.1
>>>
>>> For enabling the multi-vq feature, 'num_queues=N' need to be added into
>>> '-device virtio-blk-pci ...' of qemu command line, and suggest to pass
>>> 'vectors=N+1' to keep one MSI irq vector per each vq, and the feature
>>> depends on x-data-plane.
>>>
>>> Fio(libaio, randread, iodepth=64, bs=4K, jobs=N) is run inside VM to
>>> verify the improvement.
>>>
>>> I just create a small quadcore VM and run fio inside the VM, and
>>> num_queues of the virtio-blk device is set as 2, but looks the
>>> improvement is still obvious. The host is 2 sockets, 8cores(16threads)
>>> server.
>>>
>>> 1), about scalability
>>> - jobs = 2, thoughput: +33%
>>> - jobs = 4, thoughput: +100%
>>>
>>> 2), about top thoughput: +39%
>>>
>>> So in my test, even for a quad-core VM, if the virtqueue number
>>> is increased from 1 to 2, both scalability and performance can
>>> get improved a lot.
>>>
>>> In above qemu implementation of virtio-blk-mq device, only one
>>> IOthread handles requests from all vqs, and the above throughput
>>> data has been very close to same fio test in host side with single
>>> job. So more improvement should be observed once more IOthreads are
>>> used for handling requests from multi vqs.
>>>
>>> TODO:
>>>          - adjust vq's irq smp_affinity according to blk-mq hw queue's cpumask
>>>
>>> V3:
>>>          - fix use-after-free on vq->name reported by Michael
>>>
>>> V2: (suggestions from Michael and Dave Chinner)
>>>          - allocate virtqueues' pointers dynamically
>>>          - make sure the per-queue spinlock isn't kept in same cache line
>>>          - make each queue's name different
>>>
>>> V1:
>>>          - remove RFC since no one objects
>>>          - add '__u8 unused' for pending as suggested by Rusty
>>>          - use virtio_cread_feature() directly, suggested by Rusty
>>
>> Sorry, please add Jens' reviewed-by.
>>
>>      Reviewed-by: Jens Axboe <axboe@kernel.dk>
>
> I appreciate very much that one of you may queue these two
> patches into your tree so that userspace work can be kicked off,
> since Michael has acked both patches and all comments have
> been addressed already.

Given that Michael also acked it and Rusty is on his sabbatical, I'll 
queue it up for 3.17.

-- 
Jens Axboe
