From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v4 20/24] fpga: dfl: add FPGA Accelerated Function Unit
 driver basic framework
Date: Mon, 19 Mar 2018 13:40:05 -0500
Message-ID: <CANk1AXRA81cSJchjzHmzG8QZMZETEppTw7BW3of++20VFcQ3Qw@mail.gmail.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com> <1518513893-4719-21-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518513893-4719-21-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

I acked this back in v2.

> On DFL FPGA devices, the Accelerated Function Unit (AFU), can be
> reprogrammed for different functions. It connects to the FPGA
> infrastructure("blue bistream") via a Port. Port CSRs are implemented
> separately from the AFU CSRs to provide control and status of the Port.
> Once valid green bitstream is programmed into the AFU, it allows access
> to the AFU CSRs in the AFU MMIO space.
>
> This patch only implements basic driver framework for AFU, including
> device file operation framework.
>
> Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>

Alan
