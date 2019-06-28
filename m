From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v4 05/15] Documentation: fpga: dfl: add descriptions for
 virtualization and new interfaces.
Date: Thu, 27 Jun 2019 18:12:56 -0700
Message-ID: <20190628011256.GB5671@archbook>
References: <1561610695-5414-1-git-send-email-hao.wu@intel.com>
 <1561610695-5414-6-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1561610695-5414-6-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, yilun.xu@intel.com, gregkh@linuxfoundation.org, atull@kernel.org
List-Id: linux-api@vger.kernel.org

Hi Wu,

On Thu, Jun 27, 2019 at 12:44:45PM +0800, Wu Hao wrote:
> This patch adds virtualization support description for DFL based
> FPGA devices (based on PCIe SRIOV), and introductions to new
> interfaces added by new dfl private feature drivers.
> 
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> Acked-by: Alan Tull <atull@kernel.org>
> ---
>  Documentation/fpga/dfl.txt | 101 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 101 insertions(+)
> 
> diff --git a/Documentation/fpga/dfl.txt b/Documentation/fpga/dfl.txt
> index 6df4621..a22631f 100644
> --- a/Documentation/fpga/dfl.txt
> +++ b/Documentation/fpga/dfl.txt

This got re{named,formatted} in linux-next. I've tried to fix it before sending it
to Greg.

Thanks,
Moritz
