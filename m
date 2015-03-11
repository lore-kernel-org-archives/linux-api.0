From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 33/45] include/uapi/asm-generic/signal.h: include stdlib.h in userspace
Date: Wed, 11 Mar 2015 11:02:13 +0100
Message-ID: <2194220.H3M4AuVBTf@wuerfel>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <2372547.aJh8O9JSDy@wuerfel> <20150310225828.GZ12550@lakka.kapsi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150310225828.GZ12550-dqH1CgrzRhOk/eJAJmRu5A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 11 March 2015 00:58:28 Mikko Rapeli wrote:
> linux/kexec.h seems suspicious though:
> 
> #ifndef __KERNEL__
> /*
>  * This structure is used to hold the arguments that are used when
>  * loading  kernel binaries.
>  */
> struct kexec_segment {
>         const void *buf;
>         size_t bufsz;
>         const void *mem;
>         size_t memsz;
> };
> 
> #endif /* __KERNEL__ */
> 

Hmm, maybe that just needs to be removed as well, after we
have removed the function declaration that used to follow it
as part of this commit:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=9dc5c05f45ca8101025046cd

Using __kernel_size_t would work here as well, but I suspect that
the entire structure is useless as it is not used by kernel or
user space, and kexec_tools has its own copy of the structure.

	Arnd
