From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/5] Add preadv and pwritev system calls.
Date: Fri, 16 Jan 2009 18:34:01 +0100
Message-ID: <200901161834.02481.arnd@arndb.de>
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com> <1232124344-25892-4-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1232124344-25892-4-git-send-email-kraxel@redhat.com>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, aarcange@redhat.com
List-Id: linux-api@vger.kernel.org

On Friday 16 January 2009, Gerd Hoffmann wrote:
> +asmlinkage ssize_t compat_sys_preadv(unsigned long fd,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const struct compat_iov=
ec __user *vec,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0unsigned long vlen, u32=
 pos_high, u32 pos_low);
> +asmlinkage ssize_t compat_sys_pwritev(unsigned long fd,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const struct compat_iov=
ec __user *vec,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0unsigned long vlen, u32=
 pos_high, u32 pos_low);
> =A0
> =A0int compat_do_execve(char * filename, compat_uptr_t __user *argv,
> =A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0 =A0compat_uptr_t __user *envp, s=
truct pt_regs * regs);
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 16875f8..333377e 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -456,6 +456,10 @@ asmlinkage long sys_pread64(unsigned int fd, cha=
r __user *buf,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 =A0 =A0size_t count, loff_t pos);
> =A0asmlinkage long sys_pwrite64(unsigned int fd, const char __user *b=
uf,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 =A0 =A0 size_t count, loff_t pos);
> +asmlinkage long sys_preadv(unsigned long fd, const struct iovec __us=
er *vec,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long v=
len, u32 pos_high, u32 pos_low);
> +asmlinkage long sys_pwritev(unsigned long fd, const struct iovec __u=
ser *vec,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned lon=
g vlen, u32 pos_high, u32 pos_low);

Conventionally, the 'fd' argument has type 'int', not 'unsigned long', =
but you
evidently copied this from readv/writev, so you can't really be blamed =
for it.
Not sure what the right thing to do here is.

	Arnd <><
