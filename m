From: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Subject: Re: [RFC] introduce sys_syncfs to sync a single file system (v2)
Date: Thu, 10 Mar 2011 11:28:54 -0800 (PST)
Message-ID: <Pine.LNX.4.64.1103101128000.4190@cobra.newdream.net>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
 <Pine.LNX.4.64.1103071515070.11152@cobra.newdream.net> <8762ruchcr.fsf@linux.vnet.ibm.com>
 <201103101556.44698.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103101556.44698.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 10 Mar 2011, Arnd Bergmann wrote:
> On Tuesday 08 March 2011, Aneesh Kumar K. V wrote:
> > >  arch/x86/ia32/ia32entry.S          |    1 +
> > >  arch/x86/include/asm/unistd_32.h   |    3 ++-
> > >  arch/x86/include/asm/unistd_64.h   |    2 ++
> > >  arch/x86/kernel/syscall_table_32.S |    1 +
> > >  fs/sync.c                          |   24 ++++++++++++++++++++++++
> > >  5 files changed, 30 insertions(+), 1 deletions(-)
> > 
> > 
> > include/asm-generic/unistd.h may also need an update.
> 
> I was just going to say the same.
> 
> Also, include/linux/syscalls.h should list the prototype, because
> some architectures generate the system call table from C code.

Thanks!  Sending an updated patch now.

sage
