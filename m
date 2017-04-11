From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH RFC v2 0/3] security: Add ModAutoRestrict LSM
Date: Mon, 10 Apr 2017 21:23:39 -0700
Message-ID: <CAGXu5jLjd8ttpa_S16dadr=k6-mZGkSa3G6RBu9NUe6g5M399w@mail.gmail.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On Sun, Apr 9, 2017 at 3:42 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
> Hi List,
>
> This is RFC v2 of the Module auto-loading restriction feature. The
> module has been renamed ModAutoRestrict LSM.
>
> This RFC is a work in progress update.
>
> There are still minor things to fix which are listed in the TODO
> section. Also I used Tetsuo approach of stacking task->security, since
> now that the task_security_alloc() hook is in linux-security/next I took
> advantage of it and switched to use that hook and applied Tetsuo
> task->security per LSM blob on top of it. I can also switch to Casey
> approach. However, since these are internal implementation details which
> are not exposed, I do not think that this is a big issue. Thanks for the
> work now it is clear that we are able to easily stack new LSMs.
>
> Patches are against linux-security/next HEAD 622f6e3265707eb
>
> ==============
>
> ModAutoRestrict is a Linux Security Module that applies restrictions on
> automatic module loading operations. This is selectable at build-time
> with CONFIG_SECURITY_MODAUTORESTRICT, and can be controlled at run-time
> through sysctls in /proc/sys/kernel/modautorestrict/autoload or as a
> per-process setting via a prctl() interface.
>
> A userspace request to use a kernel feature that is implemented by modules
> that are not loaded may trigger the module auto-load feature to load
> these modules in order to satisfy userspace. However as today's Linux use
> cases cover embedded systems to containers where applications are running
> in their own separate environments, reducing or preventing operations
> that may affect external environments is an important constraint.
> Therefore, we need a way to control if automatic module loading is
> allowed or which applications are allowed to trigger the module
> auto-load feature.

It might be worth looking through the last several years of kernel
CVEs to find all the ones that would have been stopped with a feature
like this. There are many examples lately: both DCCP (CVE-2017-6074)
and n_hldc (CVE-2017-2636) come to mind this year alone.

> The ModAutoRestrict LSM allows system administrators or sandbox
> mechanisms to control the module auto-load feature and prevent loading
> unneeded modules or abuse the interface.
>
> The settings can be applied globally using a sysctl interface which
> completes the core kernel interface "modules_disable".

Typo: complements

Perhaps mention why this is a complement (i.e. modules_disable is ALL
modules, and modautorestrict is just auto-loaded, not explicitly
loaded).

>
> The feature is also available as a prctl() interface. This allows to
> apply restrictions when sandboxing processes. On embedded Linux systems,
> or containers where only some containers/processes should have the
> right privileges to load modules, this allows to restrict those
> processes from inserting modules. Only privileged processes can be
> allowed to perform so. A more restrictive access can be applied where
> the module autoload feature is completely disabled.
> In this schema the access rules are per-process and inherited by
> children created by fork(2) and clone(2), and preserved across execve(2).
>
> Interface:
>
> *) The per-process prctl() settings are:
>
>  prctl(PR_MOD_AUTO_RESTRICT_OPTS, PR_SET_MOD_AUTO_RESTRICT, value, 0, 0)
>
>  Where value means:
>
>  0 - Classic module auto-load permissions, nothing changes.
>
>  1 - The current process must have CAP_SYS_MODULE to be able to
>      auto-load modules. CAP_NET_ADMIN should allow to auto-load
>      modules with a 'netdev-%s' alias.
>
>  2 - Current process can not auto-load modules. Once set, this prctl
>      value can not be changed.
>
>  The per-process value may only be increased, never decreased, thus ensuring
>  that once applied, processes can never relaxe their setting.

Typo: relax

> *) The global sysctl setting can be set by writting an integer value to
>    '/proc/sys/kernel/modautorestrict/autoload'

I wonder if this should just be named
/proc/sys/kernel/modules_autoload (to look more like
modules_disabled)?

>  The valid values are:
>
>  0 - Classic module auto-load permissions, nothing changes.
>
>  1 - Processes must have CAP_SYS_MODULE to be able to auto-load modules.
>      CAP_NET_ADMIN should allow to auto-load modules with a 'netdev-%s'
>      alias.
>
>  2 - Processes can not auto-load modules. Once set, this sysctl value
>      can not be changed.
>
> *) Access rules:
>    First the prctl() settings are checked, if the access is not denied
>    then the global sysctl settings are checked.
>
> The original idea and inspiration is from grsecurity 'GRKERNSEC_MODHARDEN'.
>
>
> The sample code here can be used to test the feature:
> https://gist.githubusercontent.com/tixxdz/39a583358f04d40b4d3e5571f95c075b/raw/7fb416285412891e2637fba149da930fe0898356/modautorestrict_test.c
>
> # TODO list:
> *) Confirm the struct task_struct->security stacking mechanism.

If we can't settle on a way to do this, perhaps this LSM should just
live in the core kernel, similar to modules_disabled? We do already
have the hooks to implement it with an LSM, but I'd hate to block this
feature just because we can't solve task_struct sharing.

Maybe add a new bit like no_new_privs? (Though I guess you'd need 2
bits, so maybe a full field like no_new_privs used to be.)

> *) Add a logging mechanism.
> *) Remove the use of security_kernel_read_file hook. Use only
>    security_kernel_module_request and make sure that we cover all cases.
> *) Convert documentation to .rst

Another TODO item could be to add output to /proc/$pid/status as done
for seccomp and no_new_privs? Though perhaps only if this is a core
kernel change...

> # Changes since v1:
> *) Renamed module to ModAutoRestrict
> *) Improved documentation to explicity refer to module autoloading.
> *) Switched to use the new task_security_alloc() hook.
> *) Switched from rhash tables to use task->security since it is in
>    linux-security/next branch now.
> *) Check all parameters passed to prctl() syscall.
> *) Many other bug fixes and documentation improvements.
>
> All Kees Cook comments handled, except for the removing of
> security_kernel_read_file which I will do in next iteration when
> I make sure that I did not miss something. Thank you!
>
>
> Tetsuo Handa (1):
>         LSM: Allow per LSM module per "struct task_struct" blob
>
> Djalal Harouni (2):
>         security: add the ModAutoRestrict Linux Security Module
>         Documentation: add ModAutoRestrict LSM documentation
>
>
>  Documentation/security/00-INDEX            |   2 +
>  Documentation/security/ModAutoRestrict.txt |  77 ++++++
>  MAINTAINERS                                |   7 +
>  include/linux/lsm_hooks.h                  |  41 +++-
>  include/uapi/linux/prctl.h                 |   5 +
>  security/Kconfig                           |   1 +
>  security/Makefile                          |  16 +-
>  security/modautorestrict/Kconfig           |  15 ++
>  security/modautorestrict/Makefile          |   3 +
>  security/modautorestrict/modauto_lsm.c     | 372 +++++++++++++++++++++++++++++
>  security/security.c                        |  38 ++-
>  11 files changed, 568 insertions(+), 9 deletions(-)

I'd love to see this restriction added; I'm sick of adding stuff to
modprobe.d blacklist files after-the-fact...

-Kees

-- 
Kees Cook
Pixel Security
