From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 4/5] power: max77693: Add charger driver for Maxim 77693
Date: Tue, 28 Oct 2014 10:16:22 +0100
Message-ID: <1414487782.24949.23.camel@AMDC1943>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
 <1413808489-3524-5-git-send-email-k.kozlowski@samsung.com>
 <20141027185656.GB18965@earth.universe>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20141027185656.GB18965-SfvFxonMDyemK9LvCR3Hrw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


On pon, 2014-10-27 at 19:56 +0100, Sebastian Reichel wrote:
> Hi,
> 
> On Mon, Oct 20, 2014 at 02:34:48PM +0200, Krzysztof Kozlowski wrote:
> > Add new driver for Maxim 77693 switch-mode charger (part of max77693
> > MFD driver) providing power supply class information to userspace.
> > 
> > The charger has +20V tolerant input. Current input can be set from 0 to
> > 2.58 A. The charger can deliver up to 2.1 A to the battery or 3.5 A to
> > the system (when supplying additional current from battery to system).
> > 
> > The driver is configured through DTS (battery and system related
> > settings) and sysfs entries (timers and top-off charging threshold).
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> 
> I guess it makes sense to queue this together with the mfd parts.
> 
> Acked-By: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thank you. Could you also look at documentation change, patch 5/5:
Documentation: charger: max77693: Document exported sysfs entry
https://lkml.org/lkml/2014/10/20/232

I think that one also needs your ack as this is power supply related
ABI.

Best regards,
Krzysztof
