From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/10] fs: add RWF_DSYNC aand RWF_SYNC
Date: Sun, 4 Sep 2016 16:56:34 +1200
Message-ID: <5570e290-1865-c4f1-cb4e-ed7c9f6217d4@gmail.com>
References: <1460044324-5298-1-git-send-email-hch@lst.de>
 <1460044324-5298-10-git-send-email-hch@lst.de>
 <CAKgNAkjza2eZnS7bzmvg1nB_jLmtk1N-o=uusD_hBo20sHTyaA@mail.gmail.com>
 <20160809081557.GA10564@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160809081557.GA10564-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Christoph,

Sorry -- somehow I missed that you replied to my message...

On 08/09/2016 08:15 PM, Christoph Hellwig wrote:
> Hi Michael,
> 
> On Sun, Aug 07, 2016 at 07:45:03AM +1000, Michael Kerrisk (man-pages) wrote:
>> I've added some documentation for these flags to the man page, but in
>> the process I realized that have a question. Do these flags provide
>> equivalents of O_DSYNC and O_SYNC for the I/O operation, or for the
>> file? What I mean is this: with, say, RWF_DSYNC, is it just the data
>> written by this pwritev2() call that is synced to the underlying file,
>> or is all dirty data for the file synced at that point?
> 
> You beat me to it - I'm overdue sending you updates for these flags.
> 
> The flags only affect the actual pwritev2 operation they are applied
> to.  That is only the range just written is guaranteed to be on
> stable storage.

Thanks. I added some words to make that clear:

       RWF_DSYNC (since Linux 4.7)
              Provide a per-write equivalent of the O_DSYNC open(2) flag.
#             This flag is meaningful only for pwritev2(), and its effect
#             applies only to the data range written by the system call.

       RWF_SYNC (since Linux 4.7)
              Provide a per-write equivalent of the O_SYNC open(2)  flag.
#             This flag is meaningful only for pwritev2(), and its effect
#             applies only to the data range written by the system call.


> Btw, I was going to just send you a patch, but it seems your update
> isn't out in the git tree yet, is it?

They were sitting in a private branch while I waited for (and missed)
your reply. The changes are now pushed in master. Thanks for your help.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
