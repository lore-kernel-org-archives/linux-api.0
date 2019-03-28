From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH 06/17] fpga: dfl: pci: enable SRIOV support.
Date: Thu, 28 Mar 2019 17:03:04 -0500
Message-ID: <CANk1AXQCSK-H4wTzXxbctO8-w4cpzyGSeND-hM3qHqvOaHBuKg@mail.gmail.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com> <1553483264-5379-7-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553483264-5379-7-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Zhang Yi Z <yi.z.zhang@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 24, 2019 at 10:24 PM Wu Hao <hao.wu@intel.com> wrote:
>
> This patch enables the standard sriov support. It allows user to
> enable SRIOV (and VFs), then user could pass through accelerators
> (VFs) into virtual machine or use VFs directly in host.
>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@intel.com>
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>

Acked-by: Alan Tull <atull@kernel.org>
