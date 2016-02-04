From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v2 01/22] uapi/media.h: Declare interface types for ALSA
Date: Thu, 4 Feb 2016 06:38:54 -0200
Message-ID: <20160204063854.308fcbb7@recife.lan>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
	<6d8fe067fa0ec07e9f667dbd2e163b6b63b4a614.1454557589.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6d8fe067fa0ec07e9f667dbd2e163b6b63b4a614.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed, 03 Feb 2016 21:03:33 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Declare the interface types to be used on alsa for
> the new G_TOPOLOGY ioctl.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/media-entity.c | 16 ++++++++++++++++
>  include/uapi/linux/media.h   | 22 ++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index f2e4360..6179543 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -65,6 +65,22 @@ static inline const char *intf_type(struct media_interface *intf)
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
> +	case MEDIA_INTF_T_ALSA_SEQUENCER:
> +		return "sequencer";
> +	case MEDIA_INTF_T_ALSA_TIMER:
> +		return "timer";
>  	default:
>  		return "unknown-intf";
>  	}
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index c9eb42a..ee020e8 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -265,6 +265,7 @@ struct media_links_enum {
>  
>  #define MEDIA_INTF_T_DVB_BASE	0x00000100
>  #define MEDIA_INTF_T_V4L_BASE	0x00000200
> +#define MEDIA_INTF_T_ALSA_BASE	0x00000300
>  
>  /* Interface types */
>  
> @@ -280,6 +281,27 @@ struct media_links_enum {
>  #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
>  #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
>  
> +/**
> + * DOC: Media Controller Next Generation ALSA Interface Types
> + *
> + * MEDIA_INTF_T_ALSA_PCM_CAPTURE - PCM Capture Interface (pcm-capture)
> + * MEDIA_INTF_T_ALSA_PCM_PLAYBACK -  PCM Playback Interface (pcm-playback)
> + * MEDIA_INTF_T_ALSA_CONTROL -  ALSA Control Interface (alsa-control)
> + * MEDIA_INTF_T_ALSA_COMPRESS - ALSA Compression Interface (compress)
> + * MEDIA_INTF_T_ALSA_RAWMIDI - ALSA Raw MIDI Interface (rawmidi)
> + * MEDIA_INTF_T_ALSA_HWDEP - ALSA Hardware Dependent Interface (hwdep)
> + * MEDIA_INTF_T_ALSA_SEQUENCER - ALSA Sequencer (sequencer)
> + * MEDIA_INTF_T_ALSA_TIMER - ALSA Timer (timer)
> + */

We don't document the userspace API using kernel-doc, as it is too
poor for that. Also, we migrated the uAPI documentation from LaTex
(at DVB side) and from a separate DocBook document. Migrating those to
kernel-doc would need some rich documentation markup language, and
someone with lots of spare time.

Instead, we document them at a separate DocBook volume:
	Documentation/DocBook/media_api.tmpl

The actual DocBook documents are at:
	Documentation/DocBook/media/dvb - for the DVB side
	Documentation/DocBook/media/v4l - for V4L2, RC and Media Controller

In the specific case of the Media Controller, the description of those
defines are at:
	Documentation/DocBook/media/v4l/media-types.xml

Just edit it with some text editor and add the new fields there at the
right places.

Please test if the documentation is producing the right data, by using
the enclosed small script. The extra xmllint lines validate the syntax,
helping to identify hidden missing tags. The last line will produce a
single html file, instead of one html file per page (with is the default
for make htmldocs).

Regards,
Mauro

#!/bin/bash
LC_ALL=en_US.UTF-8
make cleanmediadocs
make DOCBOOKS=media_api.xml htmldocs 2>&1 | grep -v "element.*: validity error : ID .* already defined"
xmllint --noent --postvalid "$PWD/Documentation/DocBook/media_api.xml" >/tmp/x.xml 2>/dev/null
xmllint --noent --postvalid --noout /tmp/x.xml
xmlto html-nochunks -m ./Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/media Documentation/DocBook/media_api.xml >/dev/null 2>&1
