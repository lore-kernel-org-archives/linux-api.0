From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: selective block polling and preadv2/pwritev2 revisited
Date: Thu, 7 Jan 2016 16:41:13 +0200
Message-ID: <568E7909.5030203@dev.mellanox.co.il>
References: <1450966464-6847-1-git-send-email-hch@lst.de>
 <568A889E.4020204@dev.mellanox.co.il> <20160104163949.GA17409@lst.de>
 <568D4859.4010206@dev.mellanox.co.il> <yq1h9iqiary.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1h9iqiary.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Martin,

> Sagi> This means that the user would need to pass iovec entries of 8
> Sagi> bytes correct? Seems like a waste for large IOs (sorry for
> Sagi> diverging from the subject)
>
> The assumption was that there would be a 1:1 mapping between the number
> of data buffers and the metadata ditto. But nothing says that a data
> iovec entry is limited in size to a single sector.

Yea... I meant 1:1, I got confused on the 8 bytes comment...

> The other option to have a single iovec at the end representing the
> metadata for all data buffers. I think there are valid use cases for
> either approach and we may end up having to support both via a flag.

Either approach presents limitation, but I guess user-space can deal
with it...
