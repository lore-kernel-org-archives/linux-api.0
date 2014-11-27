From: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
Date: Thu, 27 Nov 2014 09:40:23 +0800
Message-ID: <54768107.2090402@rock-chips.com>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>	<23617908.6oA5uRuO3l@diego>	<CAPM=9tzvvb5U+8KaCO+K6CJi=rwWOkoW+4ZSFW_Oo9gTncvkWA@mail.gmail.com>	<1557742.FTdLsE0bVs@diego>	<20141126073430.GD3156@suse.de> <CAPM=9tzhZLShA5=ShGTKhyZR6ddKycQDUWBZxXpUBb+1tGp-mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM=9tzhZLShA5=ShGTKhyZR6ddKycQDUWBZxXpUBb+1tGp-mQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>
Cc: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Douglas Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>=?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marc>
List-Id: linux-api@vger.kernel.org

On 2014=E5=B9=B411=E6=9C=8827=E6=97=A5 06:53, Dave Airlie wrote:
> On 26 November 2014 at 17:34, Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org> wrote:
>> On Wed, Nov 26, 2014 at 01:37:51AM +0100, Heiko St=C3=BCbner wrote:
>>> Joerg, is your arm/rockchip branch [0] considered stable?
>>>
>>> [0] https://git.kernel.org/cgit/linux/kernel/git/joro/iommu.git/log=
/?h=3Darm/rockchip
>>>
>> Yes, this branch will not be rebased. It can be pulled into another
>> tree.
> Great, so if we can get a rockchip drm tree based on drm-next with
> that tree pulled into it
> that would be good.
>
> Dave.
>
>
>
Hi Dave
     Do you mean that I need send you a branch, based on drm-next, merg=
e=20
with iommu tree and rockchip drm?

- Mark


--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
