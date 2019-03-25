From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH 03/17] fpga: dfl: fme: support 512bit data width PR
Date: Mon, 25 Mar 2019 13:48:52 -0500
Message-ID: <CANk1AXTCbR3E=WFUvyHx3BDFwV19djuhC=qBpxQHT46qGgwWJA@mail.gmail.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com> <1553483264-5379-4-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553483264-5379-4-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Ananda Ravuri <ananda.ravuri@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 24, 2019 at 10:23 PM Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

This looks fine.

>
> In early partial reconfiguration private feature, it only
> supports 32bit data width when writing data to hardware for
> PR. 512bit data width PR support is an important optimization
> for some specific solutions (e.g. XEON with FPGA integrated),
> it allows driver to use AVX512 instruction to improve the
> performance of partial reconfiguration. e.g. programming one
> 100MB bitstream image via this 512bit data width PR hardware
> only takes ~300ms, but 32bit revision requires ~3s per test
> result.
>
> Please note now this optimization is only done on revision 2
> of this PR private feature which is only used in integrated
> solution that AVX512 is always supported.
>
> Signed-off-by: Ananda Ravuri <ananda.ravuri@intel.com>
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>

Acked-by: Alan Tull <atull@kernel.org>
