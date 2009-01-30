From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 1/1] x86: syscalls: sys_setrlimit64/sys_getrlimit64 calls  to provide FSIZE limits > 2^32-1
Date: Fri, 30 Jan 2009 19:04:51 +0100
Message-ID: <200901301904.52328.arnd@arndb.de>
References: <200901231759.n0NHxKA3009104@eng-pool-55.spikesource.com> <497E595F.2010708@gmail.com> <85e5430e0901300957x64951d6at2a79c5cb1ee88e97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <85e5430e0901300957x64951d6at2a79c5cb1ee88e97-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Narendra Prasad Madanapalli <narendramind-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-3NddpPZAyC0@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Friday 30 January 2009, Narendra Prasad Madanapalli wrote:
> Can you provide me more information on how to port these system calls
> to 32-on-64 kernel.

Your interface has compatible calling conventions between 32 and 64
bit user programs, so for x86, all you need to do is to add them to
arch/x86/ia32/ia32entry.S in the same way as you did for
arch/x86/kernel/syscall_table_32.S.
For the other architectures, the respective maintainers will take
care of this if your patch gets accepted. Unfortunately, each
architecture has a different way of adding the compat system
calls.

	Arnd <><
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
