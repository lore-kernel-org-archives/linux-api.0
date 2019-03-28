From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH 05/17] fpga: dfl: fme: add DFL_FPGA_FME_PORT_RELEASE/ASSIGN
 ioctl support.
Date: Thu, 28 Mar 2019 17:03:39 -0500
Message-ID: <CANk1AXSwZ3PU+PRGBDkx=0nkMNTRyC2OQMCm3kte+fq-N1KkyA@mail.gmail.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com> <1553483264-5379-6-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553483264-5379-6-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Zhang Yi Z <yi.z.zhang@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 24, 2019 at 10:23 PM Wu Hao <hao.wu@intel.com> wrote:
>
> In order to support virtualization usage via PCIe SRIOV, this patch
> adds two ioctls under FPGA Management Engine (FME) to release and
> assign back the port device. In order to safely turn Port from PF
> into VF and enable PCIe SRIOV, it requires user to invoke this
> PORT_RELEASE ioctl to release port firstly to remove userspace
> interfaces, and then configure the PF/VF access register in FME.
> After disable SRIOV, it requires user to invoke this PORT_ASSIGN
> ioctl to attach the port back to PF.
>
>  Ioctl interfaces:
>  * DFL_FPGA_FME_PORT_RELEASE
>    Release platform device of given port, it deletes port platform
>    device to remove related userspace interfaces on PF, then
>    configures PF/VF access mode to VF.
>
>  * DFL_FPGA_FME_PORT_ASSIGN
>    Assign platform device of given port back to PF, it configures
>    PF/VF access mode to PF, then adds port platform device back to
>    re-enable related userspace interfaces on PF.
>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@intel.com>
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>

Acked-by: Alan Tull <atull@kernel.org>
