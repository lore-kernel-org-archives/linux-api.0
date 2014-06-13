From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v6 6/9] seccomp: add "seccomp" syscall
Date: Fri, 13 Jun 2014 14:25:35 -0700
Message-ID: <CALCETrVCJvnj9yr5yhhZTn_Gq32mgSqOhMRi16Y=_LvqGOTZ5g@mail.gmail.com>
References: <1402457121-8410-1-git-send-email-keescook@chromium.org>
 <1402457121-8410-7-git-send-email-keescook@chromium.org> <CAMEtUuwKRUYN_qdnCj42G3Z1UT3vMYPoJqXd2_PjV+_J3WA+8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMEtUuwKRUYN_qdnCj42G3Z1UT3vMYPoJqXd2_PjV+_J3WA+8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Johansen <john.johansen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 13, 2014 at 2:22 PM, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org> wrote:
> On Tue, Jun 10, 2014 at 8:25 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> This adds the new "seccomp" syscall with both an "operation" and "flags"
>> parameter for future expansion. The third argument is a pointer value,
>> used with the SECCOMP_SET_MODE_FILTER operation. Currently, flags must
>> be 0. This is functionally equivalent to prctl(PR_SET_SECCOMP, ...).
>>
>> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>>  arch/x86/syscalls/syscall_32.tbl  |    1 +
>>  arch/x86/syscalls/syscall_64.tbl  |    1 +
>>  include/linux/syscalls.h          |    2 ++
>>  include/uapi/asm-generic/unistd.h |    4 ++-
>>  include/uapi/linux/seccomp.h      |    4 +++
>>  kernel/seccomp.c                  |   63 ++++++++++++++++++++++++++++++++-----
>>  kernel/sys_ni.c                   |    3 ++
>>  7 files changed, 69 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
>> index d6b867921612..7527eac24122 100644
>> --- a/arch/x86/syscalls/syscall_32.tbl
>> +++ b/arch/x86/syscalls/syscall_32.tbl
>> @@ -360,3 +360,4 @@
>>  351    i386    sched_setattr           sys_sched_setattr
>>  352    i386    sched_getattr           sys_sched_getattr
>>  353    i386    renameat2               sys_renameat2
>> +354    i386    seccomp                 sys_seccomp
>> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
>> index ec255a1646d2..16272a6c12b7 100644
>> --- a/arch/x86/syscalls/syscall_64.tbl
>> +++ b/arch/x86/syscalls/syscall_64.tbl
>> @@ -323,6 +323,7 @@
>>  314    common  sched_setattr           sys_sched_setattr
>>  315    common  sched_getattr           sys_sched_getattr
>>  316    common  renameat2               sys_renameat2
>> +317    common  seccomp                 sys_seccomp
>>
>>  #
>>  # x32-specific system call numbers start at 512 to avoid cache impact
>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> index b0881a0ed322..1713977ee26f 100644
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -866,4 +866,6 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
>>  asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
>>                          unsigned long idx1, unsigned long idx2);
>>  asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
>> +asmlinkage long sys_seccomp(unsigned int op, unsigned int flags,
>> +                           const char __user *uargs);
>
> It looks odd to add 'flags' argument to syscall that is not even used.
> It don't think it will be extensible this way.
> 'uargs' is used only in 2nd command as well and it's not 'char __user *'
> but rather 'struct sock_fprog __user *'
> I think it makes more sense to define only first argument as 'int op' and the
> rest as variable length array.
> Something like:
> long sys_seccomp(unsigned int op, struct nlattr *attrs, int len);
> then different commands can interpret 'attrs' differently.
> if op == mode_strict, then attrs == NULL, len == 0
> if op == mode_filter, then attrs->nla_type == seccomp_bpf_filter
> and nla_data(attrs) is 'struct sock_fprog'

Eww.  If the operation doesn't imply the type, then I think we've
totally screwed up.

> If we decide to add new types of filters or new commands, the syscall prototype
> won't need to change. New commands can be added preserving backward
> compatibility.
> The basic TLV concept has been around forever in netlink world. imo makes
> sense to use it with new syscalls. Passing 'struct xxx' into syscalls
> is the thing
> of the past. TLV style is more extensible. Fields of structures can become
> optional in the future, new fields added, etc.
> 'struct nlattr' brings the same benefits to kernel api as protobuf did
> to user land.

I see no reason to bring nl_attr into this.

Admittedly, I've never dealt with nl_attr, but everything
netlink-related I've even been involved in has involved some sort of
API atrocity.

--Andy
