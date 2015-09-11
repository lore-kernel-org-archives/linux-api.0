From: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH v8 44/55] [media] uapi/media.h: Add MEDIA_IOC_G_TOPOLOGY
 ioctl
Date: Fri, 11 Sep 2015 15:58:48 +0200
Message-ID: <55F2DE18.3020201@xs4all.nl>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <297afcfe4c9c5ebc074f92d1badd34b94e8b28f9.1441540862.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <297afcfe4c9c5ebc074f92d1badd34b94e8b28f9.1441540862.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/06/2015 02:03 PM, Mauro Carvalho Chehab wrote:
> Add a new ioctl that will report the entire topology on
> one go.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

Acked-by: Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

I do have one suggestion: media_v2_interface, media_v2_pad and media_v2_link all
have a 'flags' field, but it is not clear from the code in the header which flag
#defines are used for which struct. Perhaps a few comments would help with that.

> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index a1bd7afba110..b17f6763aff4 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h

<snip>

> +
> +struct media_v2_pad {
> +	__u32 id;
> +	__u32 entity_id;
> +	__u32 flags;
> +	__u16 reserved[9];

Strange odd number here for no clear reason. Perhaps use 8 or 10 instead?

Anyway, you have my Ack.

Regards,

	Hans
