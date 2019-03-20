From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [RESEND PATCH v1] moduleparam: Save information about built-in
 modules in separate file
Date: Wed, 20 Mar 2019 17:54:35 +0900
Message-ID: <CAK7LNATuuAHav=RJ8oAQNyj1THR1bazWY-+6hOJ6EM+V-WOW5A@mail.gmail.com>
References: <20190315101013.GN8455@Legion-PC.fortress>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190315101013.GN8455@Legion-PC.fortress>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Michal Marek <michal.lkml@markovi.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-api@vger.kernel.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>, "Dmitry V. Levin" <ldv@altlinux.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 15, 2019 at 7:10 PM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> Problem:
>
> When a kernel module is compiled as a separate module, some important
> information about the kernel module is available via .modinfo section of
> the module.  In contrast, when the kernel module is compiled into the
> kernel, that information is not available.
>
> Information about built-in modules is necessary in the following cases:
>
> 1. When it is necessary to find out what additional parameters can be
> passed to the kernel at boot time.
>
> 2. When you need to know which module names and their aliases are in
> the kernel. This is very useful for creating an initrd image.
>
> Proposal:
>
> The proposed patch does not remove .modinfo section with module
> information from the vmlinux at the build time and saves it into a
> separate file after kernel linking. So, the kernel does not increase in
> size and no additional information remains in it. Information is stored
> in the same format as in the separate modules (null-terminated string
> array). Because the .modinfo section is already exported with a separate
> modules, we are not creating a new API.
>
> It can be easily read in the userspace:
>
> $ tr '\0' '\n' < kernel.builtin.modinfo
> ext4.softdep=pre: crc32c
> ext4.license=GPL
> ext4.description=Fourth Extended Filesystem
> ext4.author=Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others
> ext4.alias=fs-ext4
> ext4.alias=ext3
> ext4.alias=fs-ext3
> ext4.alias=ext2
> ext4.alias=fs-ext2
> md_mod.alias=block-major-9-*
> md_mod.alias=md
> md_mod.description=MD RAID framework
> md_mod.license=GPL
> md_mod.parmtype=create_on_open:bool
> md_mod.parmtype=start_dirty_degraded:int
> ...
>
> Co-Developed-by: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
> Signed-off-by: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> ---


I just started to take a look.

I was able to compile it for x86,
but got tons of warnings for powerpc.

Anyway, you do not need to send v2 soon.
Please give me some more time for the through review.



The following is what I got by
"make -j8 ARCH=powerpc CROSS_COMPILE=powerpc-linux-  defconfig  all"


...
  CC [M]  drivers/scsi/st.o
  AR      drivers/scsi/built-in.a
  AR      drivers/built-in.a
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  AR      init/built-in.a
  LD      vmlinux.o
  MODPOST vmlinux.o
powerpc-linux-ld: warning: orphan section `.gnu.hash' from `linker
stubs' being placed in section `.gnu.hash'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`arch/powerpc/platforms/pseries/pseries_energy.o' being placed in
section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`arch/powerpc/platforms/pseries/cmm.o' being placed in section
`.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`arch/powerpc/platforms/pasemi/gpio_mdio.o' being placed in section
`.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`kernel/workqueue.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`kernel/printk/printk.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`kernel/irq/spurious.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`kernel/rcu/update.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`kernel/rcu/srcutree.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`kernel/rcu/tree.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`kernel/module.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`kernel/configs.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/binfmt_script.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/binfmt_elf.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/compat_binfmt_elf.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/mbcache.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nfs_common/nfsacl.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nfs_common/grace.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/ext4/super.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/ext2/super.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/jbd2/journal.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/fat/inode.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/fat/namei_msdos.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/isofs/inode.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nfs/dir.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nfs/inode.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nfs/super.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nfs/nfs2super.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nfs/nfs3super.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nfs/nfs4super.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/exportfs/expfs.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/lockd/svc.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nls/nls_base.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nls/nls_cp437.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nls/nls_ascii.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nls/nls_iso8859-1.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/nls/nls_utf8.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/xfs/xfs_super.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/debugfs/inode.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`fs/tracefs/inode.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/api.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/crypto_wq.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/algapi.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/aead.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/blkcipher.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/skcipher.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/ahash.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/shash.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/akcipher.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/kpp.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/acompress.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/scompress.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/algboss.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/testmgr.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/hmac.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/crypto_null.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/sha256_generic.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/aes_generic.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/crc32c_generic.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`crypto/rng.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`block/bsg.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`block/mq-deadline.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`block/kyber-iosched.o' being placed in section `.modinfo'.
powerpc-linux-ld: warning: orphan section `.modinfo' from
`lib/btree.o' being placed in section `.modinfo'.

