From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/6] vfio: implement iommu driver capabilities with
	an enum
Date: Fri, 31 Oct 2014 14:04:11 -0600
Message-ID: <1414785851.27420.334.camel@ul30vt.home>
References: <1414433155-31600-1-git-send-email-a.motakis@virtualopensystems.com>
	<1414433155-31600-2-git-send-email-a.motakis@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1414433155-31600-2-git-send-email-a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
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

On Mon, 2014-10-27 at 19:05 +0100, Antonios Motakis wrote:
> Currently a VFIO driver's IOMMU capabilities are encoded as a series of
> numerical defines. Replace this with an enum for future maintainability.
> 
> Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
> ---
>  include/uapi/linux/vfio.h | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 6612974..1e39842 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -19,19 +19,18 @@
>  
>  /* Kernel & User level defines for VFIO IOCTLs. */
>  
> -/* Extensions */
> -
> -#define VFIO_TYPE1_IOMMU		1
> -#define VFIO_SPAPR_TCE_IOMMU		2
> -#define VFIO_TYPE1v2_IOMMU		3
>  /*
> - * IOMMU enforces DMA cache coherence (ex. PCIe NoSnoop stripping).  This
> - * capability is subject to change as groups are added or removed.
> + * Capabilities exposed by the VFIO IOMMU driver. Some capabilities are subject
> + * to change as groups are added or removed.
>   */
> -#define VFIO_DMA_CC_IOMMU		4
> -
> -/* Check if EEH is supported */
> -#define VFIO_EEH			5
> +enum vfio_iommu_cap {
> +	VFIO_TYPE1_IOMMU	= 1,
> +	VFIO_SPAPR_TCE_IOMMU	= 2,
> +	VFIO_TYPE1v2_IOMMU	= 3,
> +	VFIO_DMA_CC_IOMMU	= 4, /* IOMMU enforces DMA cache coherence
> +					(ex. PCIe NoSnoop stripping) */
> +	VFIO_EEH		= 5, /* Check if EEH is supported */
> +};

Your code base is a little out of date, you're missing:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/include/uapi/linux/vfio.h?id=f5c9ecebaf2a2c9381973798e389cc019dd983e0

I think the logic looks ok in the rest, but you'll need to use index 7
and the above commit touched the type1 c file as well so you may need to
adjustment there too.  Thanks,

Alex
>  
>  /*
>   * The IOCTL interface is designed for extensibility by embedding the
