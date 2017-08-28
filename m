From: Eugene Syromiatnikov <esyr@redhat.com>
Subject: Re: [3/7,media] dvb: don't use 'time_t' in event ioctl
Date: Mon, 28 Aug 2017 17:32:43 +0200
Message-ID: <20170828153243.GA27121@asgard.redhat.com>
References: <1442332148-488079-4-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442332148-488079-4-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org, ldv@altlinux.org, glebfm@altlinux.org
List-Id: linux-api@vger.kernel.org

On Tue, Sep 15, 2015 at 05:49:04PM +0200, Arnd Bergmann wrote:
> 'struct video_event' is used for the VIDEO_GET_EVENT ioctl, implemented
> by drivers/media/pci/ivtv/ivtv-ioctl.c and
> drivers/media/pci/ttpci/av7110_av.c. The structure contains a 'time_t',
> which will be redefined in the future to be 64-bit wide, causing an
> incompatible ABI change for this ioctl.
> 
> As it turns out, neither of the drivers currently sets the timestamp
> field, and it is presumably useless anyway because of the limited
> resolutions (no sub-second times). This means we can simply change
> the structure definition to use a 'long' instead of 'time_t' and
> remain compatible with all existing user space binaries when time_t
> gets changed.
> 
> If anybody ever starts using this field, they have to make sure not
> to use 1970 based seconds in there, as those overflow in 2038.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/uapi/linux/dvb/video.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/dvb/video.h b/include/uapi/linux/dvb/video.h
> index d3d14a59d2d5..6c7f9298d7c2 100644
> --- a/include/uapi/linux/dvb/video.h
> +++ b/include/uapi/linux/dvb/video.h
> @@ -135,7 +135,8 @@ struct video_event {
>  #define VIDEO_EVENT_FRAME_RATE_CHANGED	2
>  #define VIDEO_EVENT_DECODER_STOPPED 	3
>  #define VIDEO_EVENT_VSYNC 		4
> -	__kernel_time_t timestamp;
> +	/* unused, make sure to use atomic time for y2038 if it ever gets used */
> +	long timestamp;

This change breaks x32 ABI (and possibly MIPS n32 ABI), as __kernel_time_t
there is 64 bit already:
https://sourceforge.net/p/strace/mailman/message/36015326/

Note the change in structure size from 0x20 to 0x14 for VIDEO_GET_EVENT
command in linux/x32/ioctls_inc0.h.

>  	union {
>  		video_size_t size;
>  		unsigned int frame_rate;	/* in frames per 1000sec */
