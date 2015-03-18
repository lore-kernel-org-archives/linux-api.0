From: "Dov Levenglick" <dovl@codeaurora.org>
Subject: Re: [PATCH v7 1/3] scsi: ufs: add ioctl interface for query request
Date: Wed, 18 Mar 2015 13:17:49 -0000
Message-ID: <d69712a63e353d1c085e0a05e78d965b.squirrel@www.codeaurora.org>
References: <1426175700-23152-1-git-send-email-gbroner@codeaurora.org>
    <1426175700-23152-2-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426175700-23152-2-git-send-email-gbroner@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Noa Rubens <noag@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> From: Dolev Raviv <draviv@codeaurora.org>
>
> This patch exposes the ioctl interface for UFS driver via SCSI device
> ioctl interface. As of now UFS driver would provide the ioctl for query
> interface to connected UFS device.
>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Noa Rubens <noag@codeaurora.org>
> Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs.h        |  53 ++--------
>  drivers/scsi/ufs/ufshcd.c     | 226
> +++++++++++++++++++++++++++++++++++++++++-
>  include/scsi/scsi.h           |   1 +
>  include/uapi/scsi/Kbuild      |   1 +
>  include/uapi/scsi/ufs/Kbuild  |   3 +
>  include/uapi/scsi/ufs/ioctl.h |  57 +++++++++++
>  include/uapi/scsi/ufs/ufs.h   |  66 ++++++++++++
>  7 files changed, 363 insertions(+), 44 deletions(-)
>  create mode 100644 include/uapi/scsi/ufs/Kbuild
>  create mode 100644 include/uapi/scsi/ufs/ioctl.h
>  create mode 100644 include/uapi/scsi/ufs/ufs.h
>

[ removed ~530 lines of code]
Reviewed-by: Dov Levenglick <dovl@codeaurora.org>

> --
> Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
