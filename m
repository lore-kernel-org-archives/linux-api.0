From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH ghak90 (was ghak32) V3 00/10] audit: implement container identifier
Date: Wed,  6 Jun 2018 12:58:27 -0400
Message-ID: <cover.1528304203.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Implement kernel audit container identifier.

This patchset is a third based on the proposal document (V3)
posted:
	https://www.redhat.com/archives/linux-audit/2018-January/msg00014.html

The first patch implements the proc fs write to set the audit container
identifier of a process, emitting an AUDIT_CONTAINER_ID record to announce the
registration of that audit container identifier on that process.  This patch
requires userspace support for record acceptance and proper type
display.

The second implements the auxiliary record AUDIT_CONTAINER if an
audit container identifier is identifiable with an event.  This patch
requires userspace support for proper type display.

The third adds signal and ptrace support.

The 4th creates a local audit context to be able to bind a standalone
record with a locally created auxiliary record.

The 5th patch adds audit container identifier records to the tty
standalone record.

The 6th adds audit container identifier filtering to the exit,
exclude and user lists.  This patch adds the AUDIT_CONTID field and
requires auditctl userspace support for the --contid option.

The 7th adds network namespace audit container identifier labelling
based on member tasks' audit container identifier labels.

The 8th adds audit container identifier support to standalone netfilter
records that don't have a task context and lists each container to which
that net namespace belongs.

The 9th implements reading the audit container identifier from the proc
filesystem for debugging.  This patch isn't planned for upstream
inclusion.

The 10th fixes an rfkill spelling mistake in a comment that is otherwise
the only match for "contid" in the kernel.


Example: Set an audit container identifier of 123456 to the "sleep" task:

  sleep 2&  
  child=$!
  echo 123456 > /proc/$child/audit_containerid; echo $?
  ausearch -ts recent -m container
  echo child:$child contid:$( cat /proc/$child/audit_containerid)

This should produce a record such as:

  type=CONTAINER_ID msg=audit(2018-06-06 12:39:29.636:26949) : op=set opid=2209 old-contid=18446744073709551615 contid=123456 pid=628 auid=root uid=root tty=ttyS0 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 comm=bash exe=/usr/bin/bash res=yes 


Example: Set a filter on an audit container identifier 123459 on /tmp/tmpcontainerid:

  contid=123459
  key=tmpcontainerid
  auditctl -a exit,always -F dir=/tmp -F perm=wa -F contid=$contid -F key=$key
  perl -e "sleep 1; open(my \$tmpfile, '>', \"/tmp/$key\"); close(\$tmpfile);" &
  child=$!
  echo $contid > /proc/$child/audit_containerid
  sleep 2
  ausearch -i -ts recent -k $key
  auditctl -d exit,always -F dir=/tmp -F perm=wa -F contid=$contid -F key=$key
  rm -f /tmp/$key

This should produce an event such as:

  type=CONTAINER msg=audit(2018-06-06 12:46:31.707:26953) : op=task contid=123459 
  type=PROCTITLE msg=audit(2018-06-06 12:46:31.707:26953) : proctitle=perl -e sleep 1; open(my $tmpfile, '>', "/tmp/tmpcontainerid"); close($tmpfile); 
  type=PATH msg=audit(2018-06-06 12:46:31.707:26953) : item=1 name=/tmp/tmpcontainerid inode=25656 dev=00:26 mode=file,644 ouid=root ogid=root rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE cap_fp=none cap_fi=none cap_fe=0 cap_fver=0 
  type=PATH msg=audit(2018-06-06 12:46:31.707:26953) : item=0 name=/tmp/ inode=8985 dev=00:26 mode=dir,sticky,777 ouid=root ogid=root rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype=PARENT cap_fp=none cap_fi=none cap_fe=0 cap_fver=0 
  type=CWD msg=audit(2018-06-06 12:46:31.707:26953) : cwd=/root 
  type=SYSCALL msg=audit(2018-06-06 12:46:31.707:26953) : arch=x86_64 syscall=openat success=yes exit=3 a0=0xffffffffffffff9c a1=0x5621f2b81900 a2=O_WRONLY|O_CREAT|O_TRUNC a3=0x1b6 items=2 ppid=628 pid=2232 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=perl exe=/usr/bin/perl subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=tmpcontainerid 


