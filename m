From: Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Date: Fri, 16 Oct 2009 08:25:59 +0200
Message-ID: <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>
References: <20091013044925.GA28181@us.ibm.com>
	<20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20091016042041.GA7220-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/containers>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Sukadev

On Fri, Oct 16, 2009 at 6:20 AM, Sukadev Bhattiprolu
<sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> Here is an updated patch with the following interface:
>
> =A0 =A0 =A0 =A0long sys_clone3(unsigned int flags_low, struct clone_args =
__user *cs,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pid_t *pids);
>
> There are just two other (minor) changes pending to this patchset:
>
> =A0 =A0 =A0 =A0- PATCH 7: add a CLONE_UNUSED bit to VALID_CLONE_FLAGS().
> =A0 =A0 =A0 =A0- PATCH 10: update documentation to reflect new interface.
>
> If this looks ok, we repost entire patchset next week.

I know I'm late to this discussion, but why the name clone3()? It's
not consistent with any other convention used fo syscall naming,
AFAICS. I think a name like clone_ext() or clonex() (for extended)
might make more sense.

Cheers,

Michael


> ---
>
> Subject: [RFC][v8][PATCH 9/10]: Define clone3() syscall
>
> Container restart requires that a task have the same pid it had when it w=
as
> checkpointed. When containers are nested the tasks within the containers
> exist in multiple pid namespaces and hence have multiple pids to specify
> during restart.
>
> clone3(), intended for use during restart, is the same as clone(), except
> that it takes a 'pids' paramter. This parameter lets caller choose
> specific pid numbers for the child process, in the process's active and
> ancestor pid namespaces. (Descendant pid namespaces in general don't matt=
er
> since processes don't have pids in them anyway, but see comments in
> copy_target_pids() regarding CLONE_NEWPID).
>
> Clone2() system call also attempts to address a second limitation of the
> clone() system call. clone() is restricted to 32 clone flags and most (al=
l ?)
> of these are in use. If a new clone flag is needed, we will be forced to
> define a new variant of the clone() system call.
>
> To prevent unprivileged processes from misusing this interface, clone3()
> currently needs CAP_SYS_ADMIN, when the 'pids' parameter is non-NULL.
>
> See Documentation/clone3 in next patch for more details of clone3() and an
> example of its usage.
>
> NOTE:
> =A0 =A0 =A0 =A0- System calls are restricted to 6 parameters and the numb=
er and sizes
> =A0 =A0 =A0 =A0 =A0of parameters needed for sys_clone3() exceed 6 integer=
s. The new
> =A0 =A0 =A0 =A0 =A0prototype works around this restriction while providin=
g some
> =A0 =A0 =A0 =A0 =A0flexibility if clone3() needs to be further extended i=
n the future.
> TODO:
> =A0 =A0 =A0 =A0- We should convert clone-flags to 64-bit value in all arc=
hitectures.
> =A0 =A0 =A0 =A0 =A0Its probably best to do that as a separate patchset si=
nce clone_flags
> =A0 =A0 =A0 =A0 =A0touches several functions and that patchset seems inde=
pendent of this
> =A0 =A0 =A0 =A0 =A0new system call.
>
>
> Changelog[v9-rc1]:
> =A0 =A0 =A0 =A0- [Roland McGrath, H. Peter Anvin] To avoid confusion on 6=
4-bit
> =A0 =A0 =A0 =A0 =A0architectures split the new clone-flags into 'low' and=
 'high'
> =A0 =A0 =A0 =A0 =A0words and pass in the 'lower' flags as the first argum=
ent.
> =A0 =A0 =A0 =A0 =A0This would maintain similarity of the clone3() with cl=
one()/
> =A0 =A0 =A0 =A0 =A0clone2(). Also has the side-effect of the name matchin=
g the
> =A0 =A0 =A0 =A0 =A0number of parameters :-)
> =A0 =A0 =A0 =A0- [Roland McGrath] Rename structure to 'clone_args' and ad=
d a
> =A0 =A0 =A0 =A0 =A0'child_stack_size' field
>
> Changelog[v8]
> =A0 =A0 =A0 =A0- [Oren Laadan] parent_tid and child_tid fields in 'struct=
 clone_arg'
