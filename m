From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 00/10] Support for Cortex-M Prototyping System
Date: Sun, 24 Apr 2016 01:43:04 +0200
Message-ID: <201604240143.04330.arnd@arndb.de>
References: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com, mark.rutland@arm.com, gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, devicetree@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, robh+dt@kernel.org, linux-serial@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Friday 01 April 2016, Vladimir Murzin wrote:
> Hi,
> 
> This patch series provides the basic support for running ucLinux on V2M-MPS2
> platform.
> 
> With these patches applied ucLinux can be run on both HW and FVP models
> with Cortex-M3/M4/M7 configurations.
> 
> Board description:
> 
> http://infocenter.arm.com/help/topic/com.arm.doc.100112_0100_03_en/arm_versatile_express_cortex_m_prototyping_system_(v2m_mps2)_technical_reference_manual_100112_0100_03_en.pdf
> 
> Application notes (cover Cortex-M3/M4/M7):
> 
> http://infocenter.arm.com/help/topic/com.arm.doc.dai0385a/DAI0385A_cortex_m3_on_v2m_mps2.pdf
> http://infocenter.arm.com/help/topic/com.arm.doc.dai0386a/DAI0386A_cortex_m4_on_v2m_mps2.pdf
> http://infocenter.arm.com/help/topic/com.arm.doc.dai0399a/DAI0399A_cortex_m7_on_v2m_mps2.pdf
> http://infocenter.arm.com/help/topic/com.arm.doc.dai0400a/DAI0400A_cortex_m7_on_v2m_mps2.pdf
> 
> Cortex-M System Design Kit (referenced as CMDK from documents above):
> 
> http://infocenter.arm.com/help/topic/com.arm.doc.ddi0479c/DDI0479C_cortex_m_system_design_kit_r1p0_trm.pdf
> 
> I'd be happy to hear any feedback/comments on this series!
> 

The whole series looks good to me, please submit the patches to the
appropriate maintainers for inclusion separately:

* patches 1-2 to the clocksource maintainers
* patches 3-5 to the serial driver maintainers
* patches 6-10 to the vexpress maintainers

I think everyone is already on Cc here, but they don't want to pick the
patches out of the series separately. I expect to get the patches for
arm-soc as part of the vexpress pull requests (dt, defconfig, and core).

	Arnd
