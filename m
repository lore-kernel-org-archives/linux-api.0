From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 01/31] uapi/media.h: Declare interface types for ALSA
Date: Mon, 1 Feb 2016 10:04:38 -0700
Message-ID: <56AF9026.9080102@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <b1d228cdcc9246f7bfe28877e9f6bff174e94993.1452105878.git.shuahkh@osg.samsung.com>
 <20160128125941.143f67d0@recife.lan> <56AF82D7.1020900@osg.samsung.com>
 <s5hr3gwl7zz.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <s5hr3gwl7zz.wl-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, alsa-devel@alsa-project.org, arnd@arndb.de, ricard.wanderlof@axis.com, hans.verkuil@cisco.com, labbott@fedoraproject.org, chehabrafael@gmail.com, misterpib@gmail.com, prabhakar.csengg@gmail.com, ricardo.ribalda@gmail.com, ruchandani.tina@gmail.com, takamichiho@gmail.com, tvboxspy@gmail.com, dominic.sacre@gmx.de, laurent.pinchart@ideasonboard.com, crope@iki.fi, julian@jusst.de, clemens@ladisch.de, pierre-louis.bossart@linux.intel.com, sakari.ailus@linux.intel.com, corbet@lwn.net, joe@oampo.co.uk, johan@oljud.se, dan.carpenter@oracle.com, pawel@osciak.com, javier@osg.samsung.com, p.zabel@pengutronix.de, perex@perex.cz, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, k.kozlowski@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, sw0312.kim@samsung.com, elfring@users.sourceforge.net
List-Id: linux-api@vger.kernel.org

On 02/01/2016 09:18 AM, Takashi Iwai wrote:
> On Mon, 01 Feb 2016 17:07:51 +0100,
> Shuah Khan wrote:
>>
>> On 01/28/2016 07:59 AM, Mauro Carvalho Chehab wrote:
>>> Em Wed,  6 Jan 2016 13:26:50 -0700
>>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
>>>
>>>> From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>
>>>> Declare the interface types to be used on alsa for the new
>>>> G_TOPOLOGY ioctl.
>>>>
>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>> ---
>>>>  drivers/media/media-entity.c | 12 ++++++++++++
>>>>  include/uapi/linux/media.h   |  8 ++++++++
>>>>  2 files changed, 20 insertions(+)
>>>>
>>>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>>>> index eb38bc3..6e02d19 100644
>>>> --- a/drivers/media/media-entity.c
>>>> +++ b/drivers/media/media-entity.c
>>>> @@ -65,6 +65,18 @@ static inline const char *intf_type(struct media_interface *intf)
>>>>  		return "v4l2-subdev";
>>>>  	case MEDIA_INTF_T_V4L_SWRADIO:
>>>>  		return "swradio";
>>>> +	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
>>>> +		return "pcm-capture";
>>>> +	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
>>>> +		return "pcm-playback";
>>>> +	case MEDIA_INTF_T_ALSA_CONTROL:
>>>> +		return "alsa-control";
>>>> +	case MEDIA_INTF_T_ALSA_COMPRESS:
>>>> +		return "compress";
>>>> +	case MEDIA_INTF_T_ALSA_RAWMIDI:
>>>> +		return "rawmidi";
>>>> +	case MEDIA_INTF_T_ALSA_HWDEP:
>>>> +		return "hwdep";
>>>>  	default:
>>>>  		return "unknown-intf";
>>>>  	}
>>>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>>>> index cacfceb..75cbe92 100644
>>>> --- a/include/uapi/linux/media.h
>>>> +++ b/include/uapi/linux/media.h
>>>> @@ -252,6 +252,7 @@ struct media_links_enum {
>>>>  
>>>>  #define MEDIA_INTF_T_DVB_BASE	0x00000100
>>>>  #define MEDIA_INTF_T_V4L_BASE	0x00000200
>>>> +#define MEDIA_INTF_T_ALSA_BASE	0x00000300
>>>>  
>>>>  /* Interface types */
>>>>  
>>>> @@ -267,6 +268,13 @@ struct media_links_enum {
>>>>  #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
>>>>  #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
>>>>  
>>>> +#define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
>>>> +#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
>>>> +#define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_INTF_T_ALSA_BASE + 2)
>>>> +#define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_INTF_T_ALSA_BASE + 3)
>>>> +#define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
>>>> +#define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)
>>>
>>> Patch looks ok, but please document the new media interfaces at KernelDoc
>>> documentation.
>>>
>>
>> Hi Takashi,
>>
>> If you are okay with these changes, could you please
>> Ack this patch. I am addressing documentation comment
>> from Mauro.
> 
> Well, the available ALSA devices are:
> 
> CONTROL
> SEQUENCER
> TIMER
> COMPRESS
> HWDEP
> RAWMIDI
> PCM_PLAYBACK
> PCM_CAPTURE
> 
> as found in sound/minors.h.
> 
> Any reason not to define for some of them?

Looks like SEQUENCER and TIMER are missing in
the MC defines. I can see how SEQUENCER could
be relevant as an MC node, however not sure
about TIMER use-case. That said, I don't see
any reason for not including it.

I will add Media Interface Types for both
of these missing ones.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
