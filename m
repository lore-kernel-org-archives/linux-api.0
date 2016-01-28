From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH REBASE 4.5 00/31] Sharing media resources across ALSA and
 au0828 drivers
Date: Thu, 28 Jan 2016 07:56:55 -0700
Message-ID: <56AA2C37.3090309@osg.samsung.com>
References: <cover.1453336830.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1453336830.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: clemens@ladisch.de, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.org, alsa-devel@alsa-pro
List-Id: linux-api@vger.kernel.org

On 01/21/2016 11:09 AM, Shuah Khan wrote:
> Please note that I am sending just the 4 patches that
> changed during series rebase to Linux 4.5. The rebase
> was pain free. media_device_init() type change required
> changes to patches 18 and 26. I re-tested the series
> and everything looks good.
> 
> [PATCH 16/31] media: au0828 video remove au0828_enable_analog_tuner()
> [PATCH 18/31] media: au0828 change to use Managed Media Controller API
> [PATCH 22/31] media: dvb-core create tuner to demod pad link in disabled state
> [PATCH v3 26/31] sound/usb: Update ALSA driver to use Managed Media Controller API
> 
> Links:
> PATCH Series that contains all 31 patches:
> https://lkml.org/lkml/2016/1/6/668
> 
> ALSA patches went through reviews and links
> to PATCH V3 (ALSA):
> https://lkml.org/lkml/2016/1/18/556
> https://lkml.org/lkml/2016/1/18/557
> https://lkml.org/lkml/2016/1/18/558
> 
> Compile warns patches:
> https://lkml.org/lkml/2016/1/19/520
> https://lkml.org/lkml/2016/1/19/518
> https://lkml.org/lkml/2016/1/19/519
> 
> Mauro and Takashi:
> Please let me know if you would rather see the entire
> patch series generated for 4.5-rc1 and sent out in a
> complete series instead of just the rebased patches.
> 

Hi Takashi,

Are you okay with this ALSA patch series?
If so could you please Ack these patches
so they can be pulled into media tree.

Mauro,

Could you please look these over and give
me feedback and let me know if you would
like me to resend all the patches in final
series.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
