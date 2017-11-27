From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v3 08/21] fpga: add Intel FPGA DFL PCIe device
Date: Mon, 27 Nov 2017 10:28:04 +0000
Message-ID: <f5ae8e5edf88420e89cfbe754407b92e@AcuMS.aculab.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-9-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511764948-20972-9-git-send-email-hao.wu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Wu Hao' <hao.wu@intel.com>, "atull@kernel.org" <atull@kernel.org>, "mdf@kernel.org" <mdf@kernel.org>, "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "luwei.kang@intel.com" <luwei.kang@intel.com>, "yi.z.zhang@intel.com" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

From: Wu Hao
> Sent: 27 November 2017 06:42
> From: Zhang Yi <yi.z.zhang@intel.com>
> 
> The Intel FPGA device appears as a PCIe device on the system. This patch
> implements the basic framework of the driver for Intel PCIe device which
> is located between CPU and Accelerated Function Units (AFUs), and has
> the Device Feature List (DFL) implemented in its MMIO space.

This ought to have a better name than 'Intel FPGA'.
An fpga can be used for all sorts of things, this looks like
a very specific architecture using a common VHDL environment to
allow certain types of user VHDL be accessed over PCIe.

	David
