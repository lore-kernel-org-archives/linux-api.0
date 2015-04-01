From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 3/4] Add virtio gpu driver.
Date: Wed, 1 Apr 2015 15:31:02 +0200
Message-ID: <20150401152857-mutt-send-email-mst@redhat.com>
References: <1427894130-14228-1-git-send-email-kraxel@redhat.com>
	<1427894130-14228-4-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1427894130-14228-4-git-send-email-kraxel@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, David Airlie <airlied@linux.ie>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org, "open list:VIRTIO CORE,
	NET..." <virtualization@lists.linux-foundation.org>, airlied@redhat.com, airlied@gmail.com
List-Id: linux-api@vger.kernel.org

On Wed, Apr 01, 2015 at 03:15:29PM +0200, Gerd Hoffmann wrote:
> +int virtio_gpu_driver_unload(struct drm_device *dev)
> +{
> +	struct virtio_gpu_device *vgdev = dev->dev_private;
> +
> +	vgdev->vqs_ready = false;

Probably ok since flush below will sync all cpus,
but this needs a comment I think.

> +	flush_work(&vgdev->ctrlq.dequeue_work);
> +	flush_work(&vgdev->cursorq.dequeue_work);

I see there are a bunch of other work entries -
don't all of them need to be flushed?

> +	vgdev->vdev->config->del_vqs(vgdev->vdev);
> +
> +	virtio_gpu_modeset_fini(vgdev);
> +	virtio_gpu_ttm_fini(vgdev);
> +	virtio_gpu_free_vbufs(vgdev);
> +	kfree(vgdev);
> +	return 0;
> +}
