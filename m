From: Lyra Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH v9 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Wed, 28 Jan 2015 18:46:53 +0800
Message-ID: <CAAfSe-t-to3=KrUH2cWQXy710H8Lr3Nd7Za1yoaxio4i70c51w@mail.gmail.com>
References: <1422413261-17184-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1422413261-17184-3-git-send-email-chunyan.zhang@spreadtrum.com>
 <20150128061250.GQ2555@sapphire.tkos.co.il>
 <CAAfSe-v4FGpHL3N3utiDwcoc7qus1XZZszuXBqB6LeE1frAfeA@mail.gmail.com>
 <20150128095401.GC14175@tarshish>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20150128095401.GC14175@tarshish>
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

On Wed, Jan 28, 2015 at 5:54 PM, Baruch Siach <baruch@tkos.co.il> wrote:
> Hi Lyra Zhang,
>
> On Wed, Jan 28, 2015 at 04:46:33PM +0800, Lyra Zhang wrote:
>> On Wed, Jan 28, 2015 at 2:12 PM, Baruch Siach <baruch@tkos.co.il> wrote:
>> > On Wed, Jan 28, 2015 at 10:47:41AM +0800, Chunyan Zhang wrote:
>> >> +             if (uart_handle_sysrq_char(port, ch))
>> >> +                     continue;
>> >
>> > My comment[1] on a previous version of this patch still stands.
>> > uart_handle_sysrq_char is a NOP when SUPPORT_SYSRQ is not defined.
>>
>> yes, there are two definitions in serial_core.h, and it returns 0 when
>> SUPPORT_SYSRQ is not defined.
>> so, I think my code behavior does not hurt, right?
>
> Right. I just wanted to point out that you can easily define SUPPORT_SYSRQ as
> appropriate like many other serial drivers do to get sysrq support.
>

Ok, I got it. I'll add SUPPORT_SYSRQ definition, and send v10 to Greg.

thanks,
Chunyan

> baruch
>
> --
>      http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
> =}------------------------------------------------ooO--U--Ooo------------{=
>    - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
