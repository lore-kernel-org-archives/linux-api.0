From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: [SCHED_DEADLINE man pages 1/2] sched_setattr.2
Date: Tue, 13 May 2014 16:57:36 +0200
Message-ID: <537232E0.4020202@gmail.com>
References: <53723235.40101@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040601020709070106020502"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53723235.40101@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: mtk.manpages@gmail.com, Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>, lkml <linux-kernel@vger.kernel.org>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------040601020709070106020502
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Peter et al.

Here is the sched_attr.2 page as rendered text, with the 
raw page source attached. Please carefully review.

Cheers,

Michael


NAME
       sched_setattr,  sched_getattr  -  set and get scheduling policy
       and attributes

SYNOPSIS
       #include <sched.h>

       int sched_setattr(pid_t pid, const struct sched_attr *attr,
                         unsigned int flags);

       int sched_getattr(pid_t pid, const struct sched_attr *attr,
                         unsigned int size, unsigned int flags);

DESCRIPTION
   sched_setattr()
       The sched_setattr() system call sets the scheduling policy  and
       associated  attributes  for the thread whose ID is specified in
       pid.  If pid equals zero, the scheduling policy and  attributes
       of the calling thread will be set.

       Currently,  Linux  supports  the following "normal" (i.e., non-
       real-time) scheduling policies as values that may be  specified
       in policy:

       SCHED_OTHER   the standard round-robin time-sharing policy;

       SCHED_BATCH   for "batch" style execution of processes; and

       SCHED_IDLE    for running very low priority background jobs.

       Various  "real-time"  policies  are also supported, for special
       time-critical applications that need precise control  over  the
       way  in which runnable threads are selected for execution.  For
       the rules governing when a process may use these policies,  see
       sched(7).  The real-time policies that may be specified in pol‐
       icy are:

       SCHED_FIFO    a first-in, first-out policy; and

       SCHED_RR      a round-robin policy.

       Linux also provides the following policy:

       SCHED_DEADLINE
                     a deadline scheduling policy;  see  sched(7)  for
                     details.

       The  attr argument is a pointer to a structure that defines the
       new scheduling policy and attributes for the specified  thread.
       This structure has the following form:

           struct sched_attr {
               u32 size;              /* Size of this structure */
               u32 sched_policy;      /* Policy (SCHED_*) */
               u64 sched_flags;       /* Flags */
               s32 sched_nice;        /* Nice value (SCHED_OTHER,
                                         SCHED_BATCH) */
               u32 sched_priority;    /* Static priority (SCHED_FIFO,
                                         SCHED_RR) */
               /* Remaining fields are for SCHED_DEADLINE */
               u64 sched_runtime;
               u64 sched_deadline;
               u64 sched_period;
           };

       The fields of this structure are as follows:

       size   This field should be set to the size of the structure in
              bytes, as in sizeof(struct sched_attr).  If the provided
              structure  is  smaller  than  the  kernel structure, any
              additional fields are assumed to be '0'.   If  the  pro‐
              vided structure is larger than the kernel structure, the
              kernel verifies that all additional  fields  are  0;  if
              they are not, sched_setattr() fails with the error E2BIG
              and updates size to  contain  the  size  of  the  kernel
              structure.

              The  above  behavior  when  the  size  of the user-space
              sched_attr structure does not match the size of the ker‐
              nel  structure  allows  for  future extensibility of the
              interface.  Malformed applications  that  pass  oversize
              structures  won't break in the future if the size of the
              kernel  sched_attr  structure  is  increased.   In   the
              future, it could also allow applications that know about
              a larger user-space sched_attr  structure  to  determine
              whether  they  are  running on an older kernel that does
              not support the larger structure.

       sched_policy
              This field specifies the scheduling policy,  as  one  of
              the SCHED_* values listed above.

       sched_flags
              This  field contains flags controlling scheduling behav‐
              ior.   Only  one  such  flag   is   currently   defined:
              SCHED_FLAG_RESET_ON_FORK.  As a result of including this
              flag, children created by fork(2) do not inherit  privi‐
              leged scheduling policies.  See sched(7) for details.

       sched_nice
              This field specifies the nice value to be set when spec‐
              ifying sched_policy as SCHED_OTHER or SCHED_BATCH.   The
              nice  value is a number in the range -20 (high priority)
              to +19 (low priority); see setpriority(2).

       sched_priority
              This field specifies the static priority to be set  when
              specifying  sched_policy as SCHED_FIFO or SCHED_RR.  The
              allowed range of priorities for these  policies  can  be
              determined     using    sched_get_priority_min(2)    and
              sched_get_priority_max(2).   For  other  policies,  this
              field must be specified as 0.

       sched_runtime
              This  field  specifies the "Runtime" parameter for dead‐
              line scheduling.  The value is expressed in nanoseconds.
              This  field,  and the next two fields, are used only for
              SCHED_DEADLINE  scheduling;  for  further  details,  see
              sched(7).

       sched_deadline
              This  field specifies the "Deadline" parameter for dead‐
              line scheduling.  The value is expressed in nanoseconds.

       sched_period
              This field specifies the "Period" parameter for deadline
              scheduling.  The value is expressed in nanoseconds.

       The  flags  argument is provided to allow for future extensions
       to the interface; in the  current  implementation  it  must  be
       specified as 0.

   sched_getattr()
       The  sched_getattr()  system call fetches the scheduling policy
       and the associated attributes for the thread whose ID is speci‐
       fied  in  pid.   If  pid equals zero, the scheduling policy and
       attributes of the calling thread will be retrieved.

       The size argument should be set to the size of  the  sched_attr
       structure  as  known to user space.  The value must be at least
       as large as the size  of  the  initially  published  sched_attr
       structure, or the call fails with the error EINVAL.

       The retrieved scheduling attributes are placed in the fields of
       the sched_attr structure pointed to by attr.  The  kernel  sets
       attr.size to the size of its sched_attr structure.

       If  the caller-provided attr buffer is larger than the kernel's
       sched_attr structure, the additional bytes  in  the  user-space
       structure are not touched.  If the caller-provided structure is
       smaller than the kernel sched_attr  structure  and  the  kernel
       needs   to   return   values   outside   the   provided  space,
       sched_getattr()  fails  with  the   error   E2BIG.    As   with
       sched_setattr(), these semantics allow for future extensibility
       of the interface.

       The flags argument is provided to allow for  future  extensions
       to  the  interface;  in  the  current implementation it must be
       specified as 0.

RETURN VALUE
       On success, sched_setattr() and sched_getattr() return  0.   On
       error,  -1  is returned, and errno is set to indicate the cause
       of the error.

ERRORS
       sched_getattr() and sched_setattr() can both fail for the  fol‐
       lowing reasons:

       EINVAL attr is NULL; or pid is negative; or flags is not zero.

       ESRCH  The thread whose ID is pid could not be found.

       In  addition,  sched_getattr()  can fail for the following rea‐
       sons:

       E2BIG  The buffer specified by size and attr is too small.

       EINVAL size is invalid; that is, it is smaller than the initial
              version of the sched_attr structure (48 bytes) or larger
              than the system page size.

       In addition, sched_setattr() can fail for  the  following  rea‐
       sons:

       E2BIG  The buffer specified by size and attr is larger than the
              kernel structure, and one or more of the excess bytes is
              nonzero.

       EBUSY  SCHED_DEADLINE admission control failure, see sched(7).

       EINVAL attr.sched_policy is not one of the recognized policies;
              attr.sched_flags   contains   a    flag    other    than
              SCHED_FLAG_RESET_ON_FORK;   or   attr.sched_priority  is
              invalid; or attr.sched_policy is SCHED_DEADLINE and  the
              deadline scheduling parameters in attr are invalid.

       EPERM  The caller does not have appropriate privileges.

       EPERM  The caller's CPU affinity mask does not include all CPUs
              in the system (see sched_setaffinity(2)).

VERSIONS
       These system calls first appeared in Linux 3.14.

CONFORMING TO
       These system calls are nonstandard Linux extensions.

