From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v2 03/22] fpga: bridge: remove OF dependency for fpga-bridge
Date: Thu, 21 Sep 2017 14:50:07 -0500
Message-ID: <CANk1AXRbXybjwq-ha=G6Z7nXwd8fNjPWP5awTz6=23KVXbd=kQ@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-4-git-send-email-hao.wu@intel.com> <20170921191109.GA7814@tyrael.ni.corp.natinst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170921191109.GA7814@tyrael.ni.corp.natinst.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Moritz Fischer <mdf@kernel.org>
Cc: Wu Hao <hao.wu@intel.com>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 21, 2017 at 2:11 PM, Moritz Fischer <mdf@kernel.org> wrote:

Hi Moritz,

> Hi,
>
> On Mon, Jun 26, 2017 at 09:51:59AM +0800, Wu Hao wrote:
>> This patch removes OF dependency of fpga-bridge, it allows drivers
>> to use fpga-bridge class without device tree support.
>>
>> Signed-off-by: Wu Hao <hao.wu@intel.com>
>> ---
>>  drivers/fpga/Kconfig | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
>> index ed600d5..c1d8f41 100644
>> --- a/drivers/fpga/Kconfig
>> +++ b/drivers/fpga/Kconfig
>> @@ -75,7 +75,6 @@ config FPGA_MGR_ZYNQ_FPGA
>>
>>  config FPGA_BRIDGE
>>       tristate "FPGA Bridge Framework"
>> -     depends on OF
>
> Shouldn't that dependency be removed in the patch that removes the
> dependency, or was the dependency never there in the first place?

It wasn't dependent on OF in the first place.

Thanks,
Alan

>
>>       help
>>         Say Y here if you want to support bridges connected between host
>>         processors and FPGAs or between FPGAs.
>> --
>> 1.8.3.1
>>
>
> Thanks,
>
> Moritz
