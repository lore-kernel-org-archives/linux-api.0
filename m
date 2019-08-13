From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] syscalls: Update the syscall #defines to match uapi
Date: Tue, 13 Aug 2019 21:41:17 +0200
Message-ID: <CAK8P3a0phB6hb=Da6V=CWWmi_oYwUcpSRi6CZTqAPz7QXKFJTA@mail.gmail.com>
References: <20190810010758.16407-1-alistair.francis@wdc.com>
 <CAK8P3a2wYMsBRm1X-TFo1d7-B7Xug9gwqF77HitoE7wmOqD7rw@mail.gmail.com> <CAKmqyKNH7G=_gs2Hfc3OZMFaHzUwU8fSomfu_r92hJrnJHJT3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKmqyKNH7G=_gs2Hfc3OZMFaHzUwU8fSomfu_r92hJrnJHJT3A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alistair Francis <alistair23@gmail.com>
Cc: Alistair Francis <alistair.francis@wdc.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 13, 2019 at 9:01 PM Alistair Francis <alistair23@gmail.com> wrote:
> On Mon, Aug 12, 2019 at 2:49 AM Arnd Bergmann <arnd@arndb.de> wrote:

> > > diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> > > index 2bcef4c70183..e4bf5e480d60 100644
> > > --- a/include/linux/syscalls.h
> > > +++ b/include/linux/syscalls.h
> > > @@ -512,7 +512,7 @@ asmlinkage long sys_readlinkat(int dfd, const char __user *path, char __user *bu
> > >  asmlinkage long sys_newfstatat(int dfd, const char __user *filename,
> > >                                struct stat __user *statbuf, int flag);
> > >  asmlinkage long sys_newfstat(unsigned int fd, struct stat __user *statbuf);
> > > -#if defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_COMPAT_STAT64)
> > > +#if defined(__ARCH_WANT_NEW_STAT) || defined(__ARCH_WANT_STAT64)
> > >  asmlinkage long sys_fstat64(unsigned long fd, struct stat64 __user *statbuf);
> > >  asmlinkage long sys_fstatat64(int dfd, const char __user *filename,
> > >                                struct stat64 __user *statbuf, int flag);
> >
> > I think this is wrong: when __ARCH_WANT_NEW_STAT is set, we are
> > on a 64-bit architecture and only want the sys_newfstat{,at} system
> > calls, not sys_fstat{,at}64 that gets used on 32-bit machines.
>
> Ah, that would make sense then. I don't think you will see the error then.

So we don't need this patch to build riscv32 kernels, right? It's possible
that it was the result of an incorrect forward port of some other patch,
as older riscv32 kernels did provide stat64(), but newer ones only have
statx().

       Arnd
