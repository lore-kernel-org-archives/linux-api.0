From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH RFC v2 4/6] proc: support mounting private procfs
 instances inside same pid namespace
Date: Wed, 26 Apr 2017 15:13:30 -0700
Message-ID: <CALCETrWOjLnfCgpAJs6tTjLXeNHjqPQa5qSZpztcnbR2kN5A2w@mail.gmail.com>
References: <1493123038-30590-1-git-send-email-tixxdz@gmail.com> <1493123038-30590-5-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7602-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1493123038-30590-5-git-send-email-tixxdz@gmail.com>
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 25, 2017 at 5:23 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
> This patch allows to have multiple private procfs instances inside the
> same pid namespace. Lot of other areas in the kernel and filesystems
> have been updated to be able to support private instances, devpts is one
> major example. The aim here is lightweight sandboxes, and to allow that we
> have to modernize procfs internals.
>
> 1) The main aim of this work is to have on embedded systems one
> supervisor for apps. Right now we have some lightweight sandbox support,
> however if we create pid namespacess we have to manages all the
> processes inside too, where our goal is to be able to run a bunch of
> apps each one inside its own mount namespace without being able to
> notice each other. We only want to use mount namespaces, and we want
> procfs to behave more like a real mount point.
>
> 2) Linux Security Modules have multiple ptrace paths inside some
> subsystems, however inside procfs, the implementation does not guarantee
> that the ptrace() check which triggers the security_ptrace_check() hook
> will always run. We have the 'hidepid' mount option that can be used to
> force the ptrace_may_access() check inside has_pid_permissions() to run.
> The problem is that 'hidepid' is per pid namespace and not attached to
> the mount point, any remount or modification of 'hidepid' will propagate
> to all other procfs mounts.
>
> This also does not allow to support Yama LSM easily in desktop and user
> sessions. Yama ptrace scope which restricts ptrace and some other
> syscalls to be allowed only on inferiors, can be updated to have a
> per-task context, where the context will be inherited during fork(),
> clone() and preserved across execve(). If we support multiple private
> procfs instances, then we may force the ptrace_may_access() on
> /proc/<pids>/ to always run inside that new procfs instances. This will
> allow to specifiy on user sessions if we should populate procfs with
> pids that the user can ptrace or not.
>
> By using Yama ptrace scope, some restricted users will only be able to see
> inferiors inside /proc, they won't even be able to see their other
> processes. Some software like Chromium, Firefox's crash handler, Wine
> and others are already using Yama to restrict which processes can be
> ptracable. With this change this will give the possibility to restrict
> /proc/<pids>/ but more importantly this will give desktop users a
> generic and usuable way to specifiy which users should see all processes
> and which users can not.
>
> Side notes:
> * This covers the lack of seccomp where it is not able to parse
> arguments, it is easy to install a seccomp filter on direct syscalls
> that operate on pids, however /proc/<pid>/ is a Linux ABI using
> filesystem syscalls. With this change LSMs should be able to analyze
> open/read/write/close...
>
> 3) This will modernize procfs and align it with all other filesystems
> and subsystems that have been updated recently to be able to work in a
> flexible way. This is the same as devpts where each mount now is a distinct
> filesystem such that ptys and their indicies allocated in one mount are
> independent from ptys and their indicies in all other mounts.
>
> We have to align procfs and modernize it to have a per mount context
> where at least the mount option do not propagate to all other mounts,
> then maybe we can continue to implement new features. One example is to
> require CAP_SYS_ADMIN in the init user namespace on some /proc/* which are
> not pids and which are are not virtualized by design, or CAP_NET_ADMIN
> inside userns on the net bits that are virtualized, etc.
> These mount options won't propagate to previous mounts, and the system
> will continue to be usable.
>
> Ths patch introduces the new 'limit_pids' mount option as it was also
> suggesed by Andy Lutomirski [1]. When this option is passed we
> automatically create a private procfs instance. This is not the default
> behaviour since we do not want to break userspace and we do not want to
> provide different devices IDs by default, please see [1] for why.

I think that calling the option to make a separate instance
"limit_pids" is extremely counterintuitive.

My strong preference would be to make proc *always* make a separate
instance (unless it's a bind mount) and to make it work.  If that
means fudging stat() output, so be it.

Failing that, let's come up with some coherent way to make this work.
"new_instance" or similar would do.  Then make limit_pid cause an
error unless new_instance is also set.

--Andy
