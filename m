From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 00/22] Intel FPGA Device Drivers
Date: Fri, 28 Jul 2017 08:28:39 -0500
Message-ID: <CANk1AXQaPwcmHG84wuYt1-mTeWDuaXtR7JbovnX6=E7hhPU=Sg@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498441938-14046-1-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 25, 2017 at 8:51 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Hi All,
>
> Here is v2 patch-series adding drivers for Intel FPGA devices.
>
> The Intel FPGA driver provides interfaces for userspace applications to
> configure, enumerate, open, and access FPGA accelerators on platforms
> equipped with Intel(R) PCIe based FPGA solutions and enables system
> level management functions such as FPGA partial reconfiguration, power
> management and virtualization.
>
> This patch series only adds the basic functions for FPGA accelerators and
> partial reconfiguration. Patches for more functions, e.g power management
> and virtualization, will be submitted after this series gets reviewed.
>
> This patch series depends on Alan Tull's patch set v2 on FPGA region
> support w/o device tree (see [1]).

I've posted a branch for review convenience on the linux-fpga
kernel.org repo.  The branch contains this patchset on top of my now
old v2 FPGA region patchset.

Branch name: for-review-next-20170720-intel-fpga-driver-v2

Alan
