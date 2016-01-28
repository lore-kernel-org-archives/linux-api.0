From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 01/31] uapi/media.h: Declare interface types for ALSA
Date: Thu, 28 Jan 2016 12:59:41 -0200
Message-ID: <20160128125941.143f67d0@recife.lan>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<b1d228cdcc9246f7bfe28877e9f6bff174e94993.1452105878.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b1d228cdcc9246f7bfe28877e9f6bff174e94993.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed,  6 Jan 2016 13:26:50 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Declare the interface types to be used on alsa for the new
> G_TOPOLOGY ioctl.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/media-entity.c | 12 ++++++++++++
>  include/uapi/linux/media.h   |  8 ++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index eb38bc3..6e02d19 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -65,6 +65,18 @@ static inline const char *intf_type(struct media_interface *intf)
>  		return "v4l2-subdev";
>  	case MEDIA_INTF_T_V4L_SWRADIO:
>  		return "swradio";
> +	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
> +		return "pcm-capture";
> +	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
> +		return "pcm-playback";
> +	case MEDIA_INTF_T_ALSA_CONTROL:
> +		return "alsa-control";
> +	case MEDIA_INTF_T_ALSA_COMPRESS:
> +		return "compress";
> +	case MEDIA_INTF_T_ALSA_RAWMIDI:
> +		return "rawmidi";
> +	case MEDIA_INTF_T_ALSA_HWDEP:
> +		return "hwdep";
>  	default:
>  		return "unknown-intf";
>  	}
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index cacfceb..75cbe92 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -252,6 +252,7 @@ struct media_links_enum {
>  
>  #define MEDIA_INTF_T_DVB_BASE	0x00000100
>  #define MEDIA_INTF_T_V4L_BASE	0x00000200
> +#define MEDIA_INTF_T_ALSA_BASE	0x00000300
>  
>  /* Interface types */
>  
> @@ -267,6 +268,13 @@ struct media_links_enum {
>  #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
>  #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
>  
> +#define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
> +#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
> +#define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_INTF_T_ALSA_BASE + 2)
> +#define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_INTF_T_ALSA_BASE + 3)
> +#define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
> +#define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)

Patch looks ok, but please document the new media interfaces at KernelDoc
documentation.

> +
>  /*
>   * MC next gen API definitions
>   *
