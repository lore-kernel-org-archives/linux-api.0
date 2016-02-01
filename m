From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 01/31] uapi/media.h: Declare interface types for ALSA
Date: Mon, 1 Feb 2016 09:07:51 -0700
Message-ID: <56AF82D7.1020900@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <b1d228cdcc9246f7bfe28877e9f6bff174e94993.1452105878.git.shuahkh@osg.samsung.com>
 <20160128125941.143f67d0@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160128125941.143f67d0-+RedX5hVuTR+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, tiwai-IBi9RG/b67k@public.gmane.org
Cc: clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs-mcfjX3dozePR7s880joybQ@public.gmane.org, johan@ol
List-Id: linux-api@vger.kernel.org

On 01/28/2016 07:59 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  6 Jan 2016 13:26:50 -0700
> Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:
> 
>> From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>>
>> Declare the interface types to be used on alsa for the new
>> G_TOPOLOGY ioctl.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> ---
>>  drivers/media/media-entity.c | 12 ++++++++++++
>>  include/uapi/linux/media.h   |  8 ++++++++
>>  2 files changed, 20 insertions(+)
>>
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index eb38bc3..6e02d19 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -65,6 +65,18 @@ static inline const char *intf_type(struct media_interface *intf)
>>  		return "v4l2-subdev";
>>  	case MEDIA_INTF_T_V4L_SWRADIO:
>>  		return "swradio";
>> +	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
>> +		return "pcm-capture";
>> +	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
>> +		return "pcm-playback";
>> +	case MEDIA_INTF_T_ALSA_CONTROL:
>> +		return "alsa-control";
>> +	case MEDIA_INTF_T_ALSA_COMPRESS:
>> +		return "compress";
>> +	case MEDIA_INTF_T_ALSA_RAWMIDI:
>> +		return "rawmidi";
>> +	case MEDIA_INTF_T_ALSA_HWDEP:
>> +		return "hwdep";
>>  	default:
>>  		return "unknown-intf";
>>  	}
>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>> index cacfceb..75cbe92 100644
>> --- a/include/uapi/linux/media.h
>> +++ b/include/uapi/linux/media.h
>> @@ -252,6 +252,7 @@ struct media_links_enum {
>>  
>>  #define MEDIA_INTF_T_DVB_BASE	0x00000100
>>  #define MEDIA_INTF_T_V4L_BASE	0x00000200
>> +#define MEDIA_INTF_T_ALSA_BASE	0x00000300
>>  
>>  /* Interface types */
>>  
>> @@ -267,6 +268,13 @@ struct media_links_enum {
>>  #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
>>  #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
>>  
>> +#define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
>> +#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
>> +#define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_INTF_T_ALSA_BASE + 2)
>> +#define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_INTF_T_ALSA_BASE + 3)
>> +#define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
>> +#define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)
> 
> Patch looks ok, but please document the new media interfaces at KernelDoc
> documentation.
> 

Hi Takashi,

If you are okay with these changes, could you please
Ack this patch. I am addressing documentation comment
from Mauro.

thanks,
-- Shuah
>> +
>>  /*
>>   * MC next gen API definitions
>>   *


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
