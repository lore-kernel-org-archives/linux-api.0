From: "Ivan T. Ivanov" <iivanov-NEYub+7Iv8PQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/11] coresight-etm4x: Adding CoreSight ETM4x driver
Date: Tue, 28 Apr 2015 11:30:58 +0300
Message-ID: <1430209858.1904.1.camel@mm-sol.com>
References: <1429742451-11465-1-git-send-email-mathieu.poirier@linaro.org>
	 <1429742451-11465-2-git-send-email-mathieu.poirier@linaro.org>
	 <1429890108.5211.8.camel@mm-sol.com>
	 <CANLsYky6TZhZ=JZuoBxU4dNRWVPYGUj6joMfi+dD9zjaokRE0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANLsYky6TZhZ=JZuoBxU4dNRWVPYGUj6joMfi+dD9zjaokRE0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kaixu Xia <kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


On Mon, 2015-04-27 at 09:48 -0600, Mathieu Poirier wrote:
> On 24 April 2015 at 09:41, Ivan T. Ivanov <iivanov-NEYub+7Iv8PQT0dZR+AlfA@public.gmane.org> wrote:
> > On Wed, 2015-04-22 at 16:40 -0600, Mathieu Poirier wrote:
> > 
> > > +static struct amba_id etm4_ids[] = {
> > > +       {       /* ETM 4.0 - Hi6220 board */
> > > +               .id     = 0x0003b95d,
> > > +               .mask   = 0x0003ffff,
> > > +               .data   = "ETM 4.0",
> > > +       },
> > > +       {       /* ETM 4.0 - Juno board */
> > > +               .id     = 0x000bb95e,
> > > +               .mask   = 0x000bffff,
> > 
> > Mask looks suspicious.
> 
> Can you please expand the "suspicious" part ?

Well, 'b' part of the mask. I have to admit that
I don't know how this is mapped on this platform.

Regards,
Ivan
