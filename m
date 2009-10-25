From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [v9][PATCH 0/9] Implement clone3() system call
Date: Sat, 24 Oct 2009 20:35:08 -0700
Message-ID: <20091025033508.GA20327@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, sukadev-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Well, there is been no consensus on the name for the new system call.
Michael Kerrisk did a lot of research on how we named such system calls
trying to identify a convention in the chaos :-) and proposed clonex()
or clone_extended(). Peter Anvin, Oren Laadan and I prefer clone3()
which reflects the number of arguments to the new system call.

Besides that, I believe I have addressed all review comments so far.

The patchset seems to work fine on x86. An earlier version of the patchset
was ported to ppc64 and work is in progress to port this version too.
---

[v9][PATCH 0/9] Implement clone3() system call

To support application checkpoint/restart, a task must have the same pid it
had when it was checkpointed.  When containers are nested, the tasks within
the containers exist in multiple pid namespaces and hence have multiple pids
to specify during restart.

This patchset implements a new system call, clone3() that lets a process
specify the pids of the child process.

Patches 1 through 6 are helper patches needed for choosing a pid for the
child process.

PATCH 8 defines a prototype of the new system call. PATCH 9 adds some
documentation on the new system call, some/all of which will eventually
go into a man page.

Changelog[v9]:
	- [Pavel Emelyanov] Drop the patch that made 'pid_max' a property
	  of struct pid_namespace
	- [Roland McGrath, H. Peter Anvin and earlier on, Serge Hallyn] To
	  avoid inadvertent truncation clone_flags, preserve the first
	  parameter of clone3() as 'u32 clone_flags' and specify newer
	  flags in clone_args.flags_high (PATCH 8/9 and PATCH 9/9)
	- [Eric Biederman] Generalize alloc_pidmap() code to simplify and
	  remove duplication (see PATCH 3/9].
	  
Changelog[v8]:
	- [Oren Laadan, Louis Rilling, KOSAKI Motohiro]
	  The name 'clone2()' is in use - renamed new syscall to clone3().
	- [Oren Laadan] ->parent_tidptr and ->child_tidptr need to be 64bit.
	- [Oren Laadan] Ensure that unused fields/flags in clone_struct are 0.
	  (Added [PATCH 7/10] to the patchset).

Changelog[v7]:
	- [Peter Zijlstra, Arnd Bergmann]
	  Group the arguments to clone2() into a 'struct clone_arg' to
	  workaround the issue of exceeding 6 arguments to the system call.
	  Also define clone-flags as u64 to allow additional clone-flags.

Changelog[v6]:
	- [Nathan Lynch, Arnd Bergmann, H. Peter Anvin, Linus Torvalds]
	  Change 'pid_set.pids' to 'pid_t pids[]' so sizeof(struct pid_set) is
	  constant across architectures (Patches 7, 8).
	- (Nathan Lynch) Change pid_set.num_pids to unsigned and remove
	  'unum_pids < 0' check (Patches 7,8)
	- (Pavel Machek) New patch (Patch 9) to add some documentation.

Changelog[v5]:
	- Make 'pid_max' a property of pid_ns (Integrated Serge Hallyn's patch
	  into this set)
	- (Eric Biederman): Avoid the new function, set_pidmap() - added
	  couple of checks on 'target_pid' in alloc_pidmap() itself.

=== IMPORTANT NOTE:

clone() system call has another limitation - all but one, available bits in
clone-flags are in use and if more new clone-flags are needed, we will need
a variant of the clone() system call. 

It appears to make sense to try and extend this new system call to address
this limitation as well. The requirements of a new clone system call could
then be summarized as:

	- do everything clone() does today, and
	- give application an ability to choose pids for the child process
	  in all ancestor pid namespaces, and
	- allow more clone_flags

Contstraints:

	- system-calls are restricted to 6 parameters and clone() already
	  takes 5 parameters, any extension to clone() interface would require
	  one or more copy_from_user().  (Not sure if copy_from_user() of ~40
	  bytes would have a significant impact on performance of clone()).

Based on these requirements and constraints, we explored a couple of system
call interfaces (in earlier versions of this patchset).  Based on input from
Arnd Bergmann and others, the new interface of the system call is: 

	struct clone_args {
		u64 clone_flags_high;
		u64 child_stack_base;
		u64 child_stack_size;
		u64 parent_tid_ptr;
		u64 child_tid_ptr;
		u32 nr_pids;
		u32 clone_args_size;
		u64 reserved1;
	};

	sys_clone3(u32 flags_low, struct clone_args *cargs, pid_t *pids)

Details of the struct clone_args and the usage are explained in the
documentation (PATCH 9/9).

NOTE:
	While this patchset enables support for more clone-flags, actual
	implementation for additional clone-flags is best implemented as
	a separate patchset (PATCH 8/9 identifies some TODOs)

Signed-off-by: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
