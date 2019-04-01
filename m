From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH 08/17] fpga: dfl: afu: add userclock sysfs interfaces.
Date: Mon, 1 Apr 2019 16:41:52 -0500
Message-ID: <CANk1AXR_sp-w0D7ftkdMn-_PrvV1h5Qvg-qSUEE6ZRm9BvYZ1g@mail.gmail.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com> <1553483264-5379-9-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553483264-5379-9-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Ananda Ravuri <ananda.ravuri@intel.com>, Russ Weight <russell.h.weight@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 24, 2019 at 10:24 PM Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

Looks fine.

>
> This patch introduces userclock sysfs interfaces for AFU, user
> could use these interfaces for clock setting to AFU.
>
> Please note that, this is only working for port header feature
> with revision 0, for later revisions, userclock setting is moved
> to a separated private feature, so one revision sysfs interface
> is exposed to userspace application for this purpose too.
>
> Signed-off-by: Ananda Ravuri <ananda.ravuri@intel.com>
> Signed-off-by: Russ Weight <russell.h.weight@intel.com>
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