> =A0 =A0 =A0 =A0 =A0must be 64-bit.
> =A0 =A0 =A0 =A0- clone2() is in use in IA64. Rename system call to clone3=
().
>
> Changelog[v7]:
> =A0 =A0 =A0 =A0- [Peter Zijlstra, Arnd Bergmann] Rename system call to cl=
one2()
> =A0 =A0 =A0 =A0 =A0and group parameters into a new 'struct clone_struct' =
object.
>
> Changelog[v6]:
> =A0 =A0 =A0 =A0- (Nathan Lynch, Arnd Bergmann, H. Peter Anvin, Linus Torv=
alds)
> =A0 =A0 =A0 =A0 =A0Change 'pid_set.pids' to a 'pid_t pids[]' so size of '=
struct pid_set'
> =A0 =A0 =A0 =A0 =A0is constant across architectures.
> =A0 =A0 =A0 =A0- (Nathan Lynch) Change pid_set.num_pids to unsigned and r=
emove
> =A0 =A0 =A0 =A0 =A0'unum_pids < 0' check.
>
> Changelog[v4]:
> =A0 =A0 =A0 =A0- (Oren Laadan) rename 'struct target_pid_set' to 'struct =
pid_set'
>
> Changelog[v3]:
> =A0 =A0 =A0 =A0- (Oren Laadan) Allow CLONE_NEWPID flag (by allocating an =
extra pid
> =A0 =A0 =A0 =A0 =A0in the target_pids[] list and setting it 0. See copy_t=
arget_pids()).
> =A0 =A0 =A0 =A0- (Oren Laadan) Specified target pids should apply only to=
 youngest
> =A0 =A0 =A0 =A0 =A0pid-namespaces (see copy_target_pids())
> =A0 =A0 =A0 =A0- (Matt Helsley) Update patch description.
>
> Changelog[v2]:
> =A0 =A0 =A0 =A0- Remove unnecessary printk and add a note to callers of
> =A0 =A0 =A0 =A0 =A0copy_target_pids() to free target_pids.
> =A0 =A0 =A0 =A0- (Serge Hallyn) Mention CAP_SYS_ADMIN restriction in patc=
h description.
> =A0 =A0 =A0 =A0- (Oren Laadan) Add checks for 'num_pids < 0' (return -EIN=
VAL) and
> =A0 =A0 =A0 =A0 =A0'num_pids =3D=3D 0' (fall back to normal clone()).
> =A0 =A0 =A0 =A0- Move arch-independent code (sanity checks and copy-in of=
 target-pids)
> =A0 =A0 =A0 =A0 =A0into kernel/fork.c and simplify sys_clone_with_pids()
>
> Changelog[v1]:
> =A0 =A0 =A0 =A0- Fixed some compile errors (had fixed these errors earlie=
r in my
> =A0 =A0 =A0 =A0 =A0git tree but had not refreshed patches before emailing=
 them)
>
> Signed-off-by: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
> ---
> =A0arch/x86/include/asm/syscalls.h =A0 =A0| =A0 =A02
> =A0arch/x86/include/asm/unistd_32.h =A0 | =A0 =A01
> =A0arch/x86/kernel/process_32.c =A0 =A0 =A0 | =A0 61 ++++++++++++++++++++=
+++
> =A0arch/x86/kernel/syscall_table_32.S | =A0 =A01
> =A0include/linux/types.h =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 11 ++++
> =A0kernel/fork.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 96 ++++=
++++++++++++++++++++++++++++++++-
> =A06 files changed, 171 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/include/linux/types.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/include/linux/types.h =A0 =A0 =A0 =A02009-10-15 20:29:=
47.000000000 -0700
> +++ linux-2.6/include/linux/types.h =A0 =A0 2009-10-15 20:53:22.000000000=
 -0700
