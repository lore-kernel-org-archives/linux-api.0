From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Thu, 27 Nov 2014 13:57:57 +0100
Message-ID: <3400511.2SONqVcoEr@wuerfel>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com> <54761BFC.4020705@ti.com> <CAAfSe-uMqy7zwiEK+nDoMPw_oni8L_vq7oW2Me5AY8z8KGpjwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAfSe-uMqy7zwiEK+nDoMPw_oni8L_vq7oW2Me5AY8z8KGpjwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Murali Karicheri <m-karicheri2-l0cyMroinI0@public.gmane.org>, Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "jslaby-AlSwsSmVLrQ@public.gmane.org" <jslaby-AlSwsSmVLrQ@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ramkumar Ramachandra <artagnon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, florian.vaussard-p8DiymsW2f8@public.gmane.org, andrew-g2DYL2Zd6BY@public.gmane.org, Hayato Suzuki <hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Orson Zhai <orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thursday 27 November 2014 19:59:46 Lyra Zhang wrote:
> 2014-11-27 2:29 GMT+08:00 Murali Karicheri <m-karicheri2-l0cyMroinI0@public.gmane.org>:
> > On 11/25/2014 07:16 AM, Chunyan Zhang wrote:
> >>
> >> Add a full sc9836-uart driver for SC9836 SoC which is based on the
> 
> >> +#include<linux/clk.h>
> >
> > How about sorting this includes? asm/irq.h go first followed linux/ in
> > alphabatical order?
> 
> >> +static irqreturn_t sprd_handle_irq(int irq, void *dev_id)
> >> +{
> >> +       struct uart_port *port = (struct uart_port *)dev_id;
> >> +       u32 ims;
> >> +
> >> +       ims = serial_in(port, SPRD_IMSR);
> >> +
> >> +       serial_out(port, SPRD_ICLR, ~0);
> >> +
> >> +       if (ims&  (SPRD_IMSR_RX_FIFO_FULL |
> >> +               SPRD_IMSR_BREAK_DETECT | SPRD_IMSR_TIMEOUT)) {
> >> +               sprd_rx(irq, port);
> >> +       }
> >> +       if (ims&  SPRD_IMSR_TX_FIFO_EMPTY)
> >> +               sprd_tx(irq, port);
> >> +
> >> +       return IRQ_HANDLED;
> >
> > You are always returning IRQ_HANDLED and this is registered as a SHARED irq.
> > Is there a chance this handler is called and the irq event doesn't
> > belong to this device?
> >
> > Murali
> 
> You are right, this is not a SHARED irq. I'll pass 0 for irqflags when
> called 'devm_request_irq' in the next version patch.

I think you could also add

	if (!ims)
		return IRQ_NONE;

which would make it work on shared interrupt lines.

	Arnd
