From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 2/2] block: virtio-blk: support multi virt queues per
	virtio-blk device
Date: Mon, 23 Jun 2014 13:42:51 +1000
Message-ID: <20140623034251.GR4453@dastard>
References: <1403278181-28455-1-git-send-email-ming.lei@canonical.com>
	<1403278181-28455-3-git-send-email-ming.lei@canonical.com>
	<20140622102448.GB17067@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20140622102448.GB17067@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-api@vger.kernel.org, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 22, 2014 at 01:24:48PM +0300, Michael S. Tsirkin wrote:
> On Fri, Jun 20, 2014 at 11:29:40PM +0800, Ming Lei wrote:
> > @@ -24,8 +26,8 @@ static struct workqueue_struct *virtblk_wq;
> >  struct virtio_blk
> >  {
> >  	struct virtio_device *vdev;
> > -	struct virtqueue *vq;
> > -	spinlock_t vq_lock;
> > +	struct virtqueue *vq[MAX_NUM_VQ];
> > +	spinlock_t vq_lock[MAX_NUM_VQ];
> 
> array of struct {
>     *vq;
>     spinlock_t lock;
> }
> would use more memory but would get us better locality.
> It might even make sense to add padding to avoid
> cacheline sharing between two unrelated VQs.
> Want to try?

It's still false sharing because the queue objects share cachelines.
To operate without contention they have to be physically separated
from each other like so:

struct vq {
	struct virtqueue	*q;
	spinlock_t		lock;
} ____cacheline_aligned_in_smp;

struct some_other_struct {
	....
	struct vq	vq[MAX_NUM_VQ];
	....
};

This keeps locality to objects within a queue, but separates each
queue onto it's own cacheline....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
