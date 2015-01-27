From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v8 0/2] Add Spreadtrum SoC bindings and serial driver support
Date: Tue, 27 Jan 2015 14:24:02 +0100
Message-ID: <2196748.ag4UzqF1Px@wuerfel>
References: <1422345407-10037-1-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1422345407-10037-1-git-send-email-chunyan.zhang@spreadtrum.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: gregkh@linuxfoundation.org, robh+dt@kernel.org, mark.rutland@arm.com, gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, grant.likely@linaro.org, jslaby@suse.cz, heiko@sntech.de, jason@lakedaemon.net, florian.vaussard@epfl.ch, andrew@lunn.ch, hytszk@gmail.com, antonynpavlov@gmail.com, shawn.guo@linaro.org, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Tuesday 27 January 2015 15:56:45 Chunyan Zhang wrote:
> This patch-set split the last version, and addressed the review comments from
> last version on serial driver code.
> 
> Changes from v7:
> * Addressed review comments from Peter:
>         - Initialized the stack local with zero in sprd_set_termios()
>         - Used dev_get_drvdata() to get sprd_uart_port
> 

Looks good to me, but you still have too many people on 'To', so Greg
might be missing that you expect him to merge it.

Greg, if there are no further comments, can you take both patches through
the tty git?

	Arnd