> @@ -204,6 +204,17 @@ struct ustat {
> =A0 =A0 =A0 =A0char =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0f_fpack[6];
> =A0};
>
> +struct clone_args {
> + =A0 =A0 =A0 u64 clone_flags_high;
> + =A0 =A0 =A0 u64 child_stack_base;
> + =A0 =A0 =A0 u64 child_stack_size;
> + =A0 =A0 =A0 u64 parent_tid_ptr;
> + =A0 =A0 =A0 u64 child_tid_ptr;
> + =A0 =A0 =A0 u32 nr_pids;
> + =A0 =A0 =A0 u32 clone_args_size;
> + =A0 =A0 =A0 u64 reserved1;
> +};
> +
> =A0#endif /* __KERNEL__ */
> =A0#endif /* =A0__ASSEMBLY__ */
> =A0#endif /* _LINUX_TYPES_H */
> Index: linux-2.6/arch/x86/include/asm/syscalls.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/x86/include/asm/syscalls.h =A0 =A0 =A02009-10-15 =
20:29:47.000000000 -0700
> +++ linux-2.6/arch/x86/include/asm/syscalls.h =A0 2009-10-15 20:38:53.000=
000000 -0700
> @@ -55,6 +55,8 @@ struct sel_arg_struct;
> =A0struct oldold_utsname;
> =A0struct old_utsname;
>
> +asmlinkage long sys_clone3(unsigned int flags_low,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct clone_args __user *c=
s, pid_t *pids);
> =A0asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long, unsigne=
d long, unsigned long);
> =A0asmlinkage int old_mmap(struct mmap_arg_struct __user *);
> Index: linux-2.6/arch/x86/include/asm/unistd_32.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/x86/include/asm/unistd_32.h =A0 =A0 2009-10-15 20=
:29:47.000000000 -0700
> +++ linux-2.6/arch/x86/include/asm/unistd_32.h =A02009-10-15 20:38:53.000=
000000 -0700
> @@ -342,6 +342,7 @@
> =A0#define __NR_pwritev =A0 =A0 =A0 =A0 =A0 334
> =A0#define __NR_rt_tgsigqueueinfo 335
> =A0#define __NR_perf_counter_open 336
> +#define __NR_clone3 =A0 =A0 =A0 =A0 =A0 =A0337
>
> =A0#ifdef __KERNEL__
>
> Index: linux-2.6/arch/x86/kernel/process_32.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/x86/kernel/process_32.c 2009-10-15 20:29:47.00000=
0000 -0700
> +++ linux-2.6/arch/x86/kernel/process_32.c =A0 =A0 =A02009-10-15 20:38:53=
.000000000 -0700
> @@ -443,6 +443,67 @@ int sys_clone(struct pt_regs *regs)
> =A0 =A0 =A0 =A0return do_fork(clone_flags, newsp, regs, 0, parent_tidptr,=
 child_tidptr);
