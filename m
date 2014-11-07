From: Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH v3 09/10] gpu: ipu-v3: Make use of media_bus_format enum
Date: Fri, 07 Nov 2014 16:05:24 +0100
Message-ID: <1415372724.29873.7.camel@pengutronix.de>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
	 <1415369269-5064-10-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <1415369269-5064-10-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
List-Id: linux-api@vger.kernel.org

Am Freitag, den 07.11.2014, 15:07 +0100 schrieb Boris Brezillon:
> In order to have subsytem agnostic media bus format definitions we've
> moved media bus definition to include/uapi/linux/media-bus-format.h and
> prefixed enum values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.
> 
> Reference new definitions in the ipu-v3 driver.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
