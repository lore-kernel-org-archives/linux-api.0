From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v6 1/3] scsi: ufs: add ioctl interface for query request
Date: Thu, 12 Mar 2015 15:27:46 -0000
Message-ID: <061dedf8cc074e798b8eca4871a080fa.squirrel@codeaurora.org>
References: <1426163262-22014-1-git-send-email-gbroner@codeaurora.org>
    <1426163262-22014-2-git-send-email-gbroner@codeaurora.org>
    <CAC5umyiry3OEJGeZ2=U21v7gAjsC7XHZVyiZN8UgQusX2KmvpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAC5umyiry3OEJGeZ2=U21v7gAjsC7XHZVyiZN8UgQusX2KmvpQ@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gilad Broner <gbroner@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Noa Rubens <noag@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

>> +       if (!buffer) {
>> +               dev_err(hba->dev, "%s: User buffer is NULL!\n",
>> __func__);
>> +               return -EINVAL;
>> +       }
>> +
>
> Should we remove this check or move it into ufshcd_query_ioctl()?
> For example, BLKFLS ioctl without argument is correct usage, but
> it always triggers this message. (blkdev_ioctl -> __blkdev_driver_ioctl
> -> sd_ioctl -> scsi_ioctl -> ufshcd_ioctl)

You're right, I'll move the check to ufshcd_query_ioctl().

>  +++ b/include/uapi/scsi/ufs/ioctl.h
>> @@ -0,0 +1,57 @@
>> +#ifndef UAPI_UFS_IOCTL_H_
>> +#define UAPI_UFS_IOCTL_H_
>> +
>> +#include <linux/types.h>
>> +
>> +/*
>> + *  IOCTL opcode for ufs queries has the following opcode after
>> + *  SCSI_IOCTL_GET_PCI
>> + */
>> +#define UFS_IOCTL_QUERY                        0x5388
>
> Should we also need some comments near SCSI_IOCTL_GET_PCI in
> include/scsi/scsi.h in order to avoid someone trying to define
> the same ioctl code in the future?
>
Indeed - I will add a comment.

Gilad.

-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
