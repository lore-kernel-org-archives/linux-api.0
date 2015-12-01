From: punnaiah choudary kalluri <punnaia-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mtd: Expand the ecc placement locations to 1216
Date: Tue, 1 Dec 2015 21:41:33 +0530
Message-ID: <CAGnW=BYU3zFXXKX68d9y0xoe16MRkKJ928X2wXNDPWTd5-tWHw@mail.gmail.com>
References: <1446742735-20824-1-git-send-email-punnaia@xilinx.com>
	<20151120193342.GX64635@google.com>
	<20151201121512.40ce9cce@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151201121512.40ce9cce@bbrezillon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Cc: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "michals-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org" <michals-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>, "linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Punnaiah Choudary <kpc528-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Boris,

On Tue, Dec 1, 2015 at 4:45 PM, Boris Brezillon
<boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org> wrote:
> Brian, Punnaiah,
>
> On Fri, 20 Nov 2015 11:33:42 -0800
> Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Thu, Nov 05, 2015 at 10:28:55PM +0530, Punnaiah Choudary Kalluri wrote:
>> > Device like MT29F32G08ABCDBJ4 have a writesize/oobsize of 16K/1216 Bytes.
>> > So, increasing the maximum ecc placement locations to 1216
>>
>> I'd really prefer not increasing the size of the internal arrays any
>> more. The structures should be rewritten to be dynamic.
>
> I already started this migration (you can find the code here [1]). I
> was planning to rework this series to make the eccpos definition mimic
> what's done for oobfree (as suggested by Brian) before sending it, but
> I'm not sure when I'll be able to do that, so if you really need that
> quickly I suggest you submit those patches instead of reimplementing
> it yourself.
>

Sure. let me check your implementation and then send these patches for review
with your sign off.

Thanks,
Punnaiah

> Best Regards,
>
> Boris
>
> [1]https://github.com/bbrezillon/linux-sunxi/commits/nand/ecclayout
>
> --
> Boris Brezillon, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com
