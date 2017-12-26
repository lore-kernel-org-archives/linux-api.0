From: Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [patch v15 1/4] drivers: jtag: Add JTAG core driver
Date: Tue, 26 Dec 2017 09:47:13 +0100
Message-ID: <20171226084713.GA2175@nanopsycho>
References: <1514202808-29747-1-git-send-email-oleksandrs@mellanox.com>
 <1514202808-29747-2-git-send-email-oleksandrs@mellanox.com>
 <13433849-cb7d-e2c0-4ce9-d91a6012d7d7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <13433849-cb7d-e2c0-4ce9-d91a6012d7d7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Tue, Dec 26, 2017 at 12:09:08AM CET, f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>Le 12/25/17 à 03:53, Oleksandr Shamray a écrit :

[...]

>[snip]
>
>> +
>> +void *jtag_priv(struct jtag *jtag)
>> +{
>> +	return jtag->priv;
>> +}
>> +EXPORT_SYMBOL_GPL(jtag_priv);
>
>Can't you just create a static inline function in the public header for
>that? This is usually what subsystems do, I can understand why you would
>not want to expose struct jtag to other parts of the kernel, but still,
>this looks ugly, so maybe consider splitting the header between provider
>and consumer?

Other subsystems expose the struct. Here, it is intentional to don't
expose the struct, that's why we have this helper. What is ugly about
that? :)
