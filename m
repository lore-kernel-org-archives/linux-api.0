From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH] coresight-stm: adding driver for CoreSight STM component
Date: Wed, 25 Feb 2015 10:08:33 -0700
Message-ID: <CANLsYkzXiB-L+kvH=AXifKMz-K09H8rQ5nJvyxb5Lv57dmZa1Q@mail.gmail.com>
References: <1423088550-15780-1-git-send-email-mathieu.poirier@linaro.org>
	<1423135651.27378.32.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1423135651.27378.32.camel@x220>
Sender: linux-doc-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jon Corbet <corbet@lwn.net>, Pratik Patel <pratikp@codeaurora.org>, Al Grant <al.grant@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, Kaixu Xia <kaixu.xia@linaro.org>, Jeenu Viswambharan <jeenu.viswambharan@arm.com>, Greg KH <gregkh@linuxfoundation.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-api@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 5 February 2015 at 04:27, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Wed, 2015-02-04 at 15:22 -0700, mathieu.poirier@linaro.org wrote:
>> From: Pratik Patel <pratikp@codeaurora.org>
>>
>> This driver adds support for the STM CoreSight IP block,
>> allowing any system compoment (HW or SW) to log and
>> aggregate messages via a single entity.
>>
>> The STM exposes an application defined number of channels
>> called stimulus port.  Configuration is done using entries
>> in sysfs and channels made available to userspace via devfs.
>>
>> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>
> This needs "coresight: Adding coresight support for arm64
> architecture" (https://lkml.org/lkml/2015/2/3/677 ) in order to get
> applied. Perhaps that's obvious to the people working on this.
>
> A few comments follow.
>
>> ---
>>  .../ABI/testing/sysfs-bus-coresight-devices-stm    |   62 ++
>>  Documentation/trace/coresight.txt                  |   88 +-
>>  drivers/coresight/Kconfig                          |   10 +
>>  drivers/coresight/Makefile                         |    1 +
>>  drivers/coresight/coresight-stm.c                  | 1090 ++++++++++++++++++++
>>  include/linux/coresight-stm.h                      |   35 +
>>  include/uapi/linux/coresight-stm.h                 |   23 +
>>  7 files changed, 1307 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-stm
>>  create mode 100644 drivers/coresight/coresight-stm.c
>>  create mode 100644 include/linux/coresight-stm.h
>>  create mode 100644 include/uapi/linux/coresight-stm.h
>>
>>[...]
>> diff --git a/drivers/coresight/Kconfig b/drivers/coresight/Kconfig
>> index fc1f1ae7a49d..08806cc7d737 100644
>> --- a/drivers/coresight/Kconfig
>> +++ b/drivers/coresight/Kconfig
>> @@ -58,4 +58,14 @@ config CORESIGHT_SOURCE_ETM3X
>>         which allows tracing the instructions that a processor is executing
>>         This is primarily useful for instruction level tracing.  Depending
>>         the ETM version data tracing may also be available.
>> +
>> +config CORESIGHT_STM
>> +     bool "CoreSight System Trace Macrocell driver"
>> +     depends on (ARM && !(CPU_32v4 || CPU_32v4T)) || ARM64 || (64BIT && COMPILE_TEST)
>
> I'm _guessing_ that CPU_32v4 and CPU_32v4T are needed for the ldrd and
> strd assembler instructions. If that's right a next _guess_ would be
> that you also need to mention CPU_32v3 here.

Sorry for the late reply - I've been travelling.

After taking a closer at the Kconfig files I will indeed add CPU_32v3
to the condition.  On the flip side I don't see what the advantage
would be to write  !CPU_32v3 && !CPU_32v4 && !CPU_32v4T as you
suggested.

>
> Furthermore, this file is only sourced by arch/arm/Kconfig.debug and
> arch/arm64/Kconfig.debug. So 64BIT should always be equal to ARM64 and
> the
>      || (64BIT && COMPILE_TEST)
>
> part shouldn't be needed, isn't it?

Correct.

>
>> +     select CORESIGHT_LINKS_AND_SINKS
>> +     help
>> +       This driver provides support for hardware assisted software
>> +       instrumentation based tracing. This is primarily used for
>> +       logging useful software events or data coming from various entities
>> +       in the system, possibly running different OSs
>>  endif
>>[...]
>> diff --git a/drivers/coresight/coresight-stm.c b/drivers/coresight/coresight-stm.c
>> new file mode 100644
>> index 000000000000..e59b0fe01d87
>> --- /dev/null
>> +++ b/drivers/coresight/coresight-stm.c
>> @@ -0,0 +1,1090 @@
>>[...]
>> +#ifndef CONFIG_64BIT
>> +static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
>> +{
>> +     asm volatile("strd %1, %0"
>> +                  : "+Qo" (*(volatile u64 __force *)addr)
>> +                  : "r" (val));
>> +}
>> +
>> +static inline u64 __raw_readq(const volatile void __iomem *addr)
>> +{
>> +     u64 val;
>> +
>> +     asm volatile("ldrd %1, %0"
>> +                  : "+Qo" (*(volatile u64 __force *)addr),
>> +                    "=r" (val));
>> +     return val;
>> +}
>> +
>> +#undef readq_relaxed
>> +#define readq_relaxed(c) ({ u64 __r = le64_to_cpu((__force __le64) \
>> +                                     __raw_readq(c)); __r; })
>
> I spotted no users of readq_relaxed. Is it needed?
>
>> +#undef writeq_relaxed
>> +#define writeq_relaxed(v, c) __raw_writeq((__force u64) cpu_to_le64(v), c)
>> +#endif
>> +
>> [...]
>
>> +static ssize_t entities_show(struct device *dev,
>> +                          struct device_attribute *attr, char *buf)
>> +{
>> +     struct stm_drvdata *drvdata = dev_get_drvdata(dev->parent);
>> +     ssize_t len;
>> +
>> +     len = bitmap_scnprintf(buf, PAGE_SIZE, drvdata->entities,
>> +                            STM_ENTITY_MAX);
>> +
>
> bitmap_scnprintf is gone in current linux-next. I changed it to
>         len = scnprintf(buf, PAGE_SIZE, "%*pb", STM_ENTITY_MAX,
>                         drvdata->entities);
>
> to get this file to compile. (On x86_64, that is, but please don't tell
> anybody!)
>
>
> Paul Bolle
>
