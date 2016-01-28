From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 22/31] media: dvb-core create tuner to demod pad link in
 disabled state
Date: Thu, 28 Jan 2016 14:38:31 -0200
Message-ID: <20160128143831.351a2e6c@recife.lan>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<753bb19d9d474ab419ad7ee37f7d30a1db6a8e35.1452105878.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <753bb19d9d474ab419ad7ee37f7d30a1db6a8e35.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed,  6 Jan 2016 13:27:11 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Create tuner to demod pad link in disabled state to help avoid
> disable step when tuner resource is requested by video or audio.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/dvb-core/dvbdev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index b56e008..1d10fa6 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -593,8 +593,9 @@ int dvb_create_media_graph(struct dvb_adapter *adap)
>  	}
>  
>  	if (tuner && demod) {
> +		/* create tuner to demod link deactivated */
>  		ret = media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT,
> -					    demod, 0, MEDIA_LNK_FL_ENABLED);
> +					    demod, 0, 0);

This is not right, as it makes no sense for DVB-only drivers.

>  		if (ret)
>  			return ret;
>  	}
