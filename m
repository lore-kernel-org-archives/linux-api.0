From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH V1 00/12] audit: implement container id
Date: Thu,  1 Mar 2018 14:41:03 -0500
Message-ID: <cover.1519930146.git.rgb@redhat.com>
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
Cc: mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, madzcar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Implement audit kernel container ID.

This patchset is a preliminary RFC based on the proposal document (V3)
posted:
	https://www.redhat.com/archives/linux-audit/2018-January/msg00014.html

The first patch implements the proc fs write to set the audit container
ID of a process, emitting an AUDIT_CONTAINER record.

The second implements an auxiliary syscall record AUDIT_CONTAINER_INFO
if a container ID is present on a task.

The third adds filtering to the exit, exclude and user lists.

The 4th, implements reading the container ID from the proc filesystem
for debugging.  This isn't planned for upstream inclusion.

The 5th adds signal and ptrace support.

The 6th attempts to create a local audit context to be able to bind a
standalone record with the container ID record.

The 7th, 8th, 9th, 10th patches add container ID records to standalone
records.  Some of these may end up being syscall auxiliary records and
won't need this specific support since they'll be supported via
syscalls.

The 11th is a temporary workaround due to the AUDIT_CONTAINER records
not showing up as do AUDIT_LOGIN records.  I suspect this is due to its
range (1000 vs 1300), but the intent is to solve it.

The 12th adds debug information not intended for upstream for those
brave souls wanting to tinker with it in this early state.

Feedback please!

Here's a quick and dirty test script:
echo 123455 > /proc/$$/containerid; echo $?
sleep 4&  
child=$!; sleep 1
echo 18446744073709551615 > /proc/$child/containerid; echo $?
echo 123456 > /proc/$child/containerid; echo $?
echo 123457 > /proc/$child/containerid; echo $?
sleep 1
ausearch -ts recent |grep " contid=18446744073709551615"; echo $?
ausearch -ts recent |grep " contid=123456"; echo $?
ausearch -ts recent |grep " contid=123457"; echo $?
echo self:$$ contid:$( cat /proc/$$/containerid)
echo child:$child contid:$( cat /proc/$child/containerid)

containerid=123458
key=tmpcontainerid
auditctl -a exit,always -F dir=/tmp -F perm=wa -F containerid=$containerid -F key=$key || echo failed to add containerid filter rule
bash -c "sleep 1; echo test > /tmp/$key"&
child=$!
echo $containerid > /proc/$child/containerid
sleep 2
rm -f /tmp/$key
ausearch -ts recent -k $key || echo failed to find CONTAINER_INFO record
auditctl -d exit,always -F dir=/tmp -F perm=wa -F containerid=$containerid -F key=$key || echo failed to add containerid filter rule

See:
	https://github.com/linux-audit/audit-kernel/issues/32
	https://github.com/linux-audit/audit-userspace/issues/40
	https://github.com/linux-audit/audit-testsuite/issues/64

Richard Guy Briggs (12):
  audit: add container id
  audit: log container info of syscalls
  audit: add containerid filtering
  audit: read container ID of a process
  audit: add containerid support for ptrace and signals
  audit: add support for non-syscall auxiliary records
  audit: add container aux record to watch/tree/mark
  audit: add containerid support for tty_audit
  audit: add containerid support for config/feature/user records
  audit: add containerid support for seccomp and anom_abend records
  debug audit: add container id
  debug! audit: add container id

 drivers/tty/tty_audit.c    |   5 +-
 fs/proc/base.c             |  63 +++++++++++++++++++
 include/linux/audit.h      |  36 +++++++++++
 include/linux/init_task.h  |   4 +-
 include/linux/sched.h      |   1 +
 include/uapi/linux/audit.h |   9 ++-
 kernel/audit.c             |  74 +++++++++++++++++++---
 kernel/audit.h             |   3 +
 kernel/audit_fsnotify.c    |   5 +-
 kernel/audit_tree.c        |   5 +-
 kernel/audit_watch.c       |  33 +++++-----
 kernel/auditfilter.c       |  52 ++++++++++++++-
 kernel/auditsc.c           | 154 +++++++++++++++++++++++++++++++++++++++++++--
 13 files changed, 408 insertions(+), 36 deletions(-)

-- 
1.8.3.1
