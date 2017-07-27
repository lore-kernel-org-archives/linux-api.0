From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v2 02/22] fpga: add FPGA device framework
Date: Thu, 27 Jul 2017 11:44:01 -0500
Message-ID: <CANk1AXR-nSB-6TKpVyskbvfj_F2=jbSv48hpp+UXtKxkTseLqw@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com> <1498441938-14046-3-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-3-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 25, 2017 at 8:51 PM, Wu Hao <hao.wu@intel.com> wrote:
> During FPGA device (e.g PCI-based) discovery, platform devices are
> registered for different FPGA function units. But the device node path
> isn't quite friendly to applications.
>

Hi Hao,

Please add a document for fpga-dev under Documentation/fpga to help
future users.  The header of this patch explains things pretty well
and could be used with a little formatting for the document.

Alan
