From: Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] core drm support for Rockchip SoCs v14
Date: Tue, 2 Dec 2014 13:53:01 +1000
Message-ID: <CAPM=9tzaapZr7UoOu0J5F55tWt36f4SShM8bHXdWkGyED5pd5A@mail.gmail.com>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>
	<5476CC59.6080607@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5476CC59.6080607-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Douglas Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chr>
List-Id: linux-api@vger.kernel.org

On 27 November 2014 at 17:01, Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wrote:
> Hi Dave
>
>     this pull request is for rockchip drm v14, based on Joerg's iommu
> arm/rockchip branch.
>
> The following changes since commit 656d7077d8ffd1c2492d4a0a354367ab2e545059:
>
>   dt-bindings: iommu: Add documentation for rockchip iommu (2014-11-03
> 17:29:09 +0100)
>
> are available in the git repository at:
>
>   https://github.com/markyzq/kernel-drm-rockchip.git drm_iommu
>
> for you to fetch changes up to aab18af3a93353bc43897b716fd7e12d5998b9bc:
>
>   dt-bindings: video: Add documentation for rockchip vop (2014-11-27

For list prosperity, now that I can build this, I find it can't build
as a module

 LD [M]  drivers/gpu/drm/rockchip/rockchipdrm.o
drivers/gpu/drm/rockchip/rockchip_drm_vop.o: In function `init_module':
rockchip_drm_vop.c:(.init.text+0x0): multiple definition of `init_module'
drivers/gpu/drm/rockchip/rockchip_drm_drv.o:rockchip_drm_drv.c:(.init.text+0x0):
first defined here
drivers/gpu/drm/rockchip/rockchip_drm_vop.o: In function `cleanup_module':
rockchip_drm_vop.c:(.exit.text+0x0): multiple definition of `cleanup_module'
drivers/gpu/drm/rockchip/rockchip_drm_drv.o:rockchip_drm_drv.c:(.exit.text+0x0):
first defined here

not sure what your plan for the vop.c variant should be, is it an extra module,
or just part of rockchipdrm?

Dave.
