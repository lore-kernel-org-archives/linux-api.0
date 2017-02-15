From: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] ioctl_list.2: BLKRASET/BLKRAGET take unsigned long
Date: Wed, 15 Feb 2017 13:59:46 +0100
Message-ID: <20170215125946.GA27511@rei.lan>
References: <20170215112015.GA27080@rei.lan>
 <20170215112205.GA27269@rei.lan>
 <CAK8P3a0KzhqFZqvPH4q7_Nb6+TMmhCWXDi_-wQG=mi-1U=Ccxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a0KzhqFZqvPH4q7_Nb6+TMmhCWXDi_-wQG=mi-1U=Ccxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi!
> >> I also wonder if it's OK to pass int value to ioctl() at all, the arg
> >> value seems to be unsigned long in the syscall definition in fs/ioctl.c
> >> and there does not seem to be any glibc magic around the syscall.
> 
> This shouldn't matter, if you pass an 'int' into a function that takes
> a 'long', it will be extended if necessary. The question is more about
> how it gets interpreted, and in this case it's done by assigning to

I guess that it may, since the ioctl() prototype is defined with ...

>From /usr/include/sys/ioctl.h:

...
extern int ioctl (int __fd, unsigned long int __request, ...) __THROW;
...

Looking at dissasembly we do:

4005bb:       89 c7                   mov    %eax,%edi
(%eax holds fd from open())

...

4005bb:       89 c7                   mov    %eax,%edi
4005bd:       ba 00 02 00 00          mov    $0x200,%edx
                                                    ^
						We do 32bit load here

4005c2:       be 62 12 00 00          mov    $0x1262,%esi
4005c7:       31 c0                   xor    %eax,%eax
4005c9:       e8 72 ff ff ff          callq  400540 <ioctl@plt>

The ioctl assembly just sets %eax and then syscall.

So as far as I can tell we depend here on a fact that upper part of $rdx
is zeroed. Not sure if that is guaranteed or not.

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
