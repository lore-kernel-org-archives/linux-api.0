From: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 1/4] PCI: Add Enhanced Allocation register entries
Date: Tue, 20 Oct 2015 08:12:34 -0500
Message-ID: <20151020131234.GB8224@localhost>
References: <1444175438-7443-1-git-send-email-ddaney.cavm@gmail.com>
 <1444175438-7443-2-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444175438-7443-2-git-send-email-ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, "Signed-off-by: David Daney" <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi David,

On Tue, Oct 06, 2015 at 04:50:35PM -0700, David Daney wrote:
> From: "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Add registers defined in PCI-SIG's Enhanced allocation ECN.
> 
> Signed-off-by: Sean O. Stalley <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> [david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org: Added more definitions for PCI_EA_BEI_*]
> Signed-off-by: Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  include/uapi/linux/pci_regs.h | 44 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index 413417f..352e418 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -216,7 +216,8 @@
>  #define  PCI_CAP_ID_MSIX	0x11	/* MSI-X */
>  #define  PCI_CAP_ID_SATA	0x12	/* SATA Data/Index Conf. */
>  #define  PCI_CAP_ID_AF		0x13	/* PCI Advanced Features */
> -#define  PCI_CAP_ID_MAX		PCI_CAP_ID_AF
> +#define  PCI_CAP_ID_EA		0x14	/* PCI Enhanced Allocation */
> +#define  PCI_CAP_ID_MAX		PCI_CAP_ID_EA
>  #define PCI_CAP_LIST_NEXT	1	/* Next capability in the list */
>  #define PCI_CAP_FLAGS		2	/* Capability defined flags (16 bits) */
>  #define PCI_CAP_SIZEOF		4
> @@ -353,6 +354,47 @@
>  #define  PCI_AF_STATUS_TP	0x01
>  #define PCI_CAP_AF_SIZEOF	6	/* size of AF registers */
>  
> +/* PCI Enhanced Allocation registers */
> +
> +#define PCI_EA_NUM_ENT		2	/* Number of Capability Entries */
> +#define PCI_EA_NUM_ENT_MASK	0x3f	/* Num Entries Mask */

Can you tweak this a bit to match the style of the rest of the file a
bit closer?

  - no indent (one space) for register offsets
  - two spaces before masks for register fields
  - write out masks showing register width
  - use explicit mask, not BIT()

> +#define PCI_EA_FIRST_ENT	4	/* First EA Entry in List */
> +#define PCI_EA_FIRST_ENT_BRIDGE	8	/* First EA Entry for Bridges */
> +#define PCI_EA_ES		0x7	/* Entry Size */

  #define  PCI_EA_ES            0x00000007   /* Entry Size */

> +#define PCI_EA_BEI(x)	(((x) >> 4) & 0xf) /* BAR Equivalent Indicator */
> +/* 0-5 map to BARs 0-5 respectively */
> +#define  PCI_EA_BEI_BAR0	0
> +#define  PCI_EA_BEI_BAR5	5
> +#define  PCI_EA_BEI_BRIDGE	6	/* Resource behind bridge */
> +#define  PCI_EA_BEI_ENI		7	/* Equivalent Not Indicated */
> +#define  PCI_EA_BEI_ROM		8	/* Expansion ROM */
> +/* 9-14 map to VF BARs 0-5 respectively */
> +#define  PCI_EA_BEI_VF_BAR0	9
> +#define  PCI_EA_BEI_VF_BAR5	14
> +#define  PCI_EA_BEI_RESERVED	15	/* Reserved - Treat like ENI */
> +
> +#define PCI_EA_PP(x)	(((x) >>  8) & 0xff)	/* Primary Properties */
> +#define PCI_EA_SP(x)	(((x) >> 16) & 0xff)	/* Secondary Properties */
> +#define  PCI_EA_P_MEM			0x00	/* Non-Prefetch Memory */

What does the "_P_" stand for?  Maybe it could be dropped?  Oh, I
suppose it stands for "property."

> +#define  PCI_EA_P_MEM_PREFETCH		0x01	/* Prefetchable Memory */
> +#define  PCI_EA_P_IO			0x02	/* I/O Space */
> +#define  PCI_EA_P_VIRT_MEM_PREFETCH	0x03	/* VF Prefetchable Memory */
> +#define  PCI_EA_P_VIRT_MEM		0x04	/* VF Non-Prefetch Memory */

_VIRT_MEM suggests "virtual memory"; maybe you could use "VF_MEM"
instead?

> +#define  PCI_EA_P_BRIDGE_MEM		0x05	/* Bridge Non-Prefetch Memory */
> +#define  PCI_EA_P_BRIDGE_MEM_PREFETCH	0x06	/* Bridge Prefetchable Memory */
> +#define  PCI_EA_P_BRIDGE_IO		0x07	/* Bridge I/O Space */
> +/* 0x08-0xfc reserved */
> +#define  PCI_EA_P_MEM_RESERVED		0xfd	/* Reserved Memory */
> +#define  PCI_EA_P_IO_RESERVED		0xfe	/* Reserved I/O Space */
> +#define  PCI_EA_P_UNAVAILABLE		0xff	/* Entry Unavailable */
> +#define PCI_EA_WRITEABLE	BIT(30) /* Writable, 1 = RW, 0 = HwInit */
> +#define PCI_EA_ENABLE		BIT(31) /* Enable for this entry */

  #define  PCI_EA_WRITABLE      0x40000000
  #define  PCI_EA_ENABLE        0x80000000

(note s/WRITEABLE/WRITABLE/)

> +#define PCI_EA_BASE		4	/* Base Address Offset */
> +#define PCI_EA_MAX_OFFSET	8	/* MaxOffset (resource length) */
> +/* bit 0 is reserved */
> +#define PCI_EA_IS_64		BIT(1)	/* 64-bit field flag */
> +#define PCI_EA_FIELD_MASK	0xfffffffc	/* For Base & Max Offset */
> +
>  /* PCI-X registers (Type 0 (non-bridge) devices) */
>  
>  #define PCI_X_CMD		2	/* Modes & Features */
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
