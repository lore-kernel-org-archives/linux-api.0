From: Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH v1 3/5] Yama: Enforces noexec mounts or file
 executability through O_MAYEXEC
Date: Wed, 12 Dec 2018 18:09:35 +0100
Message-ID: <CAG48ez3SAW8EyaJ9T1U3qPoRhYwe4CCyL9bAxuc3GxjrXipi-A@mail.gmail.com>
References: <20181212081712.32347-1-mic@digikod.net> <20181212081712.32347-4-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181212081712.32347-4-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, mickael.salaun@ssi.gouv.fr, zohar@linux.ibm.com, philippe.trebuchet@ssi.gouv.fr, shuah@kernel.org, thibaut.sautereau@ssi.gouv.fr, vincent.strubel@ssi.gouv.fr, yves-alexis.perez@ssi.gouv.fr, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 12, 2018 at 9:18 AM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> Enable to either propagate the mount options from the underlying VFS
> mount to prevent execution, or to propagate the file execute permission.
> This may allow a script interpreter to check execution permissions
> before reading commands from a file.
>
> The main goal is to be able to protect the kernel by restricting
> arbitrary syscalls that an attacker could perform with a crafted binary
> or certain script languages.  It also improves multilevel isolation
> by reducing the ability of an attacker to use side channels with
> specific code.  These restrictions can natively be enforced for ELF
> binaries (with the noexec mount option) but require this kernel
> extension to properly handle scripts (e.g., Python, Perl).
>
> Add a new sysctl kernel.yama.open_mayexec_enforce to control this
> behavior.  A following patch adds documentation.
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Reviewed-by: Philippe Tr=C3=A9buchet <philippe.trebuchet@ssi.gouv.fr>
> Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Micka=C3=ABl Sala=C3=BCn <mickael.salaun@ssi.gouv.fr>
> ---
[...]
> +/**
> + * yama_inode_permission - check O_MAYEXEC permission before accessing a=
n inode
> + * @inode: inode structure to check
> + * @mask: permission mask
> + *
> + * Return 0 if access is permitted, -EACCES otherwise.
> + */
> +int yama_inode_permission(struct inode *inode, int mask)

This should be static, no?

> +{
> +       if (!(mask & MAY_OPENEXEC))
> +               return 0;
> +       /*
> +        * Match regular files and directories to make it easier to
> +        * modify script interpreters.
> +        */
> +       if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
> +               return 0;

So files are subject to checks, but loading code from things like
sockets is always fine?

> +       if ((open_mayexec_enforce & YAMA_OMAYEXEC_ENFORCE_MOUNT) &&
> +                       !(mask & MAY_EXECMOUNT))
> +               return -EACCES;
> +
> +       /*
> +        * May prefer acl_permission_check() instead of generic_permissio=
n(),
> +        * to not be bypassable with CAP_DAC_READ_SEARCH.
> +        */
> +       if (open_mayexec_enforce & YAMA_OMAYEXEC_ENFORCE_FILE)
> +               return generic_permission(inode, MAY_EXEC);
> +
> +       return 0;
> +}
> +
>  static struct security_hook_list yama_hooks[] __lsm_ro_after_init =3D {
> +       LSM_HOOK_INIT(inode_permission, yama_inode_permission),
>         LSM_HOOK_INIT(ptrace_access_check, yama_ptrace_access_check),
>         LSM_HOOK_INIT(ptrace_traceme, yama_ptrace_traceme),
>         LSM_HOOK_INIT(task_prctl, yama_task_prctl),
> @@ -447,6 +489,37 @@ static int yama_dointvec_minmax(struct ctl_table *ta=
ble, int write,
>         return proc_dointvec_minmax(&table_copy, write, buffer, lenp, ppo=
s);
>  }
>
> +static int yama_dointvec_bitmask_macadmin(struct ctl_table *table, int w=
rite,
> +                                         void __user *buffer, size_t *le=
np,
> +                                         loff_t *ppos)
> +{
> +       int error;
> +
> +       if (write) {
> +               struct ctl_table table_copy;
> +               int tmp_mayexec_enforce;
> +
> +               if (!capable(CAP_MAC_ADMIN))
> +                       return -EPERM;

Don't put capable() checks in sysctls, it doesn't work.
