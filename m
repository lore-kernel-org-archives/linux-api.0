From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v7] scsi: ufs: add ioctl interface for query request
Date: Wed, 9 Mar 2016 12:18:08 -0800
Message-ID: <20160309201808.GA24568@kroah.com>
References: <1457532699-11487-1-git-send-email-ygardi@codeaurora.org>
 <20160309162943.GC21181@kroah.com>
 <43117fbc4f3a305acd0f4975a633934a.squirrel@us.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43117fbc4f3a305acd0f4975a633934a.squirrel@us.codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: ygardi@codeaurora.org
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Neuling <mikey@neuling.org>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 09, 2016 at 07:09:49PM -0000, ygardi@codeaurora.org wrote:
> > On Wed, Mar 09, 2016 at 04:11:33PM +0200, Yaniv Gardi wrote:
> >> This patch exposes the ioctl interface for UFS driver via SCSI device
> >> ioctl interface. As of now UFS driver would provide the ioctl for query
> >> interface to connected UFS device.
> >>
> >> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> >> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> >> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> >> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> >
> > What tool is going to use this ioctl?  Why does userspcae want to do
> > something "special" with UFS devices?  Shouldn't they just be treated
> > like any other normal block device?
> >
> 
> Any userspace application can be a tool.
> We already implemented and used a user space application, that sent
> queries to the UFS devices in order to get information and descriptors.

But do you want to do with that information?  Why does userspace care?

> Not only ioctl interface is a useful way to interact with the device,
> we used it, and found it very helpful in varies cases.

In what case was it helpful?  Why does userspace care about ufs
specifics, it should just treat it like any other block device and not
care at all.

thanks,

greg k-h
