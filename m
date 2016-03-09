From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v7] scsi: ufs: add ioctl interface for query request
Date: Wed, 9 Mar 2016 14:47:16 -0800
Message-ID: <20160309224716.GA30523@kroah.com>
References: <1457532699-11487-1-git-send-email-ygardi@codeaurora.org>
 <20160309162943.GC21181@kroah.com>
 <43117fbc4f3a305acd0f4975a633934a.squirrel@us.codeaurora.org>
 <20160309201808.GA24568@kroah.com>
 <551d9d1ae5418dd2dfa91aa6db69deb9.squirrel@us.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <551d9d1ae5418dd2dfa91aa6db69deb9.squirrel-tfvNlV/SBG3LzYW4gMljz9i2O/JbrIOy@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jbottomley-wo1vFcy6AUs@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>, "Matthew R. Ochs" <mrochs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Wen Xiong <wenxiong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 09, 2016 at 08:52:59PM -0000, ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org wrote:
> > On Wed, Mar 09, 2016 at 07:09:49PM -0000, ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org wrote:
> >> > On Wed, Mar 09, 2016 at 04:11:33PM +0200, Yaniv Gardi wrote:
> >> >> This patch exposes the ioctl interface for UFS driver via SCSI device
> >> >> ioctl interface. As of now UFS driver would provide the ioctl for
> >> query
> >> >> interface to connected UFS device.
> >> >>
> >> >> Reviewed-by: Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> >> >> Signed-off-by: Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> >> >> Signed-off-by: Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> >> >> Signed-off-by: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> >> >
> >> > What tool is going to use this ioctl?  Why does userspcae want to do
> >> > something "special" with UFS devices?  Shouldn't they just be treated
> >> > like any other normal block device?
> >> >
> >>
> >> Any userspace application can be a tool.
> >> We already implemented and used a user space application, that sent
> >> queries to the UFS devices in order to get information and descriptors.
> >
> > But do you want to do with that information?  Why does userspace care?
> >
> 
> i don't really understand the subtext of your question -
> as ANY ioctl cb, we decided to implement the ioctl callback of this scsi
> device in order to get information like UNIT DESC, DEVICE DESC, FLAGs,
> ATTRIBUTES.
> When dealing with UFS devices, one should be able to read the
> characteristics of the device. why ? well, why not ?

Why aren't those characteristics just exported as sysfs attributes under
control by the UFS controller driver?  Why do you need/want an ioctl for
this?

> during development of this driver, it was useful in many cases to be able
> to communicate with the device, by simple IOCTL command, rather than
> implementing ad-hock.

Do other storage busses have these types of "custom" ioctls for their
bus-type alone?  For simple attributes like this, shouldn't you be using
sysfs instead so that it is much easier for userspace tools to get
access to them?

thanks,

greg k-h
