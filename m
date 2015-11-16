From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/3] [media] include/media: move driver interface headers to a separate dir
Date: Mon, 16 Nov 2015 13:30:19 +0100
Message-ID: <11305053.FloWFxl3Yn@wuerfel>
References: <013152dcb3d4eaddd39aa4a37868430567bdc2d6.1447671420.git.mchehab@osg.samsung.com> <23e53dd0223c40ecf7128e0b270fcfbea8e1c43b.1447671420.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-sh-owner@vger.kernel.org>
In-Reply-To: <23e53dd0223c40ecf7128e0b270fcfbea8e1c43b.1447671420.git.mchehab@osg.samsung.com>
Sender: linux-sh-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Hans Verkuil <hverkuil@xs4all.nl>, Kyungmin Park <kyungmin.park@samsung.com>, Heungjun Kim <riverful.kim@samsung.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Andy Walls <awalls@md.metrocast.net>, Sylwester Nawrocki <s.nawrocki@samsung.com>, Kukjin Kim <kgene@kernel.org>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, Josh Wu <josh.wu@atmel.com>, Hans de Goede <hdegoede@redhat.com>, Mike Isely <isely@pobox.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Vinod Koul <vinod.koul@intel.com>, Ul
List-Id: linux-api@vger.kernel.org

On Monday 16 November 2015 09:00:44 Mauro Carvalho Chehab wrote:
> Let's not mix headers used by the core with those headers that
> are needed by some driver-specific interface header.
> 
> The headers used on drivers were manually moved using:
>     mkdir include/media/drv-intf/
>     git mv include/media/cx2341x.h include/media/cx25840.h \
> 	include/media/exynos-fimc.h include/media/msp3400.h \
> 	include/media/s3c_camif.h include/media/saa7146.h \
> 	include/media/saa7146_vv.h  include/media/sh_mobile_ceu.h \
> 	include/media/sh_mobile_csi2.h include/media/sh_vou.h \
> 	include/media/si476x.h include/media/soc_mediabus.h \
> 	include/media/tea575x.h include/media/drv-intf/
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

I probably would have left soc_mediabus.h where it is, but I can
see there are reasons to move it.

	Arnd
