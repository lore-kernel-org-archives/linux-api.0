From: Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/3] tty: serial: 8250: Add Mediatek UART driver
Date: Tue, 05 Aug 2014 14:38:34 +0100
Message-ID: <1407245914.30675.31.camel@acox1-desk.ger.corp.intel.com>
References: <1407236054-30994-1-git-send-email-matthias.bgg@gmail.com>
		 <1407236054-30994-3-git-send-email-matthias.bgg@gmail.com>
		 <53E0C633.7060600@gmail.com>
	 <1407240147.30675.29.camel@acox1-desk.ger.corp.intel.com>
	 <53E0C839.3000808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53E0C839.3000808-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Varka Bhadram <varkabhadram-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, heikki.krogerus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, asierra-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org, mwelling-EkmVulN54Sk@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, m-karicheri2-l0cyMroinI0@public.gmane.org, jschultz-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, balbi-l0cyMroinI0@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2014-08-05 at 17:34 +0530, Varka Bhadram wrote:
> On 08/05/2014 05:32 PM, Alan Cox wrote:
> > On Tue, 2014-08-05 at 17:25 +0530, Varka Bhadram wrote:
> >> On 08/05/2014 04:24 PM, Matthias Brugger wrote:
> >>
> >> (...)
> >>
> >>> +#include <linux/io.h>
> >>> +#include <linux/module.h>
> >>> +#include <linux/serial_8250.h>
> >>> +#include <linux/of_irq.h>
> >>> +#include <linux/of_platform.h>
> >>> +#include <linux/platform_device.h>
> >>> +#include <linux/clk.h>
> >>> +#include <linux/pm_runtime.h>
> >>> +#include "8250.h"
> >>> +
> >> Better if we have includes in alphabetical order..
> >
> > So 8250.h would be first and it wouldn't compile ???
> >
> > Can we stick to serious critiques ?
> 
> The local headers should be at the end of all includes

Which is not alaphetical order

The include ordering does not matter, please stick to actual things that
matter.
