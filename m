From: ygardi@codeaurora.org
Subject: Re: [PATCH v7] scsi: ufs: add ioctl interface for query request
Date: Wed, 9 Mar 2016 19:09:49 -0000
Message-ID: <43117fbc4f3a305acd0f4975a633934a.squirrel@us.codeaurora.org>
References: <1457532699-11487-1-git-send-email-ygardi@codeaurora.org>
    <20160309162943.GC21181@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160309162943.GC21181@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Neuling <mikey@neuling.org>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> On Wed, Mar 09, 2016 at 04:11:33PM +0200, Yaniv Gardi wrote:
>> This patch exposes the ioctl interface for UFS driver via SCSI device
>> ioctl interface. As of now UFS driver would provide the ioctl for query
>> interface to connected UFS device.
>>
>> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
>> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
>> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> What tool is going to use this ioctl?  Why does userspcae want to do
> something "special" with UFS devices?  Shouldn't they just be treated
> like any other normal block device?
>

Any userspace application can be a tool.
We already implemented and used a user space application, that sent
queries to the UFS devices in order to get information and descriptors.
Not only ioctl interface is a useful way to interact with the device,
we used it, and found it very helpful in varies cases.
hence, this patch.
This patch has been already addressed all comments of Arnd Bergman from 5
months ago, and now, re-uploaded again.

thanks,
Yaniv

> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
