From: Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH 11/15] [media] Deprecate v4l2_mbus_pixelcode
Date: Wed, 05 Nov 2014 16:19:56 +0100
Message-ID: <545A401C.8070908@cisco.com>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>	<1415094910-15899-12-git-send-email-boris.brezillon@free-electrons.com>	<20141105150814.GT3136@valkosipuli.retiisi.org.uk> <20141105161538.7a1686d5@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20141105161538.7a1686d5@bbrezillon>
Sender: linux-doc-owner@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>, Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
List-Id: linux-api@vger.kernel.org



On 11/05/14 16:15, Boris Brezillon wrote:
> On Wed, 5 Nov 2014 17:08:15 +0200
> Sakari Ailus <sakari.ailus@iki.fi> wrote:
> 
>> Hi Boris,
>>
>> On Tue, Nov 04, 2014 at 10:55:06AM +0100, Boris Brezillon wrote:
>>> The v4l2_mbus_pixelcode enum (or its values) should be replaced by the
>>> media_bus_format enum.
>>> Keep this enum in v4l2-mediabus.h and create a new header containing
>>> the v4l2_mbus_framefmt struct definition (which is not deprecated) so
>>> that we can add a #warning statement in v4l2-mediabus.h and hopefully
>>> encourage users to move to the new definitions.
>>>
>>> Replace inclusion of v4l2-mediabus.h with v4l2-mbus.h in all common headers
>>> and update the documentation Makefile to parse v4l2-mbus.h instead of
>>> v4l2-mediabus.h.
>>>
>>> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>>> ---
>>>  Documentation/DocBook/media/Makefile |  2 +-
>>>  include/media/v4l2-mediabus.h        |  2 +-
>>>  include/uapi/linux/Kbuild            |  1 +
>>>  include/uapi/linux/v4l2-mbus.h       | 35 +++++++++++++++++++++++++++++++++++
>>>  include/uapi/linux/v4l2-mediabus.h   | 26 ++++----------------------
>>
>> I would keep the original file name, even if the compatibility definitions
>> are there. I don't see any harm in having them around as well.
>>
> 
> That's the part I was not sure about.
> The goal of this patch (and the following ones) is to deprecate
> v4l2_mbus_pixelcode enum and its values by adding a #warning when
> v4l2-mediabus.h file is included, thus encouraging people to use new
> definitions.

Since v4l2-mediabus.h contains struct v4l2_mbus_framefmt this header remains
a legal header, so you can't use #warning here in any case.

Regards,

	Hans

> 
> Do you see another solution to generate such warnings at compilation
> time ?
> 
