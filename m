From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 28/31] media: au0828 create link between ALSA Mixer and
 decoder
Date: Thu, 28 Jan 2016 13:17:44 -0700
Message-ID: <56AA7768.2000109@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <1dcd64196cffd05bdaeb16c767ee8d2adb90e2e6.1452105878.git.shuahkh@osg.samsung.com>
 <20160128145824.3cf1a468@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160128145824.3cf1a468@recife.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

On 01/28/2016 09:58 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  6 Jan 2016 13:27:17 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Change au0828_create_media_graph() to create pad link
>> between MEDIA_ENT_F_AUDIO_MIXER entity and decoder's
>> AU8522_PAD_AUDIO_OUT. With mixer entity now linked to
>> decoder, change to link MEDIA_ENT_F_AUDIO_CAPTURE to
>> mixer's source pad.
> 
> See my comments about doing only this asynchronously on the previous
> patches.
> 

Yes. I responded to that one. I might collapse both ALSA
patch that adds capture and mixer into one. Might make
it lot easier and handle them at the same time.

thanks,
-- Shuah

> 
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/usb/au0828/au0828-core.c | 17 ++++++++++++++---
>>  drivers/media/usb/au0828/au0828.h      |  1 +
>>  2 files changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
>> index 722e073..886fb28 100644
>> --- a/drivers/media/usb/au0828/au0828-core.c
>> +++ b/drivers/media/usb/au0828/au0828-core.c
>> @@ -264,6 +264,7 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>>  	struct media_entity *entity;
>>  	struct media_entity *tuner = NULL, *decoder = NULL;
>>  	struct media_entity *audio_capture = NULL;
>> +	struct media_entity *mixer = NULL;
>>  	int i, ret;
>>  
>>  	if (!mdev)
>> @@ -284,6 +285,9 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>>  		case MEDIA_ENT_F_AUDIO_CAPTURE:
>>  			audio_capture = entity;
>>  			break;
>> +		case MEDIA_ENT_F_AUDIO_MIXER:
>> +			mixer = entity;
>> +			break;
>>  		}
>>  	}
>>  
>> @@ -356,14 +360,21 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>>  			}
>>  		}
>>  	}
>> -	if (audio_capture && !dev->audio_capture_linked) {
>> -		ret = media_create_pad_link(decoder, AU8522_PAD_AUDIO_OUT,
>> -					    audio_capture, 0,
>> +	if (mixer && audio_capture && !dev->audio_capture_linked) {
>> +		ret = media_create_pad_link(mixer, 1, audio_capture, 0,
>>  					    MEDIA_LNK_FL_ENABLED);
>>  		if (ret)
>>  			return ret;
>>  		dev->audio_capture_linked = 1;
>>  	}
>> +	if (mixer && !dev->mixer_linked) {
>> +		ret = media_create_pad_link(decoder, AU8522_PAD_AUDIO_OUT,
>> +					    mixer, 0,
>> +					    MEDIA_LNK_FL_ENABLED);
>> +		if (ret)
>> +			return ret;
>> +		dev->mixer_linked = 1;
>> +	}
>>  #endif
>>  	return 0;
>>  }
>> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
>> index 3707664..b9aa74f 100644
>> --- a/drivers/media/usb/au0828/au0828.h
>> +++ b/drivers/media/usb/au0828/au0828.h
>> @@ -289,6 +289,7 @@ struct au0828_dev {
>>  	bool vdev_linked;
>>  	bool vbi_linked;
>>  	bool audio_capture_linked;
>> +	bool mixer_linked;
>>  	struct media_link *active_link;
>>  	struct media_entity *active_link_owner;
>>  #endif


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
