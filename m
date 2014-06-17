From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 2/2] block: virtio-blk: support multi virt queues
	per virtio-blk device
Date: Tue, 17 Jun 2014 18:34:13 +0200
Message-ID: <53A06E05.9060708@redhat.com>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>	<1402680562-8328-3-git-send-email-ming.lei@canonical.com>	<CAJSP0QWaS--gPZ=ONFrXby1DQLw4R0RCro7bpHCdmucyjmqT_w@mail.gmail.com>	<CACVXFVO0SybUKArQbKkj2+hbk6q_gt3SBooNNmw1jErRR8d07A@mail.gmail.com>	<53A06475.7000308@redhat.com>
	<CACVXFVO6GDu7Cp=s7kn_XBE2EFnuh+XQs4UQKTFaCLi4_9jcgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <CACVXFVO6GDu7Cp=s7kn_XBE2EFnuh+XQs4UQKTFaCLi4_9jcgg@mail.gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, Linux Virtualization <virtualization@lists.linux-foundation.org>, Stefan Hajnoczi <stefanha@redhat.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Il 17/06/2014 18:00, Ming Lei ha scritto:
>> > If you want to do queue steering based on the guest VCPU number, the number
>> > of queues must be = to the number of VCPUs shouldn't it?
>> >
>> > I tried using a divisor of the number of VCPUs, but couldn't get the block
>> > layer to deliver interrupts to the right VCPU.
> For blk-mq's hardware queue, that won't be necessary to equal to
> VCPUs number, and irq affinity per hw queue can be simply set as
> blk_mq_hw_ctx->cpumask.

Yes, but on top of that you want to have each request processed exactly 
by the CPU that sent it.  Unless the cpumasks are singletons, most of 
the benefit went away in my virtio-scsi tests.  Perhaps blk-mq is smarter.

Can you try benchmarking a 16 VCPU guest with 8 and 16 queues?

Paolo
