From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH V2 6/6] coresight-stm: adding driver for CoreSight STM component
Date: Fri, 05 Feb 2016 15:06:20 +0200
Message-ID: <87h9hn5msz.fsf@ashishki-desk.ger.corp.intel.com>
References: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org> <1454487337-30184-7-git-send-email-zhang.chunyan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1454487337-30184-7-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Chunyan Zhang <zhang.chunyan@linaro.org>, mathieu.poirier@linaro.org
Cc: robh@kernel.org, broonie@kernel.org, pratikp@codeaurora.org, nicolas.guion@st.com, corbet@lwn.net, mark.rutland@arm.com, mike.leach@arm.com, tor@ti.com, al.grant@arm.com, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
List-Id: linux-api@vger.kernel.org

Chunyan Zhang <zhang.chunyan@linaro.org> writes:

> +#ifndef CONFIG_64BIT
> +static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
> +{
> +	asm volatile("strd %1, %0"
> +		     : "+Qo" (*(volatile u64 __force *)addr)
> +		     : "r" (val));
> +}

Is it really ok to do this for all !64bit arms, inside a driver, just
like that? I'm not an expert, but I'm pretty sure there's more to it.

Regards,
--
Alex
