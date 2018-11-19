From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Mon, 19 Nov 2018 19:23:18 +0100
Message-ID: <20181119182314.fbhnmv5xyt5gy3za@brauner.io>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-3-christian@brauner.io>
 <20181119171053.GA28067@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181119171053.GA28067@asgard.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Syromiatnikov <esyr@redhat.com>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 06:10:53PM +0100, Eugene Syromiatnikov wrote:
> On Mon, Nov 19, 2018 at 11:32:39AM +0100, Christian Brauner wrote:
> > diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
> > index 3cf7b533b3d1..e637eab883e9 100644
> > --- a/arch/x86/entry/syscalls/syscall_32.tbl
> > +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> > @@ -398,3 +398,4 @@
> >  384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
> >  385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevents
> >  386	i386	rseq			sys_rseq			__ia32_sys_rseq
> > +387	i386	procfd_signal		sys_procfd_signal		__ia32_sys_procfd_signal
> > diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
> > index f0b1709a5ffb..e95f6741ab42 100644
> > --- a/arch/x86/entry/syscalls/syscall_64.tbl
> > +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> > @@ -343,6 +343,7 @@
> >  332	common	statx			__x64_sys_statx
> >  333	common	io_pgetevents		__x64_sys_io_pgetevents
> >  334	common	rseq			__x64_sys_rseq
> > +335	common	procfd_signal		__x64_sys_procfd_signal
> 
> You have wired up the syscall on x86 but have not added the syscall number
> to the generic syscall header (include/uapi/asm-generic/unistd.h), why?

Oversight on my part, sorry.
