From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [RFC PATCH 2/2] block: virtio-blk: support multi virt queues per
	virtio-blk device
Date: Wed, 18 Jun 2014 00:00:07 +0800
Message-ID: <CACVXFVO6GDu7Cp=s7kn_XBE2EFnuh+XQs4UQKTFaCLi4_9jcgg@mail.gmail.com>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
	<1402680562-8328-3-git-send-email-ming.lei@canonical.com>
	<CAJSP0QWaS--gPZ=ONFrXby1DQLw4R0RCro7bpHCdmucyjmqT_w@mail.gmail.com>
	<CACVXFVO0SybUKArQbKkj2+hbk6q_gt3SBooNNmw1jErRR8d07A@mail.gmail.com>
	<53A06475.7000308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <53A06475.7000308@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, Linux Virtualization <virtualization@lists.linux-foundation.org>, Stefan Hajnoczi <stefanha@redhat.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jun 17, 2014 at 11:53 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 17/06/2014 17:50, Ming Lei ha scritto:
>
>>> > It would be nice to allocate virtqueues dynamically instead of
>>> > hardcoding the limit.  virtio-scsi also allocates virtqueues
>>> > dynamically.
>>
>> virtio-scsi may have lots of LUN, but virtio-blk only has one disk
>> which needn't lots of hardware queues.
>
>
> If you want to do queue steering based on the guest VCPU number, the number
> of queues must be = to the number of VCPUs shouldn't it?
>
> I tried using a divisor of the number of VCPUs, but couldn't get the block
> layer to deliver interrupts to the right VCPU.

For blk-mq's hardware queue, that won't be necessary to equal to
VCPUs number, and irq affinity per hw queue can be simply set as
blk_mq_hw_ctx->cpumask.

Thanks,
--
Ming Lei
