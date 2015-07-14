From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] pci_regs: reintroduce PCI_MSIX_FLAGS_BIRMASK
Date: Tue, 14 Jul 2015 18:29:24 -0500
Message-ID: <20150714232924.GS24416@google.com>
References: <1435745608-21217-1-git-send-email-mst@redhat.com>
 <20150713181025-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150713181025-mutt-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rajat Jain <rajatxjain@gmail.com>, "Chen, Gong" <gong.chen@linux.intel.com>, Guenter Roeck <groeck@juniper.net>, =?us-ascii?B?PT9VVEYtOD9xP1JhZmE9QzU9ODI9MjBNaT1DNT04MmVja2k/PQ==?= <zajec5@gmail.com>, linux-api@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jul 13, 2015 at 06:11:38PM +0300, Michael S. Tsirkin wrote:
> On Wed, Jul 01, 2015 at 12:14:10PM +0200, Michael S. Tsirkin wrote:
> > This partially reverts commit 09a2c73ddfc7f173237fc7209a65b34dd5bcb5ed.
> >     PCI: Remove unused PCI_MSIX_FLAGS_BIRMASK definition
> > 
> > That commit dropped a symbol from an exported header claiming "no one
> > uses it". This isn't how Linux normally approaches userspace API though,
> > and in fact QEMU build fails if trying to use updated headers from linux
> > 3.12 and up.
> > 
> > Sure, userspace can be fixed to use the new symbol, but the cost
> > of keeping the old one around is fairly low, too.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Sorry, I lost the original message somehow, so I can't reply to it.  I
applied this by hand to my for-linus branch for v4.2, thanks!


commit c9ddbac9c89110f77cb0fa07e634aaf1194899aa
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Tue Jul 14 18:27:46 2015 -0500

    PCI: Restore PCI_MSIX_FLAGS_BIRMASK definition
    
    09a2c73ddfc7 ("PCI: Remove unused PCI_MSIX_FLAGS_BIRMASK definition")
    removed PCI_MSIX_FLAGS_BIRMASK from an exported header because it was
    unused in the kernel.  But that breaks user programs that were using it
    (QEMU in particular).
    
    Restore the PCI_MSIX_FLAGS_BIRMASK definition.
    
    [bhelgaas: changelog]
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    CC: stable@vger.kernel.org	# v3.13+

diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index efe3443..413417f 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -319,6 +319,7 @@
 #define PCI_MSIX_PBA		8	/* Pending Bit Array offset */
 #define  PCI_MSIX_PBA_BIR	0x00000007 /* BAR index */
 #define  PCI_MSIX_PBA_OFFSET	0xfffffff8 /* Offset into specified BAR */
+#define PCI_MSIX_FLAGS_BIRMASK	PCI_MSIX_PBA_BIR /* deprecated */
 #define PCI_CAP_MSIX_SIZEOF	12	/* size of MSIX registers */
 
 /* MSI-X Table entry format */
