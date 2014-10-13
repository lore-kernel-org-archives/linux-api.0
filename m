From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] driver core: amba: add device binding path
 'driver_override'
Date: Mon, 13 Oct 2014 08:23:24 -0500
Message-ID: <20141013082324.362423be23ad44dc391ccd65@freescale.com>
References: <1413205672-6236-1-git-send-email-a.motakis@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413205672-6236-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: Russell King <linux@arm.linux.org.uk>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org, alex.williamson@redhat.com, tech@virtualopensystems.com, christoffer.dall@linaro.org, eric.auger@linaro.org, marc.zyngier@arm.com
List-Id: linux-api@vger.kernel.org

On Mon, 13 Oct 2014 15:07:34 +0200
Antonios Motakis <a.motakis@virtualopensystems.com> wrote:

> As already demonstrated with PCI [1] and the platform bus [2], a
> driver_override property in sysfs can be used to bypass the id matching
> of a device to a AMBA driver. This can be used by VFIO to bind to any AMBA
> device requested by the user.
> 
> [1] http://lists-archives.com/linux-kernel/28030441-pci-introduce-new-device-binding-path-using-pci_dev-driver_override.html
> [2] https://www.redhat.com/archives/libvir-list/2014-April/msg00382.html
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---

Reviewed-by: Kim Phillips <kim.phillips@freescale.com>

Kim
