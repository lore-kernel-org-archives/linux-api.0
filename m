From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 08/10] ARM: configs: add MPS2 defconfig
Date: Tue, 16 Feb 2016 11:58:42 +0100
Message-ID: <2680417.bULLX3O66Y@wuerfel>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com> <1455617295-23736-9-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455617295-23736-9-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, mark.rutland@arm.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, andy.shevchenko@gmail.com, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tuesday 16 February 2016 10:08:13 Vladimir Murzin wrote:
> This patch adds a new config for MPS2 platform.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arch/arm/configs/mps2_defconfig |  112 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 112 insertions(+)
>  create mode 100644 arch/arm/configs/mps2_defconfig
> 
> diff --git a/arch/arm/configs/mps2_defconfig b/arch/arm/configs/mps2_defconfig
> new file mode 100644
> index 0000000..c36c519
> --- /dev/null
> +++ b/arch/arm/configs/mps2_defconfig
> @@ -0,0 +1,112 @@
> +# CONFIG_USELIB is not set
> +CONFIG_NO_HZ_IDLE=y
> +CONFIG_HIGH_RES_TIMERS=y
> +CONFIG_LOG_BUF_SHIFT=16
> +CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> +# CONFIG_UID16 is not set
> +# CONFIG_BASE_FULL is not set
> +# CONFIG_FUTEX is not set
> +# CONFIG_EPOLL is not set
> +# CONFIG_SIGNALFD is not set
> +# CONFIG_EVENTFD is not set
> +# CONFIG_AIO is not set
> +CONFIG_EMBEDDED=y

Why CONFIG_EMBEDDED? You probably mean CONFIG_EXPERT, but then what do
you need that for?

	Arnd