> =A0}
>
> +asmlinkage long
> +sys_clone3(unsigned int flags_low, struct clone_args __user *ucs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pid_t __user *pids)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 struct clone_args kcs;
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 int __user *parent_tid_ptr;
> + =A0 =A0 =A0 int __user *child_tid_ptr;
> + =A0 =A0 =A0 unsigned long __user child_stack;
> + =A0 =A0 =A0 unsigned long stack_size;
> + =A0 =A0 =A0 struct pt_regs *regs;
> +
> + =A0 =A0 =A0 rc =3D copy_from_user(&kcs, ucs, sizeof(kcs));
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EFAULT;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* TODO: If size of clone_args is not what the kernel exp=
ects, it
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 could be that kernel is newer and has an e=
xtended structure.
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 When that happens, this check needs to be =
smarter (and we
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 need an additional copy_from_user()). For =
now, assume exact
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 match.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (kcs.clone_args_size !=3D sizeof(kcs))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* To avoid future compatibility issues, ensure unused fi=
elds are 0.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (kcs.reserved1 || kcs.clone_flags_high)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* TODO: Convert 'clone-flags' to 64-bits on all architec=
tures.
> + =A0 =A0 =A0 =A0* TODO: When ->clone_flags_high is non-zero, copy it in =
to the
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 higher word(s) of 'flags':
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 =A0 =A0 =A0 =A0flags =3D (kcs.clone_flags_=
high << 32) | flags_low;
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 flags =3D flags_low;
> + =A0 =A0 =A0 parent_tid_ptr =3D (int *)kcs.parent_tid_ptr;
> + =A0 =A0 =A0 child_tid_ptr =3D =A0(int *)kcs.child_tid_ptr;
> +
> + =A0 =A0 =A0 stack_size =3D (unsigned long)kcs.child_stack_size;
> + =A0 =A0 =A0 child_stack =3D (unsigned long)kcs.child_stack_base + stack=
_size;
> +
> + =A0 =A0 =A0 regs =3D task_pt_regs(current);
> +
> + =A0 =A0 =A0 if (!child_stack)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 child_stack =3D user_stack_pointer(regs);
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* TODO: On 32-bit systems, clone_flags is passed in as 3=
2-bit value
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 to several functions. Need to convert clon=
e_flags to 64-bit.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 return do_fork_with_pids(flags, child_stack, regs, stack_si=
ze,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 parent_tid_=
ptr, child_tid_ptr, kcs.nr_pids,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pids);
> +}
> +
> =A0/*
> =A0* sys_execve() executes a new program.
> =A0*/
> Index: linux-2.6/arch/x86/kernel/syscall_table_32.S
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/x86/kernel/syscall_table_32.S =A0 2009-10-15 20:2=
9:47.000000000 -0700
> +++ linux-2.6/arch/x86/kernel/syscall_table_32.S =A0 =A0 =A0 =A02009-10-1=
5 20:38:53.000000000 -0700
> @@ -336,3 +336,4 @@ ENTRY(sys_call_table)
> =A0 =A0 =A0 =A0.long sys_pwritev
> =A0 =A0 =A0 =A0.long sys_rt_tgsigqueueinfo =A0 =A0 /* 335 */
> =A0 =A0 =A0 =A0.long sys_perf_counter_open
> + =A0 =A0 =A0 .long sys_clone3
> Index: linux-2.6/kernel/fork.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/fork.c =A0 =A0 =A0 =A02009-10-15 20:38:50.00000=
0000 -0700
> +++ linux-2.6/kernel/fork.c =A0 =A0 2009-10-15 20:38:53.000000000 -0700
> @@ -1330,6 +1330,86 @@ struct task_struct * __cpuinit fork_idle
> =A0}
>
> =A0/*
> + * If user specified any 'target-pids' in @upid_setp, copy them from
> + * user and return a pointer to a local copy of the list of pids. The
> + * caller must free the list, when they are done using it.
> + *
> + * If user did not specify any target pids, return NULL (caller should
> + * treat this like normal clone).
> + *
> + * On any errors, return the error code
> + */
> +static pid_t *copy_target_pids(int unum_pids, pid_t __user *upids)
> +{
> + =A0 =A0 =A0 int j;
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 int size;
> + =A0 =A0 =A0 int knum_pids; =A0 =A0 =A0 =A0 =A0/* # of pids needed in ke=
rnel */
> + =A0 =A0 =A0 pid_t *target_pids;
> +
> + =A0 =A0 =A0 if (!unum_pids)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> +
> + =A0 =A0 =A0 knum_pids =3D task_pid(current)->level + 1;
> + =A0 =A0 =A0 if (unum_pids > knum_pids)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-EINVAL);
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* To keep alloc_pid() simple, allocate an extra pid_t in=
 target_pids[]
> + =A0 =A0 =A0 =A0* and set it to 0. This last entry in target_pids[] corr=
esponds to the
> + =A0 =A0 =A0 =A0* (yet-to-be-created) descendant pid-namespace if CLONE_=
NEWPID was
> + =A0 =A0 =A0 =A0* specified. If CLONE_NEWPID was not specified, this las=
t entry will
> + =A0 =A0 =A0 =A0* simply be ignored.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 target_pids =3D kzalloc((knum_pids + 1) * sizeof(pid_t), GF=
P_KERNEL);
> + =A0 =A0 =A0 if (!target_pids)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-ENOMEM);
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* A process running in a level 2 pid namespace has three=
 pid namespaces
