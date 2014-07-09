From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v2 0/2] block: virtio-blk: support multi vq per virtio-blk
Date: Wed, 09 Jul 2014 10:31:08 +0930
Message-ID: <87ion75orv.fsf@rustcorp.com.au>
References: <1403748526-1923-1-git-send-email-ming.lei@canonical.com>
	<53ABAA34.6070006@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
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
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:
> Rusty, do you want to ack this (and I'll slurp it up for 3.17) or take 
> this yourself? Or something else?

I'm happy with the idea, and importantly, the new feature bit.  So once
the implementation is tweaked, please add:

        Acked-by: Rusty Russell <rusty@rustcorp.com.au>

The new feature bit takes us outside the current standard (which is
hopefully now frozen), but I'll just add it to the pile of things to
revisit for 1.1.

Thanks,
Rusty,
