From: Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH 01/15] [media] Move mediabus format definition to a more
 standard place
Date: Tue, 04 Nov 2014 12:09:59 +0100
Message-ID: <5458B407.6050701@cisco.com>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>	<1415094910-15899-2-git-send-email-boris.brezillon@free-electrons.com>	<5458A878.3010809@cisco.com>
 <20141104114503.309cb54f@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20141104114503.309cb54f@bbrezillon>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: devel@driverdev.osuosl.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Mauro Carvalho Chehab <m.chehab@samsung.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Well, I gave two alternatives :-)

Both are fine as far as I am concerned, but it would be nice to hear
what others think.

Regards,

	Hans

On 11/04/14 11:45, Boris Brezillon wrote:
> Hi Hans,
> 
> On Tue, 04 Nov 2014 11:20:40 +0100
> Hans Verkuil <hansverk@cisco.com> wrote:
> 
>> Hi Boris,
>>
>> On 11/04/14 10:54, Boris Brezillon wrote:
>>> Rename mediabus formats and move the enum into a separate header file so
>>> that it can be used by DRM/KMS subsystem without any reference to the V4L2
>>> subsystem.
>>>
>>> Old V4L2_MBUS_FMT_ definitions are now referencing MEDIA_BUS_FMT_ value.
>>
>> I missed earlier that v4l2-mediabus.h contained a struct as well, so it can't be
>> deprecated and neither can a #warning be added.
>>
>> The best approach, I think, is to use a macro in media-bus-format.h
>> that will either define just the MEDIA_BUS value when compiled in the kernel, or
>> define both MEDIA_BUS and V4L2_MBUS values when compiled for userspace.
>>
>> E.g. something like this:
>>
>> #ifdef __KERNEL__
>> #define MEDIA_BUS_FMT_ENTRY(name, val) MEDIA_BUS_FMT_ # name = val
>> #else
>> /* Keep V4L2_MBUS_FMT for backwards compatibility */
>> #define MEDIA_BUS_FMT_ENTRY(name, val) \
>> 	MEDIA_BUS_FMT_ # name = val, \
>> 	V4L2_MBUS_FMT_ # name = val
>> #endif
> 
> Okay, but this means we keep adding V4L2_MBUS_FMT_ definitions even for
> new formats (which definitely doesn't encourage people to move on).
> Moreover, we add a V4L2 prefix in what was supposed to be a subsystem
> neutral header.
> 
> Anyway, these are just nitpicks, and if you prefer this approach
> I'll rework my series :-).
> 
>>
>> An alternative approach is to have v4l2-mediabus.h include media-bus-format.h,
>> put #ifndef __KERNEL__ around the enum v4l2_mbus_pixelcode and add a big comment
>> there that applications should use the defines from media-bus-format.h and that
>> this enum is frozen (i.e. new values are only added to media-bus-format.h).
>>
>> But I think I like the macro idea best.
> 
> As you wish, my only intent is to use those bus format definitions in a
> DRM driver :-).
> 
> Thanks,
> 
> Boris
> 
> 
