From: Lyra Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH v5 4/5] arm64: Add support for Spreadtrum's Sharkl64
 Platform in Kconfig and defconfig
Date: Fri, 16 Jan 2015 19:50:18 +0800
Message-ID: <CAAfSe-vuSgwH2PHQdYLyfJ+KZ0C8a7D6Ry=mHaBrjpbuksaKvQ@mail.gmail.com>
References: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1421402411-3479-5-git-send-email-chunyan.zhang@spreadtrum.com>
 <20150116104842.GE21809@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20150116104842.GE21809@leverpostej>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, "heiko@sntech.de" <heiko@sntech.de>, "andrew@lunn.ch" <andrew@lunn.ch>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "jslaby@suse.cz" <jslaby@suse.cz>, "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>, "arnd@arndb.de" <arnd@arndb.de>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>, "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>, "antonynpavlov@gmail.com" <antonynpavlov@gmail.com>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "grant.likely@linaro.org" <grant.likely@linaro.org>, "orsonzhai@gmail.com" <orsonzhai@gmail.com>, "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi, Mark

On Fri, Jan 16, 2015 at 6:48 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Jan 16, 2015 at 10:00:10AM +0000, Chunyan Zhang wrote:
>> From: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
>>
>> Adds support for Spreadtrum's SoC Platform in the arm64 Kconfig and
>> defconfig files.
>>
>> Signed-off-by: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
>> Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
>> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
>> ---
>>  arch/arm64/Kconfig           |    5 +++++
>>  arch/arm64/configs/defconfig |    1 +
>>  2 files changed, 6 insertions(+)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index b1f9a20..885c1f4 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -153,6 +153,11 @@ config ARCH_SEATTLE
>>       help
>>         This enables support for AMD Seattle SOC Family
>>
>> +config ARCH_SPRD
>
> This should presumably be ARCH_SHARKL64, so you can add other SoC
> families later. The other entries in here are already formatted that
> way.
>
> I wonder if we should have these of the form ARCH_${VENDOR}_${FAMILY}
> (e.g. ARCH_SPRD_SHARKL64) rather than just ARCH_${FAMILY} to save
> ourselves from name conflicts in future (and to make it easier to grep
> for a particular vendor's config options).
>

actually we've discussed this question before[1], and I think Arnd's
suggestion is suitable for our case, so I changed this to use
ARCH_SPRD instead of ARCH_SHARKL64.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/306246.html

anyway, thank you very much!

Chunyan

>> +     bool "Spreadtrum SoC platform"
>
> bool "Spreadtrun Sharkl64 SoC Family"
>
>> +     help
>> +       Support for Spreadtrum ARM based SoCs
>
>
> Support for the Spreadtrum Sharkl64 SoC family.
>
> Thanks,
> Mark.
>
>> +