NOTES
       sched_setattr() provides a superset  of  the  functionality  of
       sched_setscheduler(2),  sched_setparam(2),  nice(2), and (other
       than the ability to set the priority of all processes belonging
       to a specified user or all processes in a specified group) set‐
       priority(2).  Analogously, sched_getattr() provides a  superset
       of   the  functionality  of  sched_getscheduler(2),  sched_get‐
       param(2), and (partially) getpriority(2).

BUGS
       In Linux versions up to 3.15, sched_settattr() failed with  the
       error EFAULT instead of E2BIG for the case described in ERRORS.

SEE ALSO
       nice(2), sched_get_priority_max(2), sched_get_priority_min(2),
       sched_getaffinity(2), sched_getscheduler(2), sched_getparam(2),
       sched_rr_get_interval(2), sched_setaffinity(2),
       sched_setscheduler(2), sched_setparam(2), sched_yield(2),
       setpriority(2), pthread_getschedparam(3),
       pthread_setschedparam(3), pthread_setschedprio(3),
       capabilities(7), cpuset(7), sched(7)

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--------------040601020709070106020502
Content-Type: application/x-troff-man;
 name="sched_setattr.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sched_setattr.2"

.\" Copyright (C) 2014 Michael Kerrisk <mtk.manpages@gmail.com>
.\" and Copyright (C) 2014 Peter Zijlstra <peterz@infradead.org>
.\"
.\" %%%LICENSE_START(VERBATIM)
.\" Permission is granted to make and distribute verbatim copies of this
.\" manual provided the copyright notice and this permission notice are
.\" preserved on all copies.
.\"
.\" Permission is granted to copy and distribute modified versions of this
.\" manual under the conditions for verbatim copying, provided that the
.\" entire resulting derived work is distributed under the terms of a
.\" permission notice identical to this one.
.\"
.\" Since the Linux kernel and libraries are constantly changing, this
.\" manual page may be incorrect or out-of-date.  The author(s) assume no
.\" responsibility for errors or omissions, or for damages resulting from
.\" the use of the information contained herein.  The author(s) may not
.\" have taken the same level of care in the production of this manual,
.\" which is licensed free of charge, as they might when working
.\" professionally.
.\"
.\" Formatted or processed versions of this manual, if unaccompanied by
.\" the source, must acknowledge the copyright and authors of this work.
.\" %%%LICENSE_END
.\"
.TH SCHED_SETATTR 2 2014-05-09 "Linux" "Linux Programmer's Manual"
.SH NAME
sched_setattr, sched_getattr \-
set and get scheduling policy and attributes
.SH SYNOPSIS
.nf
.B #include <sched.h>

.BI "int sched_setattr(pid_t " pid ", const struct sched_attr *" attr ,
.BI "                  unsigned int " flags );

.BI "int sched_getattr(pid_t " pid ", const struct sched_attr *" attr ,
.BI "                  unsigned int " size ", unsigned int " flags );
.fi
.\" FIXME Add feature test macro requirements
.SH DESCRIPTION
.SS sched_setattr()
The
.BR sched_setattr ()
system call sets the scheduling policy and
associated attributes for the thread whose ID is specified in
.IR pid .
If
.I pid
equals zero,
the scheduling policy and attributes of the calling thread will be set.

Currently, Linux supports the following "normal"
(i.e., non-real-time) scheduling policies as values that may be specified in
.IR policy :
.TP 14
.BR SCHED_OTHER
the standard round-robin time-sharing policy;
.\" In the 2.6 kernel sources, SCHED_OTHER is actually called
.\" SCHED_NORMAL.
.TP
.BR SCHED_BATCH
for "batch" style execution of processes; and
.TP
.BR SCHED_IDLE
for running
.I very
low priority background jobs.
.PP
Various "real-time" policies are also supported,
for special time-critical applications that need precise control over
the way in which runnable threads are selected for execution.
For the rules governing when a process may use these policies, see
.BR sched (7).
The real-time policies that may be specified in
.IR policy
are:
.TP 14
.BR SCHED_FIFO
a first-in, first-out policy; and
.TP
.BR SCHED_RR
a round-robin policy.
.PP
Linux also provides the following policy:
.TP 14
.B SCHED_DEADLINE
a deadline scheduling policy; see
.BR sched (7)
for details.
.PP
The
.I attr
argument is a pointer to a structure that defines
the new scheduling policy and attributes for the specified thread.
This structure has the following form:

