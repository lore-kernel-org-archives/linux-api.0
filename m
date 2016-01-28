From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH REBASE 4.5 00/31] Sharing media resources across ALSA and
 au0828 drivers
Date: Thu, 28 Jan 2016 14:55:23 -0700
Message-ID: <56AA8E4B.8080105@osg.samsung.com>
References: <cover.1453336830.git.shuahkh@osg.samsung.com>
 <56AA2C37.3090309@osg.samsung.com> <s5h60yd7mwo.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <s5h60yd7mwo.wl-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com, mchehab@osg.samsung.com, alsa-devel@alsa-project.org, arnd@arndb.de, ricard.wanderlof@axis.com, labbott@fedoraproject.org, chehabrafael@gmail.com, misterpib@gmail.com, prabhakar.csengg@gmail.com, ricardo.ribalda@gmail.com, ruchandani.tina@gmail.com, takamichiho@gmail.com, tvboxspy@gmail.com, dominic.sacre@gmx.de, crope@iki.fi, julian@jusst.de, clemens@ladisch.de, pierre-louis.bossart@linux.intel.com, corbet@lwn.net, joe@oampo.co.uk, johan@oljud.se, dan.carpenter@oracle.com, pawel@osciak.com, p.zabel@pengutronix.de, perex@perex.cz, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, k.kozlowski@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, sw0312.kim@samsung.com, elfring@users.sourceforge.net, linux-api@vger.kernel.o
List-Id: linux-api@vger.kernel.org

On 01/28/2016 08:18 AM, Takashi Iwai wrote:
> On Thu, 28 Jan 2016 15:56:55 +0100,
> Shuah Khan wrote:
>>
>> On 01/21/2016 11:09 AM, Shuah Khan wrote:
>>> Please note that I am sending just the 4 patches that
>>> changed during series rebase to Linux 4.5. The rebase
>>> was pain free. media_device_init() type change required
>>> changes to patches 18 and 26. I re-tested the series
>>> and everything looks good.
>>>
>>> [PATCH 16/31] media: au0828 video remove au0828_enable_analog_tuner()
>>> [PATCH 18/31] media: au0828 change to use Managed Media Controller API
>>> [PATCH 22/31] media: dvb-core create tuner to demod pad link in disabled state
>>> [PATCH v3 26/31] sound/usb: Update ALSA driver to use Managed Media Controller API
>>>
>>> Links:
>>> PATCH Series that contains all 31 patches:
>>> https://lkml.org/lkml/2016/1/6/668
>>>
>>> ALSA patches went through reviews and links
>>> to PATCH V3 (ALSA):
>>> https://lkml.org/lkml/2016/1/18/556
>>> https://lkml.org/lkml/2016/1/18/557
>>> https://lkml.org/lkml/2016/1/18/558
>>>
>>> Compile warns patches:
>>> https://lkml.org/lkml/2016/1/19/520
>>> https://lkml.org/lkml/2016/1/19/518
>>> https://lkml.org/lkml/2016/1/19/519
>>>
>>> Mauro and Takashi:
>>> Please let me know if you would rather see the entire
>>> patch series generated for 4.5-rc1 and sent out in a
>>> complete series instead of just the rebased patches.
>>>
>>
>> Hi Takashi,
>>
>> Are you okay with this ALSA patch series?
> 
> Sorry, too little time until now.
> I know there are still a few potential problems.  Will do detailed
> reviews later.
> 

I would like to wrap this up and hopefully get this
into 4.6. Please let me know if you will be able to
review in time for that.

I have a few comments work on from Mauro and would
like to address comments from you as well at the same
time.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
