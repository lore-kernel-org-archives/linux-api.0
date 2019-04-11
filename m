From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH 12/17] fpga: dfl: afu: add STP (SignalTap) support
Date: Thu, 11 Apr 2019 15:41:36 -0500
Message-ID: <CANk1AXQdFy9c7i54zk4yqzqK-vxm009bXKrgvyCR64h3rDwwRA@mail.gmail.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
 <1553483264-5379-13-git-send-email-hao.wu@intel.com> <20190402150719.GB15773@archbook>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402150719.GB15773@archbook>
Sender: linux-kernel-owner@vger.kernel.org
To: Moritz Fischer <mdf@kernel.org>
Cc: Wu Hao <hao.wu@intel.com>, Alan Tull <atull@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 2, 2019 at 10:07 AM Moritz Fischer <mdf@kernel.org> wrote:
>
> Hi Wu,
>
> On Mon, Mar 25, 2019 at 11:07:39AM +0800, Wu Hao wrote:
> > STP (SignalTap) is one of the private features under the port for
> > debugging. This patch adds private feature driver support for it
> > to allow userspace applications to mmap related mmio region and
> > provide STP service.
> >
> > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> Acked-by: Moritz Fischer <mdf@kernel.org>

Acked-by: Alan Tull <atull@kernel.org>

Thanks,
Alan
