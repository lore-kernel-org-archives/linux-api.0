From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v3 08/21] fpga: add Intel FPGA DFL PCIe device
Date: Wed, 6 Dec 2017 09:44:42 +0000
Message-ID: <e73f5bc9bfc54efcb7b7c43c66379452@AcuMS.aculab.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-9-git-send-email-hao.wu@intel.com>
 <f5ae8e5edf88420e89cfbe754407b92e@AcuMS.aculab.com>
 <20171128031519.GA25705@hao-dev>
 <CANk1AXRBEcz5_j+v0oTAXfH10hrPbHGabdR8Pqt07exYxYgfCw@mail.gmail.com>
 <20171205033330.GA19730@hao-dev>
 <CANk1AXRdU6usqtsCUjjSC8Fk2SS8iKn+Ow4PvCiRpSBAcDwWjw@mail.gmail.com>
 <20171206053015.GA19023@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171206053015.GA19023@hao-dev>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Wu Hao' <hao.wu@intel.com>, Alan Tull <atull@kernel.org>
Cc: "mdf@kernel.org" <mdf@kernel.org>, "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "luwei.kang@intel.com" <luwei.kang@intel.com>, "yi.z.zhang@intel.com" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

From: Wu Hao
> Sent: 06 December 2017 05:30
...
> > Regarding file names, it seems like the files added to drivers/fpga
> > could be uniformly named dfl-*.[ch].  Some are fpga-dfl-*.[ch] while
> > other are currently dfl-*.[ch] currently.

They don't even want to do into a drivers/fgpa directory.
Maybe drivers/dfl or drivers/dfl/intel

	David
