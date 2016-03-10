From: ygardi@codeaurora.org
Subject: Re: [PATCH v7] scsi: ufs: add ioctl interface for query request
Date: Thu, 10 Mar 2016 15:52:54 -0000
Message-ID: <5da84d4088cfc5db4e620d884e1c2920.squirrel@us.codeaurora.org>
References: <1457532699-11487-1-git-send-email-ygardi@codeaurora.org>
    <20160309162943.GC21181@kroah.com>
    <43117fbc4f3a305acd0f4975a633934a.squirrel@us.codeaurora.org>
    <20160309201808.GA24568@kroah.com>
    <551d9d1ae5418dd2dfa91aa6db69deb9.squirrel@us.codeaurora.org>
    <20160309224716.GA30523@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20160309224716.GA30523@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: ygardi@codeaurora.org, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Neuling <mikey@neuling.org>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> On Wed, Mar 09, 2016 at 08:52:59PM -0000, ygardi@codeaurora.org wrote:
>> > On Wed, Mar 09, 2016 at 07:09:49PM -0000, ygardi@codeaurora.org wrote:
>> >> > On Wed, Mar 09, 2016 at 04:11:33PM +0200, Yaniv Gardi wrote:
>> >> >> This patch exposes the ioctl interface for UFS driver via SCSI
>> device
>> >> >> ioctl interface. As of now UFS driver would provide the ioctl for
>> >> query
>> >> >> interface to connected UFS device.
>> >> >>
>> >> >> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
>> >> >> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
>> >> >> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
>> >> >> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>> >> >
>> >> > What tool is going to use this ioctl?  Why does userspcae want to
>> do
>> >> > something "special" with UFS devices?  Shouldn't they just be
>> treated
>> >> > like any other normal block device?
>> >> >
>> >>
>> >> Any userspace application can be a tool.
>> >> We already implemented and used a user space application, that sent
>> >> queries to the UFS devices in order to get information and
>> descriptors.
>> >
>> > But do you want to do with that information?  Why does userspace care?
>> >
>>
>> i don't really understand the subtext of your question -
>> as ANY ioctl cb, we decided to implement the ioctl callback of this scsi
>> device in order to get information like UNIT DESC, DEVICE DESC, FLAGs,
>> ATTRIBUTES.
>> When dealing with UFS devices, one should be able to read the
>> characteristics of the device. why ? well, why not ?
>
> Why aren't those characteristics just exported as sysfs attributes under
> control by the UFS controller driver?  Why do you need/want an ioctl for
> this?
>

Hi greg k-h,

in our code, we used the IOCTL during runtime, in order to determine some
information about the RPMB well known lun.
with the rpmb lun ID we could then go to /dev/sgX and issue
UFS_IOCTL_QUERY to this lun and get the data -
reading the QUERY_DESC_IDN_GEOMETRY descriptor and reading the
QUERY_DESC_IDN_UNIT descriptor.

this was crucial to the work we do in RPMB.

thanks,
Yaniv

>> during development of this driver, it was useful in many cases to be
>> able
>> to communicate with the device, by simple IOCTL command, rather than
>> implementing ad-hock.
>
> Do other storage busses have these types of "custom" ioctls for their
> bus-type alone?  For simple attributes like this, shouldn't you be using
> sysfs instead so that it is much easier for userspace tools to get
> access to them?
>
> thanks,
>
> greg k-h
>


