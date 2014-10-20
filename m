From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
Date: Mon, 20 Oct 2014 15:29:43 -0600
Message-ID: <1413840583.4202.111.camel@ul30vt.home>
References: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
	<1413205748-6300-3-git-send-email-a.motakis@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1413205748-6300-3-git-send-email-a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Cc: "open list:VFIO DRIVER" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, will.deacon-5wv7dgnIgG8@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2014-10-13 at 15:09 +0200, Antonios Motakis wrote:
> We introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag to the VFIO dma map call,
> and expose its availability via the capability VFIO_DMA_NOEXEC_IOMMU.
> This way the user can control whether the XN flag will be set on the
> requested mappings. The IOMMU_NOEXEC flag needs to be available for all
> the IOMMUs of the container used.
> 
> Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
> ---
>  include/uapi/linux/vfio.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 6612974..111b5e8 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -29,6 +29,7 @@
>   * capability is subject to change as groups are added or removed.
>   */
>  #define VFIO_DMA_CC_IOMMU		4
> +#define VFIO_DMA_NOEXEC_IOMMU		5
>  
>  /* Check if EEH is supported */
>  #define VFIO_EEH			5
                                    ^^
5 is still already used.  Feel free to convert to enum so we stop making
this mistake.

> @@ -401,6 +402,7 @@ struct vfio_iommu_type1_dma_map {
>  	__u32	flags;
>  #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
>  #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
> +#define VFIO_DMA_MAP_FLAG_NOEXEC (1 << 2)	/* not executable from device */
>  	__u64	vaddr;				/* Process virtual address */
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */
