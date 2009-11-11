From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [v12][PATCH 0/9] Implement eclone() syscall
Date: Wed, 11 Nov 2009 14:38:33 -0800
Message-ID: <20091111223833.GA24988@suka>
References: <20091111043440.GA9377@suka>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759553AbZKKWh4@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091111043440.GA9377@suka>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Dobriyan <adobriyan@gmail.com>, Pavel Emelyanov <xemul@openvz.org>, hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, matthltc@suka.localdomain, arnd@arndb.de, roland@redhat.com, mtk.manpages@googlemail.com, linux-api@vger.kernel.org, Containers <containers@lists.linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Cc: LKML

Sukadev Bhattiprolu [sukadev@linux.vnet.ibm.com] wrote:
| 
| Based on discussions on containers mailing list and IRC, we settled on
| the name eclone(). Please let me know of a better name or if there are
| other comments on the patchset.
| 
| ---
| 
| Subject: [v12][PATCH 0/9] Implement eclone() syscall
| 
| To support application checkpoint/restart, a task must have the same pid it
| had when it was checkpointed.  When containers are nested, the tasks within
| the containers exist in multiple pid namespaces and hence have multiple pids
| to specify during restart.
| 
| This patchset implements a new system call, eclone() that lets a process
| specify the pids of the child process.
| 
| Patches 1 through 6 are helper patches needed for choosing a pid for the
| child process.
| 
| PATCH 8 implements the eclone() system call on x86. The interface defined in
| PATCH 8 has been ported to s390 and ppc64 architectures, but they will be
| posted as a separate patchset if this patchset is accepted.
| 
| PATCH 9 adds some documentation on the new system call, some/all of which
| will eventually go into a man page.
| 
| Changelog[v12]:
| 	- Ignore ->child_stack_size when ->child_stack_base is NULL (PATCH 8)
| 	- Cleanup/simplify example in Documentation/eclone (PATCH 9).
| 	- Rename sys call to a shorter name, eclone()
| 
| Changelog[v11]:
| 	- [Dave Hansen] Move clone_args validation checks to arch-indpeendent
| 	  code.
| 	- [Oren Laadan] Make args_size a parameter to system call and remove
| 	  it from 'struct clone_args'
| 
| Changelog[v10]:
| 	- [Linus Torvalds] Use PTREGSCALL() implementation for clone rather
| 	  than the generic system call
| 	- Rename clone3() to clone_with_pids()
| 	- Update Documentation/clone_with_pids() to show example usage with
| 	  the PTREGSCALL implementation.
| 
| Changelog[v9]:
| 	- [Pavel Emelyanov] Drop the patch that made 'pid_max' a property
| 	  of struct pid_namespace
| 	- [Roland McGrath, H. Peter Anvin and earlier on, Serge Hallyn] To
| 	  avoid inadvertent truncation clone_flags, preserve the first
| 	  parameter of clone3() as 'u32 clone_flags' and specify newer
| 	  flags in clone_args.flags_high (PATCH 8/9 and PATCH 9/9)
| 	- [Eric Biederman] Generalize alloc_pidmap() code to simplify and
| 	  remove duplication (see PATCH 3/9].
| 	  
| Changelog[v8]:
| 	- [Oren Laadan, Louis Rilling, KOSAKI Motohiro]
| 	  The name 'clone2()' is in use - renamed new syscall to clone3().
| 	- [Oren Laadan] ->parent_tidptr and ->child_tidptr need to be 64bit.
| 	- [Oren Laadan] Ensure that unused fields/flags in clone_struct are 0.
| 	  (Added [PATCH 7/10] to the patchset).
| 
| Changelog[v7]:
| 	- [Peter Zijlstra, Arnd Bergmann]
| 	  Group the arguments to clone2() into a 'struct clone_arg' to
| 	  workaround the issue of exceeding 6 arguments to the system call.
| 	  Also define clone-flags as u64 to allow additional clone-flags.
| 
| Changelog[v6]:
| 	- [Nathan Lynch, Arnd Bergmann, H. Peter Anvin, Linus Torvalds]
| 	  Change 'pid_set.pids' to 'pid_t pids[]' so sizeof(struct pid_set) is
| 	  constant across architectures (Patches 7, 8).
| 	- (Nathan Lynch) Change pid_set.num_pids to unsigned and remove
| 	  'unum_pids < 0' check (Patches 7,8)
| 	- (Pavel Machek) New patch (Patch 9) to add some documentation.
| 
| Changelog[v5]:
| 	- Make 'pid_max' a property of pid_ns (Integrated Serge Hallyn's patch
| 	  into this set)
| 	- (Eric Biederman): Avoid the new function, set_pidmap() - added
| 	  couple of checks on 'target_pid' in alloc_pidmap() itself.
| 
| === IMPORTANT NOTE:
| 
| clone() system call has another limitation - all but one bits in clone-flags
| are in use and if more new clone-flags are needed, we will need a variant of
| the clone() system call. 
| 
| It appears to make sense to try and extend this new system call to address
| this limitation as well. The requirements of a new clone system call could
| then be summarized as:
| 
| 	- do everything clone() does today, and
| 	- give application an ability to choose pids for the child process
| 	  in all ancestor pid namespaces, and
| 	- allow more clone_flags
| 
| Contstraints:
| 
| 	- system-calls are restricted to 6 parameters and clone() already
| 	  takes 5 parameters, any extension to clone() interface would require
| 	  one or more copy_from_user().  (Not sure if copy_from_user() of ~40
| 	  bytes would have a significant impact on performance of clone()).
| 
| Based on these requirements and constraints, we explored a couple of system
| call interfaces (in earlier versions of this patchset). Based on input from
| Arnd Bergmann and others, the new interface of the system call is: 
| 
| 	struct clone_args {
| 		u64 clone_flags_high;
| 		u64 child_stack_base;
| 		u64 child_stack_size;
| 		u64 parent_tid_ptr;
| 		u64 child_tid_ptr;
| 		u32 nr_pids;
| 		u32 reserved0;
| 		u64 reserved1;
| 	};
| 
| 	sys_eclone(u32 flags_low, struct clone_args *cargs, int args_size,
| 			pid_t *pids)
| 
| Details of the struct clone_args and the usage are explained in the
| documentation (PATCH 9/9).
| 
| NOTE:
| 	While this patchset enables support for more clone-flags, actual
| 	implementation for additional clone-flags is best implemented as
| 	a separate patchset (PATCH 8/9 identifies some TODOs)
| 
| Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
