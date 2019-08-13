From: Alistair Francis <alistair23@gmail.com>
Subject: Re: [PATCH] syscalls: Update the syscall #defines to match uapi
Date: Tue, 13 Aug 2019 11:57:20 -0700
Message-ID: <CAKmqyKNH7G=_gs2Hfc3OZMFaHzUwU8fSomfu_r92hJrnJHJT3A@mail.gmail.com>
References: <20190810010758.16407-1-alistair.francis@wdc.com> <CAK8P3a2wYMsBRm1X-TFo1d7-B7Xug9gwqF77HitoE7wmOqD7rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2wYMsBRm1X-TFo1d7-B7Xug9gwqF77HitoE7wmOqD7rw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alistair Francis <alistair.francis@wdc.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 12, 2019 at 2:49 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Sat, Aug 10, 2019 at 3:11 AM Alistair Francis
> <alistair.francis@wdc.com> wrote:
> >
> > Update the #defines around sys_fstat64() and sys_fstatat64() to match
> > the #defines around the __NR3264_fstatat and __NR3264_fstat definitions
> > in include/uapi/asm-generic/unistd.h. This avoids compiler failures if
> > one is defined.
>
> What is the compiler failure you get?

I don't have it infornt of me but it was along the lines of
sys_fstat64/sys_fstatat64 not being defined when __ARCH_WANT_NEW_STAT
is defined but __ARCH_WANT_STAT64 isn't.

>
> > Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
> > ---
> >  include/linux/syscalls.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> > index 2bcef4c70183..e4bf5e480d60 100644
> > --- a/include/linux/syscalls.h
> > +++ b/include/linux/syscalls.h
> > @@ -512,7 +512,7 @@ asmlinkage long sys_readlinkat(int dfd, const char __user *path, char __user *bu
> >  asmlinkage long sys_newfstatat(int dfd, const char __user *filename,
> >                                struct stat __user *statbuf, int flag);
> >  asmlinkage long sys_newfstat(unsigned int fd, struct stat __user *statbuf);
> > -#if defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_COMPAT_STAT64)
> > +#if defined(__ARCH_WANT_NEW_STAT) || defined(__ARCH_WANT_STAT64)
> >  asmlinkage long sys_fstat64(unsigned long fd, struct stat64 __user *statbuf);
> >  asmlinkage long sys_fstatat64(int dfd, const char __user *filename,
> >                                struct stat64 __user *statbuf, int flag);
>
> I think this is wrong: when __ARCH_WANT_NEW_STAT is set, we are
> on a 64-bit architecture and only want the sys_newfstat{,at} system
> calls, not sys_fstat{,at}64 that gets used on 32-bit machines.

Ah, that would make sense then. I don't think you will see the error then.

Alistair

>
> The #if check in the syscalls.h file also matches the definition of
> the function.
>
>        Arnd
