From: "Dov Levenglick" <dovl-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v8 1/3] scsi: ufs: add ioctl interface for query request
Date: Tue, 28 Apr 2015 14:09:32 -0000
Message-ID: <615cb9e85f9e0389f33a4c31c9d3f76c.squirrel@www.codeaurora.org>
References: <1429012281-24068-1-git-send-email-gbroner@codeaurora.org>
    <1429012281-24068-2-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429012281-24068-2-git-send-email-gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Noa Rubens <noag-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Raviv Shvili <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jbottomley-wo1vFcy6AUs@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Reviewed-by: Dov Levenglick <dovl-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

> From: Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>
> This patch exposes the ioctl interface for UFS driver via SCSI device
> ioctl interface. As of now UFS driver would provide the ioctl for query
> interface to connected UFS device.
>
> Signed-off-by: Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Noa Rubens <noag-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Raviv Shvili <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  drivers/scsi/ufs/ufs.h        |  53 +++-------
>  drivers/scsi/ufs/ufshcd.c     | 219
> +++++++++++++++++++++++++++++++++++++++++-
>  include/scsi/scsi.h           |   1 +
>  include/uapi/scsi/Kbuild      |   1 +
>  include/uapi/scsi/ufs/Kbuild  |   3 +
>  include/uapi/scsi/ufs/ioctl.h |  57 +++++++++++
>  include/uapi/scsi/ufs/ufs.h   |  66 +++++++++++++
>  7 files changed, 356 insertions(+), 44 deletions(-)
>  create mode 100644 include/uapi/scsi/ufs/Kbuild
>  create mode 100644 include/uapi/scsi/ufs/ioctl.h
>  create mode 100644 include/uapi/scsi/ufs/ufs.h
>

<snip many lines of code>

> +	UPIU_QUERY_OPCODE_CLEAR_FLAG	= 0x7,
> +	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
> +};
> +#endif /* UAPI_UFS_H_ */
> --
> Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
