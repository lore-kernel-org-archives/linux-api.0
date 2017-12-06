From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v3 08/21] fpga: add Intel FPGA DFL PCIe device
Date: Wed, 6 Dec 2017 09:34:14 +0000
Message-ID: <391be54799604c1fb3d7b80c7ad6d111@AcuMS.aculab.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-9-git-send-email-hao.wu@intel.com>
 <f5ae8e5edf88420e89cfbe754407b92e@AcuMS.aculab.com>
 <20171128031519.GA25705@hao-dev>
 <CANk1AXRBEcz5_j+v0oTAXfH10hrPbHGabdR8Pqt07exYxYgfCw@mail.gmail.com>
 <20171205033330.GA19730@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171205033330.GA19730@hao-dev>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Wu Hao' <hao.wu@intel.com>, Alan Tull <atull@kernel.org>
Cc: "mdf@kernel.org" <mdf@kernel.org>, "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "luwei.kang@intel.com" <luwei.kang@intel.com>, "yi.z.zhang@intel.com" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

From: Wu Hao
> Sent: 05 December 2017 03:34
...
> > I don't see anything Intel specific here.  This could all be named dfl-*
> 
> The maybe some device specific things, e.g Intel FPGA devices supported by this
> driver always have FME DFL at the beginning on the BAR0 for PF device.

Since when has that been a method for specifying what the card does?
You need to allocate a PCI-id for your DFL accelerator.

	David