Requires: https://github.com/linux-audit/audit-kernel/issues/81
See: https://github.com/linux-audit/audit-kernel/issues/90
See: https://github.com/linux-audit/audit-userspace/issues/40
See: https://github.com/linux-audit/audit-testsuite/issues/64
See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID

Changelog:

v3
- switched from containerid in task_struct to audit_task_info (depends on ghak81)
- drop INVALID_CID in favour of only AUDIT_CID_UNSET
- check for !audit_task_info, throw -ENOPROTOOPT on set
- changed -EPERM to -EEXIST for parent check
- return AUDIT_CID_UNSET if !audit_enabled
- squash child/thread check patch into AUDIT_CONTAINER_ID patch
- changed -EPERM to -EBUSY for child check
- separate child and thread checks, use -EALREADY for latter
- move addition of op= from ptrace/signal patch to AUDIT_CONTAINER patch
- fix && to || bashism in ptrace/signal patch
- uninline and export function for audit_free_context()
- drop CONFIG_CHANGE, FEATURE_CHANGE, ANOM_ABEND, ANOM_SECCOMP patches
- move audit_enabled check (xt_AUDIT)
- switched from containerid list in struct net to net_generic's struct audit_net
- move containerid list iteration into audit (xt_AUDIT)
- create function to move namespace switch into audit
- switched /proc/PID/ entry from containerid to audit_containerid
- call kzalloc with GFP_ATOMIC on in_atomic() in audit_alloc_context()
- call kzalloc with GFP_ATOMIC on in_atomic() in audit_log_container_info()
- use xt_net(par) instead of sock_net(skb->sk) to get net
- switched record and field names: initial CONTAINER_ID, aux CONTAINER, field CONTID
- allow to set own contid
- open code audit_set_containerid
- add contid inherited flag
- ccontainerid and pcontainerid eliminated due to inherited flag
- change name of container list funcitons
- rename containerid to contid
- convert initial container record to syscall aux
- fix spelling mistake of contidion in net/rfkill/core.c to avoid contid name collision

v2
- add check for children and threads
- add network namespace container identifier list
- add NETFILTER_PKT audit container identifier logging
- patch description and documentation clean-up and example
- reap unused ppid

Richard Guy Briggs (10):
  audit: add container id
  audit: log container info of syscalls
  audit: add containerid support for ptrace and signals
  audit: add support for non-syscall auxiliary records
  audit: add containerid support for tty_audit
  audit: add containerid filtering
  audit: add support for containerid to network namespaces
  audit: NETFILTER_PKT: record each container ID associated with a netNS
  debug audit: read container ID of a process
  rfkill: fix spelling mistake contidion to condition

 drivers/tty/tty_audit.c    |   5 +-
 fs/proc/base.c             |  53 +++++++++++++++++++
 include/linux/audit.h      |  68 ++++++++++++++++++++++++
 include/uapi/linux/audit.h |   8 ++-
 kernel/audit.c             | 114 ++++++++++++++++++++++++++++++++++++++++
 kernel/audit.h             |   3 ++
 kernel/auditfilter.c       |  47 +++++++++++++++++
 kernel/auditsc.c           | 128 ++++++++++++++++++++++++++++++++++++++++++---
 kernel/nsproxy.c           |   4 ++
 net/netfilter/xt_AUDIT.c   |  12 ++++-
 net/rfkill/core.c          |   2 +-
 11 files changed, 433 insertions(+), 11 deletions(-)

-- 
1.8.3.1
