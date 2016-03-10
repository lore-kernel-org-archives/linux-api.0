From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v7] scsi: ufs: add ioctl interface for query request
Date: Thu, 10 Mar 2016 08:39:10 -0800
Message-ID: <20160310163910.GA30247@kroah.com>
References: <1457532699-11487-1-git-send-email-ygardi@codeaurora.org>
 <20160309162943.GC21181@kroah.com>
 <43117fbc4f3a305acd0f4975a633934a.squirrel@us.codeaurora.org>
 <20160309201808.GA24568@kroah.com>
 <551d9d1ae5418dd2dfa91aa6db69deb9.squirrel@us.codeaurora.org>
 <20160309224716.GA30523@kroah.com>
 <5da84d4088cfc5db4e620d884e1c2920.squirrel@us.codeaurora.org>
 <20160310162429.GA29242@kroah.com>
 <3164792fec2d8f37f48f6224a145fc1e.squirrel@us.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3164792fec2d8f37f48f6224a145fc1e.squirrel@us.codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ygardi@codeaurora.org
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Neuling <mikey@neuling.org>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 10, 2016 at 04:29:55PM -0000, ygardi@codeaurora.org wrote:
> > On Thu, Mar 10, 2016 at 03:52:54PM -0000, ygardi@codeaurora.org wrote:
> >> > On Wed, Mar 09, 2016 at 08:52:59PM -0000, ygardi@codeaurora.org wrote:
> >> >> > On Wed, Mar 09, 2016 at 07:09:49PM -0000, ygardi@codeaurora.org
> >> wrote:
> >> >> >> > On Wed, Mar 09, 2016 at 04:11:33PM +0200, Yaniv Gardi wrote:
> >> >> >> >> This patch exposes the ioctl interface for UFS driver via SCSI
> >> >> device
> >> >> >> >> ioctl interface. As of now UFS driver would provide the ioctl
> >> for
> >> >> >> query
> >> >> >> >> interface to connected UFS device.
> >> >> >> >>
> >> >> >> >> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> >> >> >> >> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> >> >> >> >> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> >> >> >> >> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> >> >> >> >
> >> >> >> > What tool is going to use this ioctl?  Why does userspcae want
> >> to
> >> >> do
> >> >> >> > something "special" with UFS devices?  Shouldn't they just be
> >> >> treated
> >> >> >> > like any other normal block device?
> >> >> >> >
> >> >> >>
> >> >> >> Any userspace application can be a tool.
> >> >> >> We already implemented and used a user space application, that
> >> sent
> >> >> >> queries to the UFS devices in order to get information and
> >> >> descriptors.
> >> >> >
> >> >> > But do you want to do with that information?  Why does userspace
> >> care?
> >> >> >
> >> >>
> >> >> i don't really understand the subtext of your question -
> >> >> as ANY ioctl cb, we decided to implement the ioctl callback of this
> >> scsi
> >> >> device in order to get information like UNIT DESC, DEVICE DESC,
> >> FLAGs,
> >> >> ATTRIBUTES.
> >> >> When dealing with UFS devices, one should be able to read the
> >> >> characteristics of the device. why ? well, why not ?
> >> >
> >> > Why aren't those characteristics just exported as sysfs attributes
> >> under
> >> > control by the UFS controller driver?  Why do you need/want an ioctl
> >> for
> >> > this?
> >> >
> >>
> >> Hi greg k-h,
> >>
> >> in our code, we used the IOCTL during runtime, in order to determine
> >> some
> >> information about the RPMB well known lun.
> >> with the rpmb lun ID we could then go to /dev/sgX and issue
> >> UFS_IOCTL_QUERY to this lun and get the data -
> >> reading the QUERY_DESC_IDN_GEOMETRY descriptor and reading the
> >> QUERY_DESC_IDN_UNIT descriptor.
> >>
> >> this was crucial to the work we do in RPMB.
> >
> > What is RPMB?
> >
> > And again, why not just use sysfs attributes on your host controller
> > device?  Why does this have to be a custom ioctl?
> >
> > greg k-h
> >
> 
> RPMB is spcial Logical Unit in the UFS device. you can read about it in
> the UFS spec. Greg, you are insisting on sysfs, but i can't implement it
> now, as i don't have the Hardware anymore, or the time.

If you don't have the hardware, how are you testing this patch?

And if you don't have the hardware I guess you don't need this change :)

> This is a tested and verified code that was accepted and reviewed already,
> so i'm not sure what is wrong with this solution, not to say, it's already
> implemented, tested and verified.
> hope you are help us push it.

That's a horrible reason to merge a patch that someone else is going to
have to support for 20+ years with an api that doesn't make much sense.

If you don't have the hardware, then this isn't needed.  But if you do,
then please look into using sysfs for this, as I think that should be
the correct interface here, again, not some random ioctl.

greg k-h
