From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v2 02/22] media: Add ALSA Media Controller function
 entities
Date: Thu, 4 Feb 2016 06:40:00 -0200
Message-ID: <20160204064000.3bdd9418@recife.lan>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
	<7e6aa938056da01e75f1e9d844f621baf47ffa74.1454557589.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <7e6aa938056da01e75f1e9d844f621baf47ffa74.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed, 03 Feb 2016 21:03:34 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Add ALSA Media Controller capture, playback, and mixer
> function entity defines.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  include/uapi/linux/media.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index ee020e8..7d50480 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -98,6 +98,17 @@ struct media_device_info {
>  #define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 42)
>  
>  /*
> + * DOC: Media Controller Next Generation ALSA Function Entities
> + *
> + * MEDIA_ENT_F_AUDIO_CAPTURE - Audio Capture Function
> + * MEDIA_ENT_F_AUDIO_PLAYBACK - Audio Play Back Function
> + * MEDIA_ENT_F_AUDIO_MIXER - Audio Mixer Function
> +*/

Wrong way to document it. Please see my comments to patch 01/22.

> +#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 200)
> +#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 201)
> +#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 202)
> +
> +/*
>   * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and
>   * MEDIA_ENT_F_OLD_SUBDEV_BASE are kept to keep backward compatibility
>   * with the legacy v1 API.The number range is out of range by purpose:
