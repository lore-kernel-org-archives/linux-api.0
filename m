From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH 0/2] block: virtio-blk: support multi vq per virtio-blk
Date: Fri, 13 Jun 2014 11:35:15 -0600
Message-ID: <539B3653.6040408@kernel.dk>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

On 06/13/2014 11:29 AM, Ming Lei wrote:
> Hi,
> 
> This patches try to support multi virtual queues(multi-vq) in one
> virtio-blk device, and maps each virtual queue(vq) to blk-mq's
> hardware queue.
> 
> With this approach, both scalability and performance problems on
> virtio-blk device get improved.
> 
> For verifying the improvement, I implements virtio-blk multi-vq over
> qemu's dataplane feature, and both handling host notification
> from each vq and processing host I/O are still kept in the per-device
> iothread context, the changes are based on qemu v2.0.0 release, and
> can be accessed from below tree:
> 
> 	git://kernel.ubuntu.com/ming/qemu.git #v2.0.0-virtblk-dataplane-mq
> 
> For enabling the multi-vq feature, 'num_queues=N' need to be added into
> '-device virtio-blk-pci ...' of qemu command line, and suggest to pass
> 'vectors=N+1' to keep one MSI irq vector per each vq, and the feature
> depends on x-data-plane.
> 
> Fio(libaio, randread, iodepth=64, bs=4K, jobs=N) is run inside VM to
> verify the improvement.
> 
> I just create a small quadcore VM and run fio inside the VM, and
> num_queues of the virtio-blk device is set as 2, but looks the
> improvement is still obvious.
> 
> 1), about scalability
> - without mutli-vq feature
> 	-- jobs=2, thoughput: 145K iops
> 	-- jobs=4, thoughput: 100K iops
> - without mutli-vq feature
> 	-- jobs=2, thoughput: 186K iops
> 	-- jobs=4, thoughput: 199K iops

Awesome! I was hoping someone would do that, and make virtio-blk take
full advantage of blk-mq.

-- 
Jens Axboe
