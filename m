From: Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>
Subject: Re: [patch v12 2/4] drivers: jtag: Add Aspeed SoC 24xx and 25xx
 families JTAG master driver
Date: Thu, 30 Nov 2017 09:21:29 +0100
Message-ID: <CAOFm3uHg8n4A8opaOC3=pNtM1yJU6iy5Ta8XtGOvqT-Euv=X1w@mail.gmail.com>
References: <1510675867-24276-1-git-send-email-oleksandrs@mellanox.com>
 <1510675867-24276-3-git-send-email-oleksandrs@mellanox.com> <CAGMNF6XRwU5QEJhkg-mVwE5zpPigtcGJtRUupZHtcWRdedcsxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGMNF6XRwU5QEJhkg-mVwE5zpPigtcGJtRUupZHtcWRdedcsxg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kun Yi <kunyi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, OpenBMC Maillist <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 29, 2017 at 11:51 PM, Kun Yi <kunyi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Nov 14, 2017 at 8:11 AM, Oleksandr Shamray
> <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
[]
>> diff --git a/drivers/jtag/jtag-aspeed.c b/drivers/jtag/jtag-aspeed.c
>> new file mode 100644
>> index 0000000..a6e2417
>> --- /dev/null
>> +++ b/drivers/jtag/jtag-aspeed.c
>> @@ -0,0 +1,782 @@
>> +/*
>> + * drivers/jtag/aspeed-jtag.c
>> + *
>> + * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
>> + * Copyright (c) 2017 Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> + *
>> + * Released under the GPLv2 only.
>> + * SPDX-License-Identifier: GPL-2.0
>> + */

I think the SPDX id should be on the first line as requested by Linus
and documented by Thomas (tglx) and Greg (greg-kh). And it should use
// comments, e.g:

// SPDX-License-Identifier: GPL-2.0

See the threads discussing all these.


-- 
Cordially
Philippe Ombredanne
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
