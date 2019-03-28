From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH 07/17] fpga: dfl: afu: add AFU state related sysfs interfaces
Date: Thu, 28 Mar 2019 12:13:10 -0500
Message-ID: <CANk1AXRsgZtfgtiB-JuaD+V-JH0vLNQL10EFP4uykJbZ2t5n_w@mail.gmail.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com> <1553483264-5379-8-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553483264-5379-8-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Ananda Ravuri <ananda.ravuri@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 24, 2019 at 10:24 PM Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

>
> This patch introduces more sysfs interfaces for Accelerated
> Function Unit (AFU). These interfaces allow users to read
> current AFU Power State (APx), read / clear AFU Power (APx)
> events which are sticky to identify transient APx state,
> and manage AFU's LTR (latency tolerance reporting).
>
> Signed-off-by: Ananda Ravuri <ananda.ravuri@intel.com>
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>

Acked-by: Alan Tull <atull@kernel.org>

Thanks,
Alan
