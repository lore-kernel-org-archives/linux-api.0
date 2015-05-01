From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [PATCH v2 01/11] coresight-etm4x: Adding CoreSight ETM4x driver
Date: Fri, 01 May 2015 20:28:56 +0200
Message-ID: <1430504936.3928.13.camel@tiscali.nl>
References: <1430327795-10710-1-git-send-email-mathieu.poirier@linaro.org>
	 <1430327795-10710-2-git-send-email-mathieu.poirier@linaro.org>
	 <1430429397.2187.34.camel@x220>
	 <CANLsYkywp0o8YtjkFwfvEiAje-w2jCWbs_82SiD29xdirA_7vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANLsYkywp0o8YtjkFwfvEiAje-w2jCWbs_82SiD29xdirA_7vQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kaixu Xia <kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Mathieu Poirier schreef op vr 01-05-2015 om 08:39 [-0600]:
> On 30 April 2015 at 15:29, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org> wrote:
> > On Wed, 2015-04-29 at 11:16 -0600, Mathieu Poirier wrote:
> >> +#include <linux/module.h>
> >
> > Is this include needed?
> 
> It is needed for "module_param_named()".

I guess that it should suffice to include just
include/linux/moduleparam.h. (Note that [...]/module.h includes
[...]/moduleparam.h.)

> >> +module_amba_driver(etm4x_driver);
> >
> > In a message I sent a short while ago, I suggested that for built-in
> > only code this is equivalent to calling
> >     amba_driver_register(&etm4x_driver);
> >
> > from within a function marked with some sort of *initcall(). Please
> > double check.
> 
> Built-in as a module or not using "module_amba_driver()" deals with
> redundant code.

This is becoming yet another pet peeve: idempotent macros prefixed with
module_. driver_ would be a better prefix. But, in this case,
driver_amba_driver() is silly, amba_driver is used already, and
register_amba_driver() looks like amba_driver_register() way too much.

I fear that this pet peeve is going to hang around my place for quite
some time.

Thanks,


Paul Bolle