...





>  Makefile                    |  1 +
>  include/linux/moduleparam.h | 12 +++++-------
>  scripts/link-vmlinux.sh     |  8 ++++++++
>  3 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index d5713e7b1e50..971102194c92 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1288,6 +1288,7 @@ _modinst_:
>         fi
>         @cp -f $(objtree)/modules.order $(MODLIB)/
>         @cp -f $(objtree)/modules.builtin $(MODLIB)/
> +       @cp -f $(objtree)/kernel.builtin.modinfo $(MODLIB)/
>         $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
>
>  # This depmod is only for convenience to give the initial
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index ba36506db4fb..5ba250d9172a 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -10,23 +10,21 @@
>     module name. */
>  #ifdef MODULE
>  #define MODULE_PARAM_PREFIX /* empty */
> +#define __MODULE_INFO_PREFIX /* empty */
>  #else
>  #define MODULE_PARAM_PREFIX KBUILD_MODNAME "."
> +/* We cannot use MODULE_PARAM_PREFIX because some modules override it. */
> +#define __MODULE_INFO_PREFIX KBUILD_MODNAME "."
>  #endif
>
>  /* Chosen so that structs with an unsigned long line up. */
>  #define MAX_PARAM_PREFIX_LEN (64 - sizeof(unsigned long))
>
> -#ifdef MODULE
>  #define __MODULE_INFO(tag, name, info)                                   \
>  static const char __UNIQUE_ID(name)[]                                    \
>    __used __attribute__((section(".modinfo"), unused, aligned(1)))        \
> -  = __stringify(tag) "=" info
> -#else  /* !MODULE */
> -/* This struct is here for syntactic coherency, it is not used */
> -#define __MODULE_INFO(tag, name, info)                                   \
> -  struct __UNIQUE_ID(name) {}
> -#endif
> +  = __MODULE_INFO_PREFIX __stringify(tag) "=" info
> +
>  #define __MODULE_PARM_TYPE(name, _type)                                          \
>    __MODULE_INFO(parmtype, name##type, #name ":" _type)
>
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index c8cf45362bd6..399d7e4d11ec 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -258,10 +258,12 @@ if [ -n "${CONFIG_KALLSYMS}" ]; then
>
>         # step 1
>         vmlinux_link "" .tmp_vmlinux1
> +       "${OBJCOPY}" -R .modinfo .tmp_vmlinux1
>         kallsyms .tmp_vmlinux1 .tmp_kallsyms1.o
>
>         # step 2
>         vmlinux_link .tmp_kallsyms1.o .tmp_vmlinux2
> +       "${OBJCOPY}" -R .modinfo .tmp_vmlinux2
>         kallsyms .tmp_vmlinux2 .tmp_kallsyms2.o
>
>         # step 3
> @@ -273,6 +275,7 @@ if [ -n "${CONFIG_KALLSYMS}" ]; then
>                 kallsyms_vmlinux=.tmp_vmlinux3
>
>                 vmlinux_link .tmp_kallsyms2.o .tmp_vmlinux3
> +               "${OBJCOPY}" -R .modinfo .tmp_vmlinux3
>
>                 kallsyms .tmp_vmlinux3 .tmp_kallsyms3.o
>         fi
> @@ -281,6 +284,11 @@ fi
>  info LD vmlinux
>  vmlinux_link "${kallsymso}" vmlinux
>
> +info MODINFO kernel.builtin.modinfo
> +"${OBJCOPY}" -j .modinfo -O binary vmlinux kernel.builtin.modinfo
> +chmod 444 kernel.builtin.modinfo
> +"${OBJCOPY}" -R .modinfo vmlinux
> +
>  if [ -n "${CONFIG_BUILDTIME_EXTABLE_SORT}" ]; then
>         info SORTEX vmlinux
>         sortextable vmlinux
> --
> 2.19.2
>


-- 
Best Regards
Masahiro Yamada
