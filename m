From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 24/25] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Mon, 10 Dec 2018 11:38:17 -0800
Message-ID: <CALCETrV4J8+_gSHONAcQHt6XFgtuW487b9DHZ8MV-xa6XhZ_Og@mail.gmail.com>
References: <20181210043126.GX6131@altlinux.org>
 <201812102200.snodXJSH%fengguang.wu@intel.com>
 <20181210160940.GF14149@altlinux.org>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181210160940.GF14149-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.strace.io/mailman/options/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.strace.io/pipermail/strace-devel/>
List-Post: <mailto:strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Help: <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.strace.io/mailman/listinfo/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
Sender: "Strace-devel" <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
To: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, jhogan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, paul.burton-8NJIiSa5LzA@public.gmane.org, Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
List-Id: linux-api@vger.kernel.org

> On Dec 10, 2018, at 8:09 AM, Dmitry V. Levin <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org> wrote:
>
> Hi, things are getting too complicated and we need some advice how to deal
> with this frame_pointer issue.
>
>> On Mon, Dec 10, 2018 at 10:26:50PM +0800, kbuild test robot wrote:
>> Hi Elvira,
>>
>> Thank you for the patch! Yet something to improve:
>>
>> [auto build test ERROR on linus/master]
>> [also build test ERROR on v4.20-rc6]
>> [cannot apply to next-20181207]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>>
>> url:    https://github.com/0day-ci/linux/commits/Dmitry-V-Levin/ptrace-add-PTRACE_GET_SYSCALL_INFO-request/20181210-174745
>> config: mips-malta_kvm_defconfig (attached as .config)
>> compiler: mipsel-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
>> reproduce:
>>        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>        chmod +x ~/bin/make.cross
>>        # save the attached .config to linux build tree
>>        GCC_VERSION=7.2.0 make.cross ARCH=mips
>>
>> All errors (new ones prefixed by >>):
>>
>>   kernel/ptrace.c: In function 'ptrace_get_syscall_info':
>>>> kernel/ptrace.c:942:20: error: implicit declaration of function 'frame_pointer'; did you mean 'trace_printk'? [-Werror=implicit-function-declaration]
>>      .frame_pointer = frame_pointer(regs)
>>                       ^~~~~~~~~~~~~
>>                       trace_printk
>>   cc1: some warnings being treated as errors
>>
>> vim +942 kernel/ptrace.c
>>
>>   931
>>   932    static int
>>   933    ptrace_get_syscall_info(struct task_struct *child, unsigned long user_size,
>>   934                void __user *datavp)
>>   935    {
>>   936        struct pt_regs *regs = task_pt_regs(child);
>>   937        struct ptrace_syscall_info info = {
>>   938            .op = PTRACE_SYSCALL_INFO_NONE,
>>   939            .arch = syscall_get_arch(child),
>>   940            .instruction_pointer = instruction_pointer(regs),
>>   941            .stack_pointer = user_stack_pointer(regs),
>>> 942            .frame_pointer = frame_pointer(regs)
>>   943        };
>>   944        unsigned long actual_size = offsetof(struct ptrace_syscall_info, entry);
>>   945        unsigned long write_size;
>>   946
>>   947        /*
>>   948         * This does not need lock_task_sighand() to access
>>   949         * child->last_siginfo because ptrace_freeze_traced()
>>   950         * called earlier by ptrace_check_attach() ensures that
>>   951         * the tracee cannot go away and clear its last_siginfo.
>>   952         */
>>   953        switch (child->last_siginfo ? child->last_siginfo->si_code : 0) {
>>   954        case SIGTRAP | 0x80:
>>   955            switch (child->ptrace_message) {
>>   956            case PTRACE_EVENTMSG_SYSCALL_ENTRY:
>>   957                actual_size = ptrace_get_syscall_info_entry(child, regs,
>>   958                                        &info);
>>   959                break;
>>   960            case PTRACE_EVENTMSG_SYSCALL_EXIT:
>>   961                actual_size = ptrace_get_syscall_info_exit(child, regs,
>>   962                                       &info);
>>   963                break;
>>   964            }
>>   965            break;
>>   966        case SIGTRAP | (PTRACE_EVENT_SECCOMP << 8):
>>   967            actual_size = ptrace_get_syscall_info_seccomp(child, regs,
>>   968                                      &info);
>>   969            break;
>>   970        }
>>   971
>>   972        write_size = min(actual_size, user_size);
>>   973        return copy_to_user(datavp, &info, write_size) ? -EFAULT : actual_size;
>>   974    }
>>   975
>
> We decided to add .frame_pointer to struct ptrace_syscall_info just for
> consistency with .instruction_pointer and .stack_pointer; I must have been
> misled by comments in asm-generic/ptrace.h into thinking that
> frame_pointer() is universally available across architectures.
>
> Unlike .instruction_pointer and .stack_pointer that are actually needed
> in strace, .frame_pointer is not used, so from strace PoV we don't really
> need it.
>
> So the question is, does anybody need a
> struct ptrace_syscall_info.frame_pointer?
>
> If yes, how can frame_pointer() be defined on MIPS?
> Or should we just forget about making sense of frame_pointer() and remove
> struct ptrace_syscall_info.frame_pointer from the proposed API?
>

I would suggest getting rid of frame_pointer. Anyone who needs that
degree of debugging can use existing ptrace APIs for it.

>
> --
> ldv
-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel
