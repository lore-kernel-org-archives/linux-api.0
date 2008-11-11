From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/2] Shared flags
Date: Tue, 11 Nov 2008 03:52:11 -0500
Message-ID: <20081111085211.GB2323@infradead.org>
References: <49183DF9.9010003@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <49183DF9.9010003-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 10, 2008 at 04:58:17PM +0300, Pavel Shilovsky wrote:
> Hello!
> We have situation during our work with Wine and Cifs-client  then we  
> have to use sharing access policy to files and we used 3 free bits from  
> 21 to 23 of attribute flag(it allows to do NT-semantic for opening files  
> in open() and it is necessary for correct implementation of function  
> NTCreateFile in Wine). We think that it'll be useful not only for us and  
> we proffer to add into the file kernel/include/asm-generic/fcntl.h  
> following flags:
>
> #define O_DENYREAD      004000000 /* Do not permit read access */
> #define O_DENYWRITE     010000000 /* Do not permit write access */
> #define O_DENYDELETE  020000000 /* Do not permit delete or rename  
> operations*/

I'm not completely opposed to these, but the patches you postd are
rather incomplete:

 (1) you need to add it to fcntl.h for those architetures not using the
     generic fcntl.h or those who would have overlapping bits with the
     generic defintions.
 (2) you also need to enforce these semantics in the VFS for local
     filesystems

Now if (2) doesn't cause too much overhead I would say it's fine, if not
I would rather avoid it.

Also please Cc the linux-api list for userspace API updates.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