.in +4n
.nf
struct sched_attr {
    u32 size;              /* Size of this structure */
    u32 sched_policy;      /* Policy (SCHED_*) */
    u64 sched_flags;       /* Flags */
    s32 sched_nice;        /* Nice value (SCHED_OTHER,
                              SCHED_BATCH) */
    u32 sched_priority;    /* Static priority (SCHED_FIFO,
                              SCHED_RR) */
    /* Remaining fields are for SCHED_DEADLINE */
    u64 sched_runtime;
    u64 sched_deadline;
    u64 sched_period;
};
.fi
.in

The fields of this structure are as follows:
.TP
.B size
This field should be set to the size of the structure in bytes, as in
.IR "sizeof(struct sched_attr)" .
If the provided structure is smaller than the kernel structure,
any additional fields are assumed to be '0'.
If the provided structure is larger than the kernel structure,
the kernel verifies that all additional fields are 0;
if they are not,
.BR sched_setattr ()
fails with the error
.BR E2BIG
and updates
.I size
to contain the size of the kernel structure.
.IP
The above behavior when the size of the user-space
.I sched_attr
structure does not match the size of the kernel structure
allows for future extensibility of the interface.
Malformed applications that pass oversize structures
won't break in the future if the size of the kernel
.I sched_attr
structure is increased.
In the future,
it could also allow applications that know about a larger user-space
.I sched_attr
structure to determine whether they are running on an older kernel
that does not support the larger structure.
.TP
.I sched_policy
This field specifies the scheduling policy, as one of the
.BR SCHED_*
values listed above.
.TP
.I sched_flags
This field contains flags controlling scheduling behavior.
Only one such flag is currently defined:
.BR SCHED_FLAG_RESET_ON_FORK .
As a result of including this flag, children created by
.BR fork (2)
do not inherit privileged scheduling policies.
See
.BR sched (7)
for details.
.TP
.I sched_nice
This field specifies the nice value to be set when specifying
.IR sched_policy
as
.BR SCHED_OTHER
or
.BR SCHED_BATCH .
The nice value is a number in the range \-20 (high priority)
to +19 (low priority); see
.BR setpriority (2).
.TP
.I sched_priority
This field specifies the static priority to be set when specifying
.IR sched_policy
as
.BR SCHED_FIFO
or
.BR SCHED_RR .
The allowed range of priorities for these policies can be determined using
.BR sched_get_priority_min (2)
and
.BR sched_get_priority_max (2).
For other policies, this field must be specified as 0.
.TP
.I sched_runtime
This field specifies the "Runtime" parameter for deadline scheduling.
The value is expressed in nanoseconds.
This field, and the next two fields,
are used only for
.BR SCHED_DEADLINE 
scheduling; for further details, see
.BR sched (7).
.TP
.I sched_deadline
This field specifies the "Deadline" parameter for deadline scheduling.
The value is expressed in nanoseconds.
.TP
.I sched_period
This field specifies the "Period" parameter for deadline scheduling.
The value is expressed in nanoseconds.
.PP
The
.I flags
argument is provided to allow for future extensions to the interface;
in the current implementation it must be specified as 0.
.\"
.\"
.SS sched_getattr()
The
.BR sched_getattr ()
system call fetches the scheduling policy and the
associated attributes for the thread whose ID is specified in
.IR pid .
If
.I pid
equals zero,
the scheduling policy and attributes of the calling thread
will be retrieved.

The
.I size
argument should be set to the size of the
.I sched_attr
structure as known to user space.
The value must be at least as large as the size of the initially published
.I sched_attr
structure, or the call fails with the error
.BR EINVAL .

The retrieved scheduling attributes are placed in the fields of the
.I sched_attr
structure pointed to by
.IR attr .
The kernel sets
.I attr.size
to the size of its
.I sched_attr
structure.

