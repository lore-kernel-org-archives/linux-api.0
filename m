From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v7] scsi: ufs: add ioctl interface for query request
Date: Sun, 13 Mar 2016 12:45:14 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B5419B0B4@hasmsx108.ger.corp.intel.com>
References: <1457532699-11487-1-git-send-email-ygardi@codeaurora.org>
 <046fc2d00e51f331a6bbc00553cc1f9c.squirrel@us.codeaurora.org>
 <201603101818.33826.arnd@arndb.de> <201603102019.32467.arnd@arndb.de>
 <yq1io0tn604.fsf@sermon.lab.mkp.net> <56E285AC.1030803@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <56E285AC.1030803@suse.de>
Content-Language: en-US
Sender: linux-arm-msm-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Arnd Bergmann <arnd@arndb.de>
Cc: "ygardi@codeaurora.org" <ygardi@codeaurora.org>, Greg KH <gregkh@linuxfoundation.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "santoshsy@gmail.com" <santoshsy@gmail.com>, "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Michael Neuling <mikey@neuling.org>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> 
> On 03/11/2016 02:43 AM, Martin K. Petersen wrote:
> >>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:
> >
> > Arnd> Looking through what other drivers do, I've found a couple of
> > Arnd> patterns now. n particular, most use the SG_IO ioctl to pass down
> > Arnd> commands from user space into a device specific command
> > Arnd> queue. Have you looked at that interface in the past to see if it
> > Arnd> would fit your use case?
> >
> > Arnd> There is also a 'bsg' API that some drivers implement, which I
> > Arnd> think would be another alternative.
> >
> > Arnd> Could any of the SCSI experts comment on what they expect a driver
> > Arnd> to use out of those three alternatives (if any):
> >
> > My preference is that if you want to expose any information that a user
> > or admin would care about, put it in sysfs where it is easily accessible
> > and can be scripted.
> >
> > For things that need to directly send commands to the hardware (to
> > configure vendor specific settings or inspect parameters for development
> > purposes) use the sg or bsg interfaces like we do for both ATA and
> > SCSI. bsg is newer and supports more features like bidirectional
> > commands. But for this particular use case I don't think it offers any
> > particular advantages over SG_IO. Both interfaces take the same
> > descriptors so it really doesn't matter much.
> >
> > See:
> >
> > 	http://sg.danny.cz/sg/
> >
> And indeed I would expose this 'special' UFS RPMB as a 'generic'
> SCSI device and add the required fields in sysfs, much like Greg KH
> suggested.
> Plus adding a 'bsg' interface for sending 'raw' UFS commands sounds
> much more appealing; that's what we do for SAS and FC, too.
> 
> But then, none of the above can be done if there is no hardware
> available. At the same time, you wouldn't be able to test any
> proposed fixes to the original ioctl patch.
> So I guess you'll have to retract this patch or get hold of the
> hardware to actually _test_ something there.
> 
> Or send me some, I'll be happy to help out here :-)
> 

I will submit proposal or new RPMB layer for both UFS and EMMC 
It also sports IOCTL interface, similar and replacing to mmc_ioc_cmd which is also used to access RPMB partition on emmc.
Blocks  of 512 bytes has to be transferred back and force so sysfs API is not good enough.  RPMB partition is not suitable to be accessed via block layer.  I've tried going via SICSI generic layers, it is a bit awkward as the protocol is very UFS specific.  
Currently I have working solution for both EMMC and UFS2.0.

Thanks
Tomas 
