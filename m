From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v4 03/24] fpga: mgr: add status for fpga-manager
Date: Wed, 14 Feb 2018 09:55:15 -0600
Message-ID: <CANk1AXT4hSSa8j0A2Q=M91jjxDzkNayHZaftnOYSdZoppTMEAA@mail.gmail.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com> <1518513893-4719-4-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518513893-4719-4-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

> This patch adds status to fpga-manager data structure,

Please update the header to better describe the current changes, this
patch no longer adds status to the fpga mgr data struct.

> to allow
> driver to store full/partial reconfiguration errors and other
> status information, and adds one status callback to fpga_manager_ops
> to allow fpga_manager to collect latest status when failures are
> detected.

Other than that, looks good to me!  Thanks for taking my feedback.
Alan

>
> The following sysfs file is created:
> * /sys/class/fpga_manager/<fpga>/status
>   Return status of fpga manager, including reconfiguration errors.
>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
