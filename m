From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [RFC PATCH 2/2] block: virtio-blk: support multi virt queues per
	virtio-blk device
Date: Tue, 17 Jun 2014 10:40:56 +0800
Message-ID: <CAJSP0QWaS--gPZ=ONFrXby1DQLw4R0RCro7bpHCdmucyjmqT_w@mail.gmail.com>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
	<1402680562-8328-3-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1402680562-8328-3-git-send-email-ming.lei@canonical.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Linux Virtualization <virtualization@lists.linux-foundation.org>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 14, 2014 at 1:29 AM, Ming Lei <ming.lei@canonical.com> wrote:
> Firstly this patch supports more than one virtual queues for virtio-blk
> device.
>
> Secondly this patch maps the virtual queue to blk-mq's hardware queue.
>
> With this approach, both scalability and performance problem can be improved.
>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/block/virtio_blk.c |   75 ++++++++++++++++++++++++++++++++------------
>  1 file changed, 55 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index f63d358..e0d077d 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -16,6 +16,8 @@
>
>  #define PART_BITS 4
>
> +#define MAX_NUM_VQ 16

It would be nice to allocate virtqueues dynamically instead of
hardcoding the limit.  virtio-scsi also allocates virtqueues
dynamically.

Stefan
