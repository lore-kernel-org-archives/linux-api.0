From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/11] ext4: add cross rename support
Date: Wed, 23 Apr 2014 21:01:16 +0200
Message-ID: <53580DFC.9060507@gmail.com>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>	<1389219015-10980-12-git-send-email-miklos@szeredi.hu>	<20140113122517.GA10366@quack.suse.cz>	<20140115182347.GB5715@fieldses.org>	<CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com>	<20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu>	<52D90B93.5010209@gmail.com>	<20140117144126.GG24171@tucsk.piliscsaba.szeredi.hu>	<53523D16.9020101@gmail.com> <CAJfpegsdUwxHOGxhiLtkMHzB==UGzbj+rAVOJGX4nb6z1Urzpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJfpegsdUwxHOGxhiLtkMHzB==UGzbj+rAVOJGX4nb6z1Urzpw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "mszeredi-AlSwsSmVLrQ@public.gmane.org" <mszeredi-AlSwsSmVLrQ@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 04/23/2014 04:21 PM, Miklos Szeredi wrote:
> On Sat, Apr 19, 2014 at 11:08 AM, Michael Kerrisk (man-pages)
> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi Miklos,
>>
>>> The code changes are pushed to the git tree and the updated man page is below.
>>
>> Now that renameat2() is in 3.15, I've taken these changes. This had to be
>> manually does, because I'd done some major reworking on the pages since you
>> originally wrote your text. So, I may have injected some errors.
>>
>> I did a little light reworking of the text and added VERSIONS and
>> CONFORMING TO pieces. I also added a couple of FIXMEs, to note points
>> that will need to be updated once glibc support is (presumably) added.
>> (Carlos, what's the usual process for triggering that sort of thing?)
>>
>> Could you please review the diff below (now against rename(2)).
> 
> Looks okay.

Thanks for checking it.

> One comment on the current rename.2 page:
> 
>   #include <fcntl.h>           /* Definition of AT_* constants */
> 
> AT_ constants are not used in renameat() hence this seems unneeded.

I think you overlooked AT_FDCWD? (It is true though that that comment 
is boilerplate across the *at() pages, some of which have several 
AT_* constants.)

> Not sure where the RENAME_ constants need to go once renameat2() is
> added to glibc, possibly to <stdio.h> since they are closely related
> to rename.

Will you be prodding the glibc folks about this?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
