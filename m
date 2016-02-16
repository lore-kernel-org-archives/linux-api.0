From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 00/10] Support for Cortex-M Prototyping System
Date: Tue, 16 Feb 2016 12:05:37 +0100
Message-ID: <22011981.Gqc7zXAZ81@wuerfel>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, mark.rutland@arm.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, andy.shevchenko@gmail.com, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Liviu Dudau <liviu.dudau@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
List-Id: linux-api@vger.kernel.org

On Tuesday 16 February 2016 10:08:05 Vladimir Murzin wrote:
> Hi,
> 
> This patch series provide the basic support for running ucLinux on V2M-MPS2
> platform.
> 
> With these patches applied ucLinux can be run on both HW and FVP models
> with Cortex-M3/M4/M7 configurations.

Looks very nice overall now. I have mentioned a few details that I noticed
but no show-stoppers.

Most important question for me is how this is going to be maintained
in the long run. Can you add a patch to list the added files in
MAINTAINERS?

My preference from the arm-soc perspective would be to get pull requests for
this together with vexpress and juno through the existing maintainers
(Liviu, Sudeep, Lorenzo), and have you send your patches to them. Does
that work for you all?

	Arnd
