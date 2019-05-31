From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/5] Add fchmodat4(), a new syscall
Date: Fri, 31 May 2019 21:51:00 +0200
Message-ID: <CAK8P3a3HPeVq29k3Zk5rSk4bddiUQFrdEgDZUgdNnYZK+8QpGw@mail.gmail.com>
References: <20190531191204.4044-1-palmer@sifive.com> <20190531191204.4044-3-palmer@sifive.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531191204.4044-3-palmer@sifive.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Palmer Dabbelt <palmer@sifive.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-api@vger.kernel.org

On Fri, May 31, 2019 at 9:23 PM Palmer Dabbelt <palmer@sifive.com> wrote:
>
> man 3p says that fchmodat() takes a flags argument, but the Linux
> syscall does not.  There doesn't appear to be a good userspace
> workaround for this issue but the implementation in the kernel is pretty
> straight-forward.  The specific use case where the missing flags came up
> was WRT a fuse filesystem implemenation, but the functionality is pretty
> generic so I'm assuming there would be other use cases.
>
> Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
> ---
>  fs/open.c                | 21 +++++++++++++++++++--
>  include/linux/syscalls.h |  5 +++++
>  2 files changed, 24 insertions(+), 2 deletions(-)
>
> diff --git a/fs/open.c b/fs/open.c
> index a00350018a47..cfad7684e8d3 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -568,11 +568,17 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
>         return ksys_fchmod(fd, mode);
>  }
>
> -int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
> +int do_fchmodat4(int dfd, const char __user *filename, umode_t mode, int flags)
...
> +
> +int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
> +{
> +       return do_fchmodat4(dfd, filename, mode, 0);
> +}
> +

There is only one external caller of do_fchmodat(), so just change that
to pass the extra argument here, and keep a single do_fchmodat()
function used by the sys_fchmod(), sys_fchmod4(), sys_chmod()
and ksys_chmod().

        Arnd
