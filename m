From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/14] block: Add specific data integrity errors
Date: Wed, 11 Jun 2014 22:16:01 -0400
Message-ID: <yq14mzqrhy6.fsf@sermon.lab.mkp.net>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
	<1401334128-15499-13-git-send-email-martin.petersen@oracle.com>
	<20140611165455.GG9511@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140611165455.GG9511-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> (Christoph Hellwig's
	message of "Wed, 11 Jun 2014 09:54:55 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:

>> Introduce a set of error codes that can be used by the block
>> integrity subsystem to signal which class of error was encountered by
>> either the I/O controller or the storage device.

Christoph> I'd also love to see something catching these so that they
Christoph> don't leak to userspace.

This patch was really meant as an RFC. But it is absolutely my intent to
expose these to userspace. Albeit only to applications that supply or
request protection information via Darrick's aio extensions.

I also use these errors extensively in my test utilities to verify that
the correct problem gets detected by the correct entity when I inject an
error.

I should add that in the past I had a separate error status inside the
bip that contained the data integrity specific errors. But that involved
all sorts of evil hacks when bios were cloned, split and stacked. After
talking to nab about his needs for target I figured it was better to
just define new error codes and handle them like Hannes did for the
extended SCSI errors.

-- 
Martin K. Petersen	Oracle Linux Engineering
