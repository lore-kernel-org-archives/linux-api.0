From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V4 0/8] namespaces: log namespaces per task
Date: Wed, 20 Aug 2014 21:09:33 -0400
Message-ID: <cover.1408581429.git.rgb@redhat.com>
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
To: linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The purpose is to track namespace instances in use by logged processes from the
perspective of init_*_ns by assigning each a per-kernel, per-boot serial
number.

1/8 defines a function to generate them and assigns them.

Use a serial number per namespace (unique across one boot of one kernel)
instead of the inode number (which is claimed to have had the right to change
reserved and is not necessarily unique if there is more than one proc fs).  It
could be argued that the inode numbers have now become a defacto interface and
can't change now, but I'm proposing this approach to see if this helps address
some of the objections to the earlier patchset.

2/8 adds access functions to get to the serial numbers in a similar way to
inode access for namespace proc operations.

3/8 implements, as suggested by Serge Hallyn, making these serial numbers
available in /proc/self/ns/{ipc,mnt,net,pid,user,uts}_snum.  I chose "snum"
instead of "seq" for consistency with inum and there are a number of other uses
of "seq" in the namespace code.

4/8 Document proc's ns entries structure in Documentation/filesystems/proc.txt

5/8 exposes proc's ns entries structure which lists a number of useful
operations per namespace type for other subsystems to use.

6/8 provides an example of usage for audit_log_task_info() which is used by
syscall audits, among others.  audit_log_task() and audit_common_recv_message()
would be other potential use cases.

Proposed output format:
This differs slightly from Aristeu's patch because of the label conflict with
"pid=" due to including it in existing records rather than it being a seperate
record.  It has now returned to being a seperate record.  The serial numbers
are printed in hex.
	type=NS_INFO msg=audit(1408577535.306:82):  netns=8 utsns=2 ipcns=1 pidns=4 userns=3 mntns=5

7/8 tracks the creation and deletion of of namespaces, listing the type of
namespace instance, related namespace id if there is one and the newly minted
serial number.

Proposed output format for initial namespace creation:
	type=AUDIT_NS_INIT_UTS msg=audit(1408577534.868:5): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel old_utsns=0 utsns=2 res=1
	type=AUDIT_NS_INIT_USER msg=audit(1408577534.868:6): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel old_userns=0 userns=3 res=1
	type=AUDIT_NS_INIT_PID msg=audit(1408577534.868:7): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel old_pidns=0 pidns=4 res=1
	type=AUDIT_NS_INIT_MNT msg=audit(1408577534.868:8): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel old_mntns=0 mntns=5 res=1
	type=AUDIT_NS_INIT_IPC msg=audit(1408577534.868:9): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel old_ipcns=0 ipcns=1 res=1
	type=AUDIT_NS_INIT_NET msg=audit(1408577533.500:10): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel old_netns=0 netns=7 res=1

And a CLONE action would result in:
	type=type=AUDIT_NS_INIT_NET msg=audit(1408577535.306:81): pid=481 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 old_netns=7 netns=8 res=1
	type=type=AUDIT_NS_INIT_MNT msg=audit(1408577535.307:83): pid=481 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 old_mntns=5 mntns=9 res=1

While deleting a namespace would result in:
	type=type=AUDIT_NS_DEL_MNT msg=audit(1408577552.221:85): pid=481 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 mntns=9 res=1

8/8 change audit startup from __initcall to subsys_initcall to get it started
earlier to be able to receive initial namespace log messages.


v3 -> v4:
	Seperate out the NS_INFO message from the SYSCALL message.
	Moved audit_log_namespace_info() out of audit_log_task_info().
	Use a seperate message type per namespace type for each of INIT/DEL.
	Make ns= easier to search across NS_INFO and NS_INIT/DEL_XXX msg types.
	Add /proc/<pid>/ns/ documentation.
	Fix dynamic initial ns logging.

v2 -> v3:
	Use atomic64_t in ns_serial to simplify it.
	Avoid funciton duplication in proc, keying on dentry.
	Squash down audit patch to avoid rcu sleep issues.
	Add tracking for creation and deletion of namespace instances.

v1 -> v2:
	Avoid rollover by switching from an int to a long long.
	Change rollover behaviour from simply avoiding zero to raising a BUG.
	Expose serial numbers in /proc/<pid>/ns/*_snum.
	Expose ns_entries and use it in audit.


Notes:
As for CAP_AUDIT_READ, a patchset has been accepted upstream to check
capabilities of userspace processes that try to join netlink broadcast groups.

This set does not try to solve the non-init namespace audit messages and
auditd problem yet.  That will come later, likely with additional auditd
instances running in another namespace with a limited ability to influence the
master auditd.  I echo Eric B's idea that messages destined for different
namespaces would have to be tailored for that namespace with references that
make sense (such as the right pid number reported to that pid namespace, and
not leaking info about parents or peers).

Questions:
Is there a way to link serial numbers of namespaces involved in migration of a
container to another kernel?  It sounds like what is needed is a part of a
mangement application that is able to pull the audit records from constituent
hosts to build an audit trail of a container.

What additional events should list this information?

Does this present any problematic information leaks?  Only CAP_AUDIT_CONTROL
(and now CAP_AUDIT_READ) in init_user_ns can get to this information in
the init namespace at the moment from audit.  *However*, the addition of the
proc/<pid>/ns/*_snum does make it available to other processes now.


Richard Guy Briggs (8):
  namespaces: assign each namespace instance a serial number
  namespaces: expose namespace instance serial number in proc_ns_operations
  namespaces: expose ns instance serial numbers in proc
  Documentation: add a section for /proc/<pid>/ns/
  namespaces: expose ns_entries
  audit: log namespace serial numbers
  audit: log creation and deletion of namespace instances
  audit: initialize at subsystem time rather than device time

 Documentation/filesystems/proc.txt |   16 +++++++
 fs/mount.h                         |    1 +
 fs/namespace.c                     |   20 +++++++++
 fs/proc/namespaces.c               |   35 ++++++++++++----
 include/linux/audit.h              |   15 +++++++
 include/linux/ipc_namespace.h      |    1 +
 include/linux/nsproxy.h            |    8 ++++
 include/linux/pid_namespace.h      |    1 +
 include/linux/proc_ns.h            |    2 +
 include/linux/user_namespace.h     |    1 +
 include/linux/utsname.h            |    1 +
 include/net/net_namespace.h        |    1 +
 include/uapi/linux/audit.h         |   13 ++++++
 init/version.c                     |    1 +
 ipc/msgutil.c                      |    1 +
 ipc/namespace.c                    |   20 +++++++++
 kernel/audit.c                     |   78 +++++++++++++++++++++++++++++++++++-
 kernel/auditsc.c                   |    2 +
 kernel/nsproxy.c                   |   17 ++++++++
 kernel/pid.c                       |    1 +
 kernel/pid_namespace.c             |   19 +++++++++
 kernel/user.c                      |    1 +
 kernel/user_namespace.c            |   20 +++++++++
 kernel/utsname.c                   |   21 ++++++++++
 net/core/net_namespace.c           |   27 ++++++++++++-
 security/integrity/ima/ima_api.c   |    2 +
 26 files changed, 314 insertions(+), 11 deletions(-)
