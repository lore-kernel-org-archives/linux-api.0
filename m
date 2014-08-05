From: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 2/3] tty: serial: 8250: Add Mediatek UART driver
Date: Tue, 05 Aug 2014 13:02:27 +0100
Message-ID: <1407240147.30675.29.camel@acox1-desk.ger.corp.intel.com>
References: <1407236054-30994-1-git-send-email-matthias.bgg@gmail.com>
	 <1407236054-30994-3-git-send-email-matthias.bgg@gmail.com>
	 <53E0C633.7060600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <53E0C633.7060600@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rdunlap@infradead.org, gregkh@linuxfoundation.org, jslaby@suse.cz, grant.likely@linaro.org, heikki.krogerus@linux.intel.com, paul.gortmaker@windriver.com, asierra@xes-inc.com, mwelling@ieee.org, dianders@chromium.org, m-karicheri2@ti.com, jschultz@xes-inc.com, mingo@elte.hu, balbi@ti.com, heiko@sntech.de, devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 2014-08-05 at 17:25 +0530, Varka Bhadram wrote:
> On 08/05/2014 04:24 PM, Matthias Brugger wrote:
> 
> (...)
> 
> > +#include <linux/io.h>
> > +#include <linux/module.h>
> > +#include <linux/serial_8250.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/clk.h>
> > +#include <linux/pm_runtime.h>
> > +#include "8250.h"
> > +
> 
> Better if we have includes in alphabetical order..


So 8250.h would be first and it wouldn't compile ???

Can we stick to serious critiques ?

Alan


