From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH ghak32 V2 00/13] audit: implement container id
Date: Fri, 16 Mar 2018 05:00:27 -0400
Message-ID: <cover.1521179281.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-Audit Mailing List <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, madzcar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Implement audit kernel container ID.

This patchset is a second RFC based on the proposal document (V3)
posted:
	https://www.redhat.com/archives/linux-audit/2018-January/msg00014.html

The first patch implements the proc fs write to set the audit container
ID of a process, emitting an AUDIT_CONTAINER record to announce the
registration of that container ID on that process.  This patch requires
userspace support for record acceptance and proper type display.

The second checks for children or co-threads and refuses to set the
container ID if either are present.  (This policy could be changed to
set both with the same container ID provided they meet the rest of the
requirements.)

The third implements the auxiliary record AUDIT_CONTAINER_INFO if a
container ID is identifiable with an event.  This patch requires
userspace support for proper type display.

The fourth adds container ID filtering to the exit, exclude and user
lists.  This patch requires auditctil userspace support for the
--containerid option.

The 5th adds signal and ptrace support.

The 6th creates a local audit context to be able to bind a standalone
record with a locally created auxiliary record.

The 7th, 8th, 9th, 10th patches add container ID records to standalone
records.  Some of these may end up being syscall auxiliary records and
won't need this specific support since they'll be supported via
syscalls.

The 11th adds network namespace container ID labelling based on member
tasks' container ID labels.

The 12th adds container ID support to standalone netfilter records that
don't have a task context and lists each container to which that net
namespace belongs.

The 13th implements reading the container ID from the proc filesystem
for debugging.  This patch isn't planned for upstream inclusion.

Feedback please!

Example: Set a container ID of 123456 to the "sleep" task:
	sleep 2&  
	child=$!
	echo 123456 > /proc/$child/containerid; echo $?
	ausearch -ts recent -m container
	echo child:$child contid:$( cat /proc/$child/containerid)
This should produce a record such as:
	type=CONTAINER msg=audit(1521122590.315:222): op=set pid=689 uid=0 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 auid=0 tty=pts0 ses=3 opid=707 old-contid=18446744073709551615 contid=123456 res=1

Example: Set a filter on a container ID 123459 on /tmp/tmpcontainerid:
	containerid=123459
	key=tmpcontainerid
	auditctl -a exit,always -F dir=/tmp -F perm=wa -F containerid=$containerid -F key=$key
	perl -e "sleep 1; open(my \$tmpfile, '>', \"/tmp/$key\"); close(\$tmpfile);" &
	child=$!
	echo $containerid > /proc/$child/containerid
	sleep 2
	ausearch -i -ts recent -k $key
	auditctl -d exit,always -F dir=/tmp -F perm=wa -F containerid=$containerid -F key=$key
	rm -f /tmp/$key
This should produce an event such as:
	type=CONTAINER_INFO msg=audit(1521122591.614:227): op=task contid=123459
	type=PROCTITLE msg=audit(1521122591.614:227): proctitle=7065726C002D6500736C65657020313B206F70656E286D792024746D7066696C652C20273E272C20222F746D702F746D70636F6E7461696E6572696422293B20636C6F73652824746D7066696C65293B
	type=PATH msg=audit(1521122591.614:227): item=1 name="/tmp/tmpcontainerid" inode=18427 dev=00:26 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
	type=PATH msg=audit(1521122591.614:227): item=0 name="/tmp/" inode=13513 dev=00:26 mode=041777 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype=PARENT cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
	type=CWD msg=audit(1521122591.614:227): cwd="/root"
	type=SYSCALL msg=audit(1521122591.614:227): arch=c000003e syscall=257 success=yes exit=3 a0=ffffffffffffff9c a1=55db90a28900 a2=241 a3=1b6 items=2 ppid=689 pid=724 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=3 comm="perl" exe="/usr/bin/perl" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="tmpcontainerid"

See:
	https://github.com/linux-audit/audit-kernel/issues/32
	https://github.com/linux-audit/audit-userspace/issues/40
	https://github.com/linux-audit/audit-testsuite/issues/64

Richard Guy Briggs (13):
  audit: add container id
  audit: check children and threading before allowing containerid
  audit: log container info of syscalls
  audit: add containerid filtering
  audit: add containerid support for ptrace and signals
  audit: add support for non-syscall auxiliary records
  audit: add container aux record to watch/tree/mark
  audit: add containerid support for tty_audit
  audit: add containerid support for config/feature/user records
  audit: add containerid support for seccomp and anom_abend records
  audit: add support for containerid to network namespaces
  audit: NETFILTER_PKT: record each container ID associated with a netNS
  debug audit: read container ID of a process

 drivers/tty/tty_audit.c     |   5 +-
 fs/proc/base.c              |  53 ++++++++++++++++
 include/linux/audit.h       |  43 +++++++++++++
 include/linux/init_task.h   |   4 +-
 include/linux/sched.h       |   1 +
 include/net/net_namespace.h |  12 ++++
 include/uapi/linux/audit.h  |   8 ++-
 kernel/audit.c              |  75 ++++++++++++++++++++---
 kernel/audit.h              |   3 +
 kernel/audit_fsnotify.c     |   5 +-
 kernel/audit_tree.c         |   5 +-
 kernel/audit_watch.c        |  33 +++++-----
 kernel/auditfilter.c        |  52 +++++++++++++++-
 kernel/auditsc.c            | 145 ++++++++++++++++++++++++++++++++++++++++++--
 kernel/nsproxy.c            |   6 ++
 net/core/net_namespace.c    |  45 ++++++++++++++
 net/netfilter/xt_AUDIT.c    |  15 ++++-
 17 files changed, 473 insertions(+), 37 deletions(-)

-- 
1.8.3.1