If the caller-provided
.I attr
buffer is larger than the kernel's
.I sched_attr
structure,
the additional bytes in the user-space structure are not touched.
If the caller-provided structure is smaller than the kernel
.I sched_attr
structure and the kernel needs to return values outside the provided space,
.BR sched_getattr ()
fails with the error
.BR E2BIG .
As with
.BR sched_setattr (),
these semantics allow for future extensibility of the interface.

The
.I flags
argument is provided to allow for future extensions to the interface;
in the current implementation it must be specified as 0.
.SH RETURN VALUE
On success,
.BR sched_setattr ()
and
.BR sched_getattr ()
return 0.
On error, \-1 is returned, and
.I errno
is set to indicate the cause of the error.
.SH ERRORS
.BR sched_getattr ()
and
.BR sched_setattr ()
can both fail for the following reasons:
.TP
.B EINVAL
.I attr
is NULL; or
.I pid
is negative; or
.I flags
is not zero.
.TP
.B ESRCH
The thread whose ID is
.I pid
could not be found.
.PP
In addition,
.BR sched_getattr ()
can fail for the following reasons:
.TP
.B E2BIG
The buffer specified by
.I size
and
.I attr
is too small.
.TP
.B EINVAL
.I size
is invalid; that is, it is smaller than the initial version of the
.I sched_attr
structure (48 bytes) or larger than the system page size.
.PP
In addition,
.BR sched_setattr ()
can fail for the following reasons:
.TP
.B E2BIG
The buffer specified by
.I size
and
.I attr
is larger than the kernel structure,
and one or more of the excess bytes is nonzero.
.TP
.B EBUSY
.B SCHED_DEADLINE
admission control failure, see
.BR sched (7).
.TP
.B EINVAL
.I attr.sched_policy
is not one of the recognized policies;
.I attr.sched_flags
contains a flag other than
.BR SCHED_FLAG_RESET_ON_FORK ;
or
.I attr.sched_priority
is invalid; or
.I attr.sched_policy
is
.BR SCHED_DEADLINE
and the deadline scheduling parameters in
.I attr
are invalid.
.TP
.B EPERM
The caller does not have appropriate privileges.
.TP
.B EPERM
The caller's CPU affinity mask
does not include all CPUs in the system
(see
.BR sched_setaffinity (2)).
.SH VERSIONS
These system calls first appeared in Linux 3.14.
.\" FIXME Add glibc version
.SH CONFORMING TO
These system calls are nonstandard Linux extensions.
.SH NOTES
.BR sched_setattr ()
provides a superset of the functionality of
.BR sched_setscheduler (2),
.BR sched_setparam (2),
.BR nice (2),
and (other than the ability to set the priority of all processes
belonging to a specified user or all processes in a specified group)
.BR setpriority (2).
Analogously,
.BR sched_getattr()
provides a superset of the functionality of
.BR sched_getscheduler (2),
.BR sched_getparam (2),
and (partially)
.BR getpriority (2).
.SH BUGS
In Linux versions up to
.\" FIXME patch sent to Peter Zijlstra
3.15,
.BR sched_settattr ()
failed with the error
.BR EFAULT
instead of
.BR E2BIG
for the case described in ERRORS.
.\" In Linux versions up to up 3.15,
.\" .\" FIXME patch from Peter Zijlstra pending
.\" .BR sched_setattr ()
.\" allowed a negative
.\" .I attr.sched_policy
.\" value.
.SH SEE ALSO
.ad l
.nh
.BR nice (2),
.BR sched_get_priority_max (2),
.BR sched_get_priority_min (2),
.BR sched_getaffinity (2),
.BR sched_getscheduler (2),
.BR sched_getparam (2),
.BR sched_rr_get_interval (2),
.BR sched_setaffinity (2),
.BR sched_setscheduler (2),
.BR sched_setparam (2),
.BR sched_yield (2),
.BR setpriority (2),
.BR pthread_getschedparam (3),
.BR pthread_setschedparam (3),
.BR pthread_setschedprio (3),
.BR capabilities (7),
.BR cpuset (7),
.BR sched (7)
.ad

--------------040601020709070106020502--