> + =A0 =A0 =A0 =A0* and hence three pid numbers. If this process is checkp=
ointed,
> + =A0 =A0 =A0 =A0* information about these three namespaces are saved. We=
 refer to these
> + =A0 =A0 =A0 =A0* namespaces as 'known namespaces'.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* If this checkpointed process is however restarted in a=
 level 3 pid
> + =A0 =A0 =A0 =A0* namespace, the restarted process has an extra ancestor=
 pid namespace
> + =A0 =A0 =A0 =A0* (i.e 'unknown namespace') and 'knum_pids' exceeds 'unu=
m_pids'.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* During restart, the process requests specific pids for=
 its 'known
> + =A0 =A0 =A0 =A0* namespaces' and lets kernel assign pids to its 'unknow=
n namespaces'.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* Since the requested-pids correspond to 'known namespac=
es' and since
> + =A0 =A0 =A0 =A0* 'known-namespaces' are younger than (i.e descendants o=
f) 'unknown-
> + =A0 =A0 =A0 =A0* namespaces', copy requested pids to the back-end of ta=
rget_pids[]
> + =A0 =A0 =A0 =A0* (i.e before the last entry for CLONE_NEWPID mentioned =
above).
> + =A0 =A0 =A0 =A0* Any entries in target_pids[] not corresponding to a re=
quested pid
> + =A0 =A0 =A0 =A0* will be set to zero and kernel assigns a pid in those =
namespaces.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* NOTE: The order of pids in target_pids[] is oldest pid=
 namespace to
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 youngest (target_pids[0] corresponds to in=
it_pid_ns). i.e.
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 the order is:
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 =A0 =A0 =A0 =A0- pids for 'unknown-namespa=
ces' (if any)
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 =A0 =A0 =A0 =A0- pids for 'known-namespace=
s' (requested pids)
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 =A0 =A0 =A0 =A0- 0 in the last entry (for =
CLONE_NEWPID).
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 j =3D knum_pids - unum_pids;
> + =A0 =A0 =A0 size =3D unum_pids * sizeof(pid_t);
> +
> + =A0 =A0 =A0 rc =3D copy_from_user(&target_pids[j], upids, size);
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EFAULT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return target_pids;
> +
> +out_free:
> + =A0 =A0 =A0 kfree(target_pids);
> + =A0 =A0 =A0 return ERR_PTR(rc);
> +}
> +
> +/*
> =A0* =A0Ok, this is the main fork-routine.
> =A0*
> =A0* It copies the process, and if successful kick-starts
> @@ -1347,7 +1427,7 @@ long do_fork_with_pids(unsigned long clo
> =A0 =A0 =A0 =A0struct task_struct *p;
> =A0 =A0 =A0 =A0int trace =3D 0;
> =A0 =A0 =A0 =A0long nr;
> - =A0 =A0 =A0 pid_t *target_pids =3D NULL;
> + =A0 =A0 =A0 pid_t *target_pids;
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Do some preliminary argument and permissions checking b=
efore we
> @@ -1381,6 +1461,16 @@ long do_fork_with_pids(unsigned long clo
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 target_pids =3D copy_target_pids(num_pids, upids);
> + =A0 =A0 =A0 if (target_pids) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(target_pids))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(target_pids);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr =3D -EPERM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!capable(CAP_SYS_ADMIN))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * When called from kernel_thread, don't do user tracing s=
tuff.
> =A0 =A0 =A0 =A0 */
> @@ -1442,6 +1532,10 @@ long do_fork_with_pids(unsigned long clo
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr =3D PTR_ERR(p);
> =A0 =A0 =A0 =A0}
> +
> +out_free:
> + =A0 =A0 =A0 kfree(target_pids);
> +
> =A0 =A0 =A0 =A0return nr;
> =A0}
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



-- =

Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
