From: Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH v3 06/10] [media] platform: Make use of media_bus_format
 enum
Date: Tue, 11 Nov 2014 10:12:55 +0530
Message-ID: <546193CF.8090107@ti.com>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com> <1415369269-5064-7-git-send-email-boris.brezillon@free-electrons.com> <CA+V-a8t79gYYGcgg5wvM-eqW8H2D6WD7xM9t2Px=WHb2rf34ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CA+V-a8t79gYYGcgg5wvM-eqW8H2D6WD7xM9t2Px=WHb2rf34ow@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Prabhakar Lad <prabhakar.csengg@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media <linux-media@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>, LAK <linux-arm-kernel@lists.infradead.org>, linux-api <linux-api@vger.kernel.org>, OSUOSL Drivers <devel@driverdev.osuosl.org>, LKML <linux-kernel@vger.kernel.org>, LDOC <linux-doc@vger.kernel.org>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
List-Id: linux-api@vger.kernel.org

On Saturday 08 November 2014 02:48 PM, Prabhakar Lad wrote:
> Hi,
> 
> Thanks for the patch,
> 
> On Fri, Nov 7, 2014 at 2:07 PM, Boris Brezillon
> <boris.brezillon@free-electrons.com> wrote:
>> In order to have subsytem agnostic media bus format definitions we've
>> moved media bus definition to include/uapi/linux/media-bus-format.h and
>> prefixed values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.
>>
>> Reference new definitions in all platform drivers.
>>
>> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>> ---
>>  arch/arm/mach-davinci/board-dm355-evm.c            |   2 +-
>>  arch/arm/mach-davinci/board-dm365-evm.c            |   4 +-
>>  arch/arm/mach-davinci/dm355.c                      |   7 +-
>>  arch/arm/mach-davinci/dm365.c                      |   7 +-
> 
> @Sekhar can you ack for the machine changes for davinci ?

Heh, I don't have 6/10 in my inbox but have rest of the series. Can you
forward 6/10 to me?

Thanks,
Sekhar

