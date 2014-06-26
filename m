From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 0/2] block: virtio-blk: support multi vq per virtio-blk
Date: Thu, 26 Jun 2014 10:46:45 +0300
Message-ID: <20140626074645.GB21823@redhat.com>
References: <1403748526-1923-1-git-send-email-ming.lei@canonical.com>
	<53ABAA34.6070006@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <53ABAA34.6070006@kernel.dk>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-api@vger.kernel.org, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 25, 2014 at 11:05:56PM -0600, Jens Axboe wrote:
> On 2014-06-25 20:08, Ming Lei wrote:
> >Hi,
> >
> >These patches try to support multi virtual queues(multi-vq) in one
> >virtio-blk device, and maps each virtual queue(vq) to blk-mq's
> >hardware queue.
> >
> >With this approach, both scalability and performance on virtio-blk
> >device can get improved.
> >
> >For verifying the improvement, I implements virtio-blk multi-vq over
> >qemu's dataplane feature, and both handling host notification
> >from each vq and processing host I/O are still kept in the per-device
> >iothread context, the change is based on qemu v2.0.0 release, and
> >can be accessed from below tree:
> >
> >	git://kernel.ubuntu.com/ming/qemu.git #v2.0.0-virtblk-mq.1
> >
> >For enabling the multi-vq feature, 'num_queues=N' need to be added into
> >'-device virtio-blk-pci ...' of qemu command line, and suggest to pass
> >'vectors=N+1' to keep one MSI irq vector per each vq, and the feature
> >depends on x-data-plane.
> >
> >Fio(libaio, randread, iodepth=64, bs=4K, jobs=N) is run inside VM to
> >verify the improvement.
> >
> >I just create a small quadcore VM and run fio inside the VM, and
> >num_queues of the virtio-blk device is set as 2, but looks the
> >improvement is still obvious.
> >
> >1), about scalability
> >- without mutli-vq feature
> >	-- jobs=2, thoughput: 145K iops
> >	-- jobs=4, thoughput: 100K iops
> >- with mutli-vq feature
> >	-- jobs=2, thoughput: 193K iops
> >	-- jobs=4, thoughput: 202K iops
> >
> >2), about thoughput
> >- without mutli-vq feature
> >	-- thoughput: 145K iops
> >- with mutli-vq feature
> >	-- thoughput: 202K iops
> 
> Of these numbers, I think it's important to highlight that the 2 thread case
> is 33% faster and the 2 -> 4 thread case scales linearly (100%) while the
> pre-patch case sees negative scaling going from 2 -> 4 threads (-39%).
> 
> I haven't run your patches yet, but from looking at the code, it looks good.
> It's pretty straightforward. See feel free to add my reviewed-by.
> 
> Rusty, do you want to ack this (and I'll slurp it up for 3.17)

Looks like I found some issues, so not yet pls.

> or take this
> yourself? Or something else?
> 
> 
> -- 
> Jens Axboe
