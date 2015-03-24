From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] Add virtio gpu driver.
Date: Tue, 24 Mar 2015 17:15:29 +0100
Message-ID: <20150324171255-mutt-send-email-mst@redhat.com>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <virtio-dev-return-671-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
Content-Disposition: inline
In-Reply-To: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, "open list:VIRTIO CORE, NET..." <virtualization@lists.linux-foundation.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 24, 2015 at 05:07:18PM +0100, Gerd Hoffmann wrote:
> From: Dave Airlie <airlied@gmail.com>
> 
> This patch adds a kms driver for the virtio gpu.  The xorg modesetting
> driver can handle the device just fine, the framebuffer for fbcon is
> there too.
> 
> Qemu patches for the host side are under review currently.
> 
> The pci version of the device comes in two variants: with and without
> vga compatibility.  The former has a extra memory bar for the vga
> framebuffer, the later is a pure virtio device.  The only concern for
> this driver is that in the virtio-vga case we have to kick out the
> firmware framebuffer.
> 
> Initial revision has only 2d support, 3d (virgl) support requires
> some more work on the qemu side and will be added later.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

...

> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index e894eb2..a3167fa 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -510,7 +510,7 @@ static int virtio_pci_probe(struct pci_dev *pci_dev,
>  		goto err_enable_device;
>  
>  	rc = pci_request_regions(pci_dev, "virtio-pci");
> -	if (rc)
> +	if (rc && ((pci_dev->class >> 8) != PCI_CLASS_DISPLAY_VGA))
>  		goto err_request_regions;
>  
>  	if (force_legacy) {

This is probably what you described as "the only concern?  Can you
explain why you are doing this?  If we only need to request specific
regions, I think we should do exactly that, requesting only parts of
regions that are covered by the virtio capabilities.

Seems cleaner than looking for a specific class.

Didn't look at device code in depth yet.
