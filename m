From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v7] scsi: ufs: add ioctl interface for query request
Date: Thu, 10 Mar 2016 20:43:55 -0500
Message-ID: <yq1io0tn604.fsf@sermon.lab.mkp.net>
References: <1457532699-11487-1-git-send-email-ygardi@codeaurora.org>
	<046fc2d00e51f331a6bbc00553cc1f9c.squirrel@us.codeaurora.org>
	<201603101818.33826.arnd@arndb.de> <201603102019.32467.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <201603102019.32467.arnd@arndb.de> (Arnd Bergmann's message of
	"Thu, 10 Mar 2016 20:19:32 +0100")
Sender: linux-arm-msm-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: ygardi@codeaurora.org, Greg KH <gregkh@linuxfoundation.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Michael Neuling <mikey@neuling.org>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> Looking through what other drivers do, I've found a couple of
Arnd> patterns now. n particular, most use the SG_IO ioctl to pass down
Arnd> commands from user space into a device specific command
Arnd> queue. Have you looked at that interface in the past to see if it
Arnd> would fit your use case?

Arnd> There is also a 'bsg' API that some drivers implement, which I
Arnd> think would be another alternative.

Arnd> Could any of the SCSI experts comment on what they expect a driver
Arnd> to use out of those three alternatives (if any):

My preference is that if you want to expose any information that a user
or admin would care about, put it in sysfs where it is easily accessible
and can be scripted.

For things that need to directly send commands to the hardware (to
configure vendor specific settings or inspect parameters for development
purposes) use the sg or bsg interfaces like we do for both ATA and
SCSI. bsg is newer and supports more features like bidirectional
commands. But for this particular use case I don't think it offers any
particular advantages over SG_IO. Both interfaces take the same
descriptors so it really doesn't matter much.

See:

	http://sg.danny.cz/sg/

-- 
Martin K. Petersen	Oracle Linux Engineering
