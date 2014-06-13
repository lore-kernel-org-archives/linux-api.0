From: Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH v6 6/9] seccomp: add "seccomp" syscall
Date: Fri, 13 Jun 2014 15:26:11 -0700
Message-ID: <CAMEtUuwKNx8TfRtRx=wdy3EwsL0ioQCMxhasXbrBvrBZW+tBgg@mail.gmail.com>
References: <1402457121-8410-1-git-send-email-keescook@chromium.org>
	<1402457121-8410-7-git-send-email-keescook@chromium.org>
	<CAMEtUuwKRUYN_qdnCj42G3Z1UT3vMYPoJqXd2_PjV+_J3WA+8w@mail.gmail.com>
	<CALCETrVCJvnj9yr5yhhZTn_Gq32mgSqOhMRi16Y=_LvqGOTZ5g@mail.gmail.com>
	<CAMEtUuykiN=FvBFZLp8ieN2ymt0=opfyFee0UC9aRpcW3SQ0pg@mail.gmail.com>
	<CALCETrVbsGjgtHtQKftxcNJB_vY5=Dd3FckW-1C9=xgdOrR6_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CALCETrVbsGjgtHtQKftxcNJB_vY5=Dd3FckW-1C9=xgdOrR6_A@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, John Johansen <john.johansen@canonical.com>, Andrew Morton <akpm@linux-foundation.org>, X86 ML <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 13, 2014 at 2:42 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Jun 13, 2014 at 2:37 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> On Fri, Jun 13, 2014 at 2:25 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Fri, Jun 13, 2014 at 2:22 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>>> On Tue, Jun 10, 2014 at 8:25 PM, Kees Cook <keescook@chromium.org> wrote:
>>>>> This adds the new "seccomp" syscall with both an "operation" and "flags"
>>>>> parameter for future expansion. The third argument is a pointer value,
>>>>> used with the SECCOMP_SET_MODE_FILTER operation. Currently, flags must
>>>>> be 0. This is functionally equivalent to prctl(PR_SET_SECCOMP, ...).
>>>>>
>>>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>>>> Cc: linux-api@vger.kernel.org
>>>>> ---
>>>>>  arch/x86/syscalls/syscall_32.tbl  |    1 +
>>>>>  arch/x86/syscalls/syscall_64.tbl  |    1 +
>>>>>  include/linux/syscalls.h          |    2 ++
>>>>>  include/uapi/asm-generic/unistd.h |    4 ++-
>>>>>  include/uapi/linux/seccomp.h      |    4 +++
>>>>>  kernel/seccomp.c                  |   63 ++++++++++++++++++++++++++++++++-----
>>>>>  kernel/sys_ni.c                   |    3 ++
>>>>>  7 files changed, 69 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
>>>>> index d6b867921612..7527eac24122 100644
>>>>> --- a/arch/x86/syscalls/syscall_32.tbl
>>>>> +++ b/arch/x86/syscalls/syscall_32.tbl
>>>>> @@ -360,3 +360,4 @@
>>>>>  351    i386    sched_setattr           sys_sched_setattr
>>>>>  352    i386    sched_getattr           sys_sched_getattr
>>>>>  353    i386    renameat2               sys_renameat2
>>>>> +354    i386    seccomp                 sys_seccomp
>>>>> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
>>>>> index ec255a1646d2..16272a6c12b7 100644
>>>>> --- a/arch/x86/syscalls/syscall_64.tbl
>>>>> +++ b/arch/x86/syscalls/syscall_64.tbl
>>>>> @@ -323,6 +323,7 @@
>>>>>  314    common  sched_setattr           sys_sched_setattr
>>>>>  315    common  sched_getattr           sys_sched_getattr
>>>>>  316    common  renameat2               sys_renameat2
>>>>> +317    common  seccomp                 sys_seccomp
>>>>>
>>>>>  #
>>>>>  # x32-specific system call numbers start at 512 to avoid cache impact
>>>>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>>>>> index b0881a0ed322..1713977ee26f 100644
>>>>> --- a/include/linux/syscalls.h
>>>>> +++ b/include/linux/syscalls.h
>>>>> @@ -866,4 +866,6 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
>>>>>  asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
>>>>>                          unsigned long idx1, unsigned long idx2);
>>>>>  asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
>>>>> +asmlinkage long sys_seccomp(unsigned int op, unsigned int flags,
>>>>> +                           const char __user *uargs);
>>>>
>>>> It looks odd to add 'flags' argument to syscall that is not even used.
>>>> It don't think it will be extensible this way.
>>>> 'uargs' is used only in 2nd command as well and it's not 'char __user *'
>>>> but rather 'struct sock_fprog __user *'
>>>> I think it makes more sense to define only first argument as 'int op' and the
>>>> rest as variable length array.
>>>> Something like:
>>>> long sys_seccomp(unsigned int op, struct nlattr *attrs, int len);
>>>> then different commands can interpret 'attrs' differently.
>>>> if op == mode_strict, then attrs == NULL, len == 0
>>>> if op == mode_filter, then attrs->nla_type == seccomp_bpf_filter
>>>> and nla_data(attrs) is 'struct sock_fprog'
>>>
>>> Eww.  If the operation doesn't imply the type, then I think we've
>>> totally screwed up.
>>>
>>>> If we decide to add new types of filters or new commands, the syscall prototype
>>>> won't need to change. New commands can be added preserving backward
>>>> compatibility.
>>>> The basic TLV concept has been around forever in netlink world. imo makes
>>>> sense to use it with new syscalls. Passing 'struct xxx' into syscalls
>>>> is the thing
>>>> of the past. TLV style is more extensible. Fields of structures can become
>>>> optional in the future, new fields added, etc.
>>>> 'struct nlattr' brings the same benefits to kernel api as protobuf did
>>>> to user land.
>>>
>>> I see no reason to bring nl_attr into this.
>>>
>>> Admittedly, I've never dealt with nl_attr, but everything
>>> netlink-related I've even been involved in has involved some sort of
>>> API atrocity.
>>
>> netlink has a lot of legacy and there is genetlink which is not pretty
>> either because of extra socket creation, binding, dealing with packet
>> loss issues, but the key concept of variable length encoding is sound.
>> Right now seccomp has two commands and they already don't fit
>> into single syscall neatly. Are you saying there should be two syscalls
>> here? What about another seccomp related command? Another syscall?
>> imo all seccomp related commands needs to be mux/demux-ed under
>> one syscall. What is the way to mux/demux potentially very different
>> commands under one syscall? I cannot think of anything better than
>> TLV style. 'struct nlattr' is what we have today and I think it works fine.
>> I'm not suggesting to bring the whole netlink into the picture, but rather
>> TLV style of encoding different arguments for different commands.
>
> I'm unconvinced.  These are simple commands, and I think the interface
> should be simple.  Syscalls are cheap.
>
> As an example, the interface could be:
>
> int seccomp_add_filter(const struct sock_fprog *filter, unsigned int flags);
>
> The "tsync" operation would be seccomp_add_filter(NULL,
> SECCOMP_ADD_FILTER_TSYNC) -- it's equivalent to adding an
> always-accept filter and syncing threads.
>
> But, frankly, this kind of stuff should probably be "do operation X".
> IIUC nl_attr is more like "do something, with these tags and values",
> which results in oddities like whatever should happen of more than one
> tag is set.

