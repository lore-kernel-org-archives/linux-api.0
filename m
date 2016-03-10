From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v7] scsi: ufs: add ioctl interface for query request
Date: Thu, 10 Mar 2016 18:18:33 +0100
Message-ID: <201603101818.33826.arnd@arndb.de>
References: <1457532699-11487-1-git-send-email-ygardi@codeaurora.org> <20160309162943.GC21181@kroah.com> <046fc2d00e51f331a6bbc00553cc1f9c.squirrel@us.codeaurora.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <046fc2d00e51f331a6bbc00553cc1f9c.squirrel@us.codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: ygardi@codeaurora.org
Cc: Greg KH <gregkh@linuxfoundation.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Neuling <mikey@neuling.org>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 09 March 2016, ygardi@codeaurora.org wrote:
> Any userspace application can be a tool.
> We already implemented and used a user space application, that sent
> queries to the UFS devices in order to get information and descriptors.
> Not only ioctl interface is a useful way to interact with the device,
> we used it, and found it very helpful in varies cases.
> hence, this patch.
> This patch has been already addressed all comments of Arnd Bergman from 5
> months ago, and now, re-uploaded again.

Do you have a pointer to that review? It's been a long while, so I
have completely forgotten what issues I raised and how it got resolved.

	Arnd
