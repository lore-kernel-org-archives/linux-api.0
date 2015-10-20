From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 1/2] serial: support register interface with 16-bit stride
 for console
Date: Tue, 20 Oct 2015 12:37:02 +0900
Message-ID: <CAK7LNAQ-GxCRBFz+390aQQ=BcBbuEMMgxZJbS1VrqkgwTrcGYw@mail.gmail.com>
References: <1445233224-23150-1-git-send-email-yamada.masahiro@socionext.com>
	<1445233224-23150-2-git-send-email-yamada.masahiro@socionext.com>
	<5625496C.90507@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5625496C.90507@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-serial@vger.kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>, Kevin Cernekee <cernekee@gmail.com>, Jiri Slaby <jslaby@suse.com>, Rob Herring <robh@kernel.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Wang Long <long.wanglong@huawei.com>, Noam Camus <noamc@ezchip.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eddie Huang <eddie.huang@mediatek.com>
List-Id: linux-api@vger.kernel.org

Hi Peter,

2015-10-20 4:50 GMT+09:00 Peter Hurley <peter@hurleysoftware.com>:
> On 10/19/2015 01:40 AM, Masahiro Yamada wrote:
>> Currently, 8-bit (MMIO) and 32-bit (MMIO32) strides are supported for
>> the 8250 console, but 16-bit (MMIO16) stride is not.  The 8250 UART
>> device on my board has 16-bit stride (reg-shift = <1>) and I am eager
>> to use earlycon with it.
>>
>> Refer to arch/arm/boot/dts/uniphier-support-card.dtsi:
>>
>>         serialsc: uart@000b0000 {
>>                 compatible = "ns16550a";
>>                 reg = <0x000b0000 0x20>;
>>                 clock-frequency = <12288000>;
>>                 reg-shift = <1>;
>>         };
>>
>> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
>> ---
>>
>>  Documentation/kernel-parameters.txt  |  9 +++++----
>>  drivers/tty/serial/8250/8250_early.c |  5 +++++
>>  drivers/tty/serial/8250/8250_port.c  | 20 ++++++++++++++++++++
>>  drivers/tty/serial/earlycon.c        | 15 +++++++++++----
>>  drivers/tty/serial/serial_core.c     |  9 +++++++--
>>  include/linux/serial_core.h          |  1 +
>>  include/uapi/linux/serial.h          |  9 +++++----
>>  7 files changed, 54 insertions(+), 14 deletions(-)
>>
>
> [...]
>
>> diff --git a/include/uapi/linux/serial.h b/include/uapi/linux/serial.h
>> index 25331f9..1d20d9c 100644
>> --- a/include/uapi/linux/serial.h
>> +++ b/include/uapi/linux/serial.h
>> @@ -65,10 +65,11 @@ struct serial_struct {
>>  #define SERIAL_IO_PORT       0
>>  #define SERIAL_IO_HUB6       1
>>  #define SERIAL_IO_MEM        2
>> -#define SERIAL_IO_MEM32        3
>> -#define SERIAL_IO_AU   4
>> -#define SERIAL_IO_TSI          5
>> -#define SERIAL_IO_MEM32BE 6
>> +#define SERIAL_IO_MEM16      3
>> +#define SERIAL_IO_MEM32        4
>> +#define SERIAL_IO_AU   5
>> +#define SERIAL_IO_TSI          6
>> +#define SERIAL_IO_MEM32BE 7
>
> The existing values cannot be re-defined since they're userspace visible.

Thanks, I've sent v2.


-- 
Best Regards
Masahiro Yamada
