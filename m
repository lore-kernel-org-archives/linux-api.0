From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v8 00/55] MC next generation patches
Date: Sun, 30 Aug 2015 11:27:53 -0300
Message-ID: <20150830112753.65858fdd@recife.lan>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: devel@driverdev.osuosl.org, Lars-Peter Clausen <lars@metafoo.de>, Sylwester Nawrocki <s.nawrocki@samsung.com>, linux-sh@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Shuah Khan <shuahkh@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Hans Verkuil <hverkuil@xs4all.nl>, Javier Martinez Canillas <javier@osg.samsung.com>, linux-samsung-soc@vger.kernel.org, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Em Sun, 30 Aug 2015 00:06:11 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> That's the 8th version of the MC next generation patches.
> 
> Differences from version 7:
> 
> - Patches reworked to make the reviewers happy;
> - Bug fixes;
> - ALSA changes got their own separate patches;
> - Javier patches got integrated into this series;
> - media-entity.h structs are now properly documented;
> - Tested on both au0828 and omap3isp.
> 
> Due to the complexity of this change, other platform drivers may
> require some fixes. 
> 
> As the patch series sent before, this is not meant to be sent
> upstream yet. Its goal is to merge it for Kernel 4.4, in order to
> give people enough time to review and fix pending issues.

As on the previous series, the patches are available on my experimental
tree:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental.git/log/?h=mc_next_gen

There's one additional patch there that removes the backlinks from G_TOPOLOGY
ioctl. I'll be posting it in separate at the ML.

I also added a new branch:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental.git/log/?h=mc_next_gen_test

Based on the first one. It contains a hack for au0828 that exposes the tuner
also via subdev devnode, and reduces the number of output pads of the DVB
demux to just 5, as the default is too high to produce a .dot file that
would be useful. Of course, this patch should never leave my experimental
tree ;) 

There are a few other from Javier there meant to allow testing the omap3isp
on my Beaglebone (that doesn't have any sensor on it) and on his omap3
devices.

I added support at the mc_nextgen_test tool to produce Graphviz .dot
files. It is still experimental, but it is good enough to already produce
some useful graphs. The newest version is at:

	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/log/?h=mc-next-gen

I added some graphs produced by it at:
	https://mchehab.fedorapeople.org/mc-next-gen/

Regards,
Mauro
