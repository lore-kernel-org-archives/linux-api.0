From: Lyra Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH v9 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Wed, 28 Jan 2015 16:46:33 +0800
Message-ID: <CAAfSe-v4FGpHL3N3utiDwcoc7qus1XZZszuXBqB6LeE1frAfeA@mail.gmail.com>
References: <1422413261-17184-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1422413261-17184-3-git-send-email-chunyan.zhang@spreadtrum.com>
 <20150128061250.GQ2555@sapphire.tkos.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20150128061250.GQ2555@sapphire.tkos.co.il>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Baruch Siach <baruch@tkos.co.il>
Cc: Mark Rutland <mark.rutland@arm.com>, "andrew@lunn.ch" <andrew@lunn.ch>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, "jslaby@suse.cz" <jslaby@suse.cz>, "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>, Pawel Moll <pawel.moll@arm.com>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>, "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>, "antonynpavlov@gmail.com" <antonynpavlov@gmail.com>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, Grant Likely <grant.likely@linaro.org>, Orson Zhai <orsonzhai@gmail.com>, "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "jason@lakedaemon.net" <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>, "ijc+devicetree@hellion.org.uk" <ijc+devicetr>
List-Id: linux-api@vger.kernel.org

Hi, Baruch

I'm sorry that I didn't receive your previous email.
and my explanations are below.

On Wed, Jan 28, 2015 at 2:12 PM, Baruch Siach <baruch@tkos.co.il> wrote:
> Hi Chunyan Zhang,
>
> On Wed, Jan 28, 2015 at 10:47:41AM +0800, Chunyan Zhang wrote:
> [...]
>> +static inline void sprd_rx(struct uart_port *port)
>> +{
>> +     struct tty_port *tty = &port->state->port;
>> +     unsigned int ch, flag, lsr, max_count = SPRD_TIMEOUT;
>> +
>> +     while ((serial_in(port, SPRD_STS1) & 0x00ff) && max_count--) {
>> +             lsr = serial_in(port, SPRD_LSR);
>> +             ch = serial_in(port, SPRD_RXD);
>> +             flag = TTY_NORMAL;
>> +             port->icount.rx++;
>> +
>> +             if (lsr & (SPRD_LSR_BI | SPRD_LSR_PE |
>> +                     SPRD_LSR_FE | SPRD_LSR_OE))
>> +                     if (handle_lsr_errors(port, &lsr, &flag))
>> +                             continue;
>> +             if (uart_handle_sysrq_char(port, ch))
>> +                     continue;
>
> My comment[1] on a previous version of this patch still stands.
> uart_handle_sysrq_char is a NOP when SUPPORT_SYSRQ is not defined.
>

yes, there are two definitions in serial_core.h, and it returns 0 when
SUPPORT_SYSRQ is not defined.
so, I think my code behavior does not hurt, right?

>> +
>> +             uart_insert_char(port, lsr, SPRD_LSR_OE, ch, flag);
>> +     }
>> +
>> +     tty_flip_buffer_push(tty);
>> +}
>
> [...]
>
>> +static void sprd_console_write(struct console *co, const char *s,
>> +                                   unsigned int count)
>> +{
>> +     struct uart_port *port = &sprd_port[co->index]->port;
>> +     int locked = 1;
>> +     unsigned long flags;
>> +
>> +     if (port->sysrq)
>> +             locked = 0;
>
> The sysrq field of struct uart_port is only defined when
> CONFIG_SERIAL_CORE_CONSOLE or SUPPORT_SYSRQ are defined. You should #ifdef
> this part accordingly to avoid build breakage.
>

we have this part to been included under #ifdef
CONFIG_SERIAL_SPRD_CONSOLE which is selected with SERIAL_CORE_CONSOLE.

Thank you very much!

Chunyan

>> +     else if (oops_in_progress)
>> +             locked = spin_trylock_irqsave(&port->lock, flags);
>> +     else
>> +             spin_lock_irqsave(&port->lock, flags);
>> +
>> +     uart_console_write(port, s, count, sprd_console_putchar);
>> +
>> +     /* wait for transmitter to become empty */
>> +     wait_for_xmitr(port);
>> +
>> +     if (locked)
>> +             spin_unlock_irqrestore(&port->lock, flags);
>> +}
>
> [1]
>         http://article.gmane.org/gmane.linux.drivers.devicetree/106483
>
> baruch
>
> --
>      http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
> =}------------------------------------------------ooO--U--Ooo------------{=
>    - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
