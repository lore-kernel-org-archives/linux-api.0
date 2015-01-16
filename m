From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Fri, 16 Jan 2015 11:26:08 +0100
Message-ID: <2026679.CiQSN0uJXp@wuerfel>
References: <1421402411-3479-6-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1421402411-3479-6-git-send-email-chunyan.zhang@spreadtrum.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: gregkh@linuxfoundation.org, mark.rutland@arm.com, gnomes@lxorguk.ukuu.org.uk, broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, will.deacon@arm.com, catalin.marinas@arm.com, jslaby@suse.cz, jason@lakedaemon.net, heiko@sntech.de, florian.vaussard@epfl.ch, andrew@lunn.ch, rrichter@cavium.com, hytszk@gmail.com, grant.likely@linaro.org, antonynpavlov@gmail.com, Joel.Schopp@amd.com, Suravee.Suthikulpanit@amd.com, shawn.guo@linaro.org, lea.yan@linaro.org, jorge.ramirez-ortiz@linaro.org, lee.jones@linaro.org, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Friday 16 January 2015 18:00:11 Chunyan Zhang wrote:
> Add a full sc9836-uart driver for SC9836 SoC which is based on the
> spreadtrum sharkl64 platform.
> This driver also support earlycon.
> This patch also replaced the spaces between the macros and their
> values with the tabs in serial_core.h
> 
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
> Originally-by: Lanqing Liu <lanqing.liu@spreadtrum.com>
> 

I see nothing wrong with the patch contents, but a few things regarding
the submission process:

- The 'Signed-off-by' lines are in the wrong order. As the person
  sending it, your S-o-b should be the last one in the list

- You have too many people on 'To'. Please send the patch only to
  the person you expect to apply it, and put the other people that
  may be interested on Cc. A lot of the people who got this mail
  are probably not interested and you can drop them completely.

- Now that everything is reviewed, split the series according to
  subsystem maintainers and send it separately: patches 1,2 and 5
  should go to GregKH as one series, the rest should go to
  'arm@kernel.org'.

- For some reason I did not get patch 4. Can you check if that
  made it to the mailing list?

Feel free to add my 'Acked-by: Arnd Bergmann <arnd@arndb.de>' to
the patches you send to Greg.

	Arnd
