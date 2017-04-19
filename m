From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
Date: Wed, 19 Apr 2017 16:15:28 -0700
Message-ID: <CALCETrXFp-apnfRPg9qx6E7g3KDU8DanBW1pMUnA1zShrB5xKg@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com> <1492640420-27345-3-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1492640420-27345-3-git-send-email-tixxdz@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 19, 2017 at 3:20 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
> Previous patches added the global "modules_autoload" restriction. This patch
> make it possible to support process trees, containers, and sandboxes by
> providing an inherited per-task "modules_autoload" flag that cannot be
> re-enabled once disabled. This allows to restrict automatic module
> loading without affecting the rest of the system.
>
> Any task can set its "modules_autoload". Once set, this setting is inherited
> across fork, clone and execve. With "modules_autoload" set, automatic
> module loading will have first to satisfy the per-task access permissions
> before attempting to implicitly load the module. For example, automatic
> loading of modules that contain bugs or vulnerabilities can be
> restricted and untrusted users can no longer abuse such interfaces
>
> To set modules_autoload, use prctl(PR_SET_MODULES_AUTOLOAD, value, 0, 0, 0).
>
> When value is (0), the default, automatic modules loading is allowed.
>
> When value is (1), task must have CAP_SYS_MODULE to be able to trigger a
> module auto-load operation, or CAP_NET_ADMIN for modules with a
> 'netdev-%s' alias.
>
> When value is (2), automatic modules loading is disabled for the current
> task.
>
> The 'modules_autoload' value may only be increased, never decreased, thus
> ensuring that once applied, processes can never relax their setting.
>
> When a request to a kernel module is denied, the module name with the
> corresponding process name and its pid are logged. Administrators can use
> such information to explicitly load the appropriate modules.
>
> The per-task "modules_autoload" restriction:
>
> Before:
> $ lsmod | grep ipip -
> $ sudo ip tunnel add mytun mode ipip remote 10.0.2.100 local 10.0.2.15 ttl 255
> $ lsmod | grep ipip -
> ipip                   16384  0
> tunnel4                16384  1 ipip
> ip_tunnel              28672  1 ipip
>
> After:
> $ lsmod | grep ipip -
> $ ./pr_modules_autoload
> $ grep "Modules" /proc/self/status
> ModulesAutoload:        2
> $ cat /proc/sys/kernel/modules_autoload
> 0
> $ sudo ip tunnel add mytun mode ipip remote 10.0.2.100 local 10.0.2.15 ttl 255
> add tunnel "tunl0" failed: No such device
> $ lsmod | grep ipip
> $ dmesg | tail -3
> [   16.363903] virbr0: port 1(virbr0-nic) entered disabled state
> [  823.565958] Automatic module loading of netdev-tunl0 by "ip"[1362] was denied
> [  823.565967] Automatic module loading of tunl0 by "ip"[1362] was denied
>
> Cc: Serge Hallyn <serge@hallyn.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
> ---
>  Documentation/filesystems/proc.txt       |  3 ++
>  Documentation/prctl/modules_autoload.txt | 49 +++++++++++++++++++++++++++++++
>  fs/proc/array.c                          |  6 ++++
>  include/linux/module.h                   | 48 ++++++++++++++++++++++++++++--
>  include/linux/sched.h                    |  5 ++++
>  include/linux/security.h                 |  2 +-
>  include/uapi/linux/prctl.h               |  8 +++++
>  kernel/fork.c                            |  4 +++
>  kernel/module.c                          | 17 +++++++----
>  security/commoncap.c                     | 50 ++++++++++++++++++++++++++++----
>  10 files changed, 178 insertions(+), 14 deletions(-)
>  create mode 100644 Documentation/prctl/modules_autoload.txt
>
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index 4cddbce..df4d145 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -194,6 +194,7 @@ read the file /proc/PID/status:
>    CapBnd: ffffffffffffffff
>    NoNewPrivs:     0
>    Seccomp:        0
> +  ModulesAutoload:      0
>    voluntary_ctxt_switches:        0
>    nonvoluntary_ctxt_switches:     1
>
> @@ -267,6 +268,8 @@ Table 1-2: Contents of the status files (as of 4.8)
>   CapBnd                      bitmap of capabilities bounding set
>   NoNewPrivs                  no_new_privs, like prctl(PR_GET_NO_NEW_PRIV, ...)
>   Seccomp                     seccomp mode, like prctl(PR_GET_SECCOMP, ...)
> + ModulesAutoload             modules autoload, like
> +                             prctl(PR_GET_MODULES_AUTOLOAD, ...)
>   Cpus_allowed                mask of CPUs on which this process may run
>   Cpus_allowed_list           Same as previous, but in "list format"
>   Mems_allowed                mask of memory nodes allowed to this process
> diff --git a/Documentation/prctl/modules_autoload.txt b/Documentation/prctl/modules_autoload.txt
> new file mode 100644
> index 0000000..242852e
> --- /dev/null
> +++ b/Documentation/prctl/modules_autoload.txt
> @@ -0,0 +1,49 @@
> +A request to a kernel feature that is implemented by a module that is
> +not loaded may trigger the module auto-load feature, allowing to
> +transparently satisfy userspace. In this case an implicit kernel module
> +load operation happens.
> +
> +Usually to load or unload a kernel module, an explicit operation happens
> +where programs are required to have some capabilities in order to perform
> +such operations. However, with the implicit module loading, no
> +capabilities are required, anyone who is able to request a certain kernel
> +feature, may also implicitly load its corresponding kernel module. This
> +operation can be abused by unprivileged users to expose kernel interfaces
> +that maybe privileged users did not want to be made available for various
> +reasons: resources, bugs, vulnerabilties, etc. The DCCP vulnerability is
> +(CVE-2017-6074) is one real example.
> +
> +The new per-task "modules_autoload" flag, is a new way to restrict
> +automatic module loading, preventing the kernel from exposing more of
> +its interface. This particularly useful for containers and sandboxes
> +where sandboxed processes should affect the rest of the system.
> +
> +Any task can set "modules_autoload". Once set, this setting is inherited
> +across fork, clone and execve. With "modules_autoload" set, automatic
> +module loading will have first to satisfy the per-task access permissions
> +before attempting to implicitly load the module. For example, automatic
> +loading of modules that contain bugs or vulnerabilities can be
> +restricted and imprivileged users can no longer abuse such interfaces.
> +
> +To set modules_autoload, use prctl(PR_SET_MODULES_AUTOLOAD, value, 0, 0, 0).
> +
> +When value is (0), the default, automatic modules loading is allowed.
> +
> +When value is (1), task must have CAP_SYS_MODULE to be able to trigger a
> +module auto-load operation, or CAP_NET_ADMIN for modules with a
> +'netdev-%s' alias.
> +
> +When value is (2), automatic modules loading is disabled for the current
> +task.
> +
> +The 'modules_autoload' value may only be increased, never decreased, thus
> +ensuring that once applied, processes can never relax their setting.
> +
> +When a request to a kernel module is denied, the module name with the
> +corresponding process name and its pid are logged. Administrators can use
> +such information to explicitly load the appropriate modules.
> +
> +Please note that even if the per-task "modules_autoload" value allows to
> +auto-load the corresponding module, automatic module loading may still
> +fail due to the global "modules_autoload" sysctl. For more details please
> +see "modules_autoload" in Documentation/sysctl/kernel.txt
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 88c3555..cbcf087 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -88,6 +88,7 @@
>  #include <linux/string_helpers.h>
>  #include <linux/user_namespace.h>
>  #include <linux/fs_struct.h>
> +#include <linux/module.h>
>
>  #include <asm/pgtable.h>
>  #include <asm/processor.h>
> @@ -346,10 +347,15 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
>
>  static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
>  {
> +       int autoload = task_modules_autoload(p);
> +
>         seq_put_decimal_ull(m, "NoNewPrivs:\t", task_no_new_privs(p));
>  #ifdef CONFIG_SECCOMP
>         seq_put_decimal_ull(m, "\nSeccomp:\t", p->seccomp.mode);
>  #endif
> +       if (autoload != -ENOSYS)
> +               seq_put_decimal_ull(m, "\nModulesAutoload:\t", autoload);
> +
>         seq_putc(m, '\n');
>  }
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 4b96c10..595800f 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -13,6 +13,7 @@
>  #include <linux/kmod.h>
>  #include <linux/init.h>
>  #include <linux/elf.h>
> +#include <linux/sched.h>
>  #include <linux/stringify.h>
>  #include <linux/kobject.h>
>  #include <linux/moduleparam.h>
> @@ -506,7 +507,33 @@ bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr);
>  bool is_module_percpu_address(unsigned long addr);
>  bool is_module_text_address(unsigned long addr);
>
> -int modules_autoload_access(char *kmod_name);
> +int modules_autoload_access(struct task_struct *task, char *kmod_name);
> +
> +/* Sets task's modules_autoload */
> +static inline int task_set_modules_autoload(struct task_struct *task,
> +                                           unsigned long value)
> +{
> +       if (value > MODULES_AUTOLOAD_DISABLED)
> +               return -EINVAL;
> +       else if (task->modules_autoload > value)
> +               return -EPERM;
> +       else if (task->modules_autoload < value)
> +               task->modules_autoload = value;
> +
> +       return 0;
> +}

This needs to be more locked down.  Otherwise someone could set this
and then run a setuid program.  Admittedly, it would be quite odd if
this particular thing causes a problem, but the issue exists
nonetheless.

More generally, I think this feature would fit in fairly nicely with
my "implicit rights" idea.  Unfortunately, Linus hated it, but maybe
if I actually implemented it, he wouldn't hate it so much.