TLV is a price of extensibility vs simplicity.
Say we have a syscall_foo(struct XX __user *x); that takes
struct XX {
  int flag;
  int var1;
};
now we want to add another variable to the structure that will be used
only when certain flag is set. You cannot do it easily without
breaking old user binaries, since new structure will be:
struct XX2 {
  int flag;
  int var1;
  int var2;
};
if we do copy_from_user(,, sizeof(struct XX2)) it will brake old programs.
Potentially we can do it the ugly way:
copy_from_user(,, sizeof(struct XX)), then check flag and do another
copy_from_user(,, sizeof(struct XX2)) just to fetch extra argument.
but then another day passes and yet another new flag means that both
var1 and var2 are unused and it needs 'u64 var3' instead.
Now kernel looks very ugly by doing multiple copy_from_user() of different
structures.
It would be much cleaner with nlattr:
syscall_foo(struct nlattr *attrs, int len);
kernel fetches 'len' bytes onces and then picks var[123] fields from nlattr
array. In other words nlattr array is a way to represent flexible structure
where fields can come and go in the future.
This was a simple example. Consider the case where var1 and var2
are arrays of things.
imo the old:
struct sock_fprog {
        unsigned short          len;    /* Number of filter blocks */
        struct sock_filter __user *filter;
};
is the example of inflexible user interface.
It could have been single 'struct nlattr'
nlattr->nla_len == length of filter program in bytes
nlattr->nla_type == ARRAY_OF_SOCK_FILTER constant
nla_data(nlattr) - variable length array of 'struct sock_filter' bpf
instructions.
Right now I'd like to extend it for the work I'm doing around eBPF, but
I cannot, since it's rigid. If it was TLV, I could have easily added new flags,
new types, new sections to bpf programs.
For user space it would have been just as easy to populate such
'struct nlattr' as to populate 'struct sock_fprog'.
