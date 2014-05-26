From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 0/6] namespaces: log namespaces per task
Date: Mon, 26 May 2014 12:58:58 -0400
Message-ID: <20140526165858.GC8079@madcap2.tricolour.ca>
References: <cover.1400271129.git.rgb@redhat.com>
	<CAHO5Pa0EdUsV9jJuLbkmbvFyopecQiUDZd0UasAJ5kMhtsVxjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHO5Pa0EdUsV9jJuLbkmbvFyopecQiUDZd0UasAJ5kMhtsVxjQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 14/05/22, Michael Kerrisk wrote:
> Richard,

Hi Michael,

> On Tue, May 20, 2014 at 3:12 PM, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > The purpose is to track namespaces in use by logged processes from the
> > perspective of init_*_ns.
> >
> > 1/6 defines a function to generate them and assigns them.
> >
> > Use a serial number per namespace (unique across one boot of one kernel)
> > instead of the inode number (which is claimed to have had the right to change
> > reserved and is not necessarily unique if there is more than one proc fs).  It
> > could be argued that the inode numbers have now become a defacto interface and
> > can't change now, but I'm proposing this approach to see if this helps address
> > some of the objections to the earlier patchset.
> >
> > 2/6 adds access functions to get to the serial numbers in a similar way to
> > inode access for namespace proc operations.
> >
> > 3/6 implements, as suggested by Serge Hallyn, making these serial numbers
> > available in /proc/self/ns/{ipc,mnt,net,pid,user,uts}_snum.  I chose "snum"
> > instead of "seq" for consistency with inum and there are a number of other uses
> > of "seq" in the namespace code.
> >
> > 4/6 exposes proc's ns entries structure which lists a number of useful
> > operations per namespace type for other subsystems to use.
> 
> Since the 3 and 4 change the ABI, please CC iterations of this patch
> series to linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, as per Documentation/SubmitChecklist.

Neither patch 3/6 nor 4/6 changes the syscall interface.

Patch 3/6 adds /proc/<pid>/ns/ entries, which looks more like #16 in
that document (for which /proc/<pid>/ns/<nstype> was never added).

Patch 4/6 adds internel kernel symbols which are never exposed to the
user.

Perhaps "expose" was the wrong word to use in the patch description.
This usage implies that it is no longer labelled "static" in its source
files to be able to expose that interface to other internal kernel
subsystems.

Ref:
	SubmitChecklist (#16)
	Documentation/stable_api_nonsense.txt
	Documentation/ABI/README

> Michael
> 
> > 5/6 provides an example of usage for audit_log_task_info() which is used by
> > syscall audits, among others.  audit_log_task() and audit_common_recv_message()
> > would be other potential use cases.
> >
> > Proposed output format:
> > This differs slightly from Aristeu's patch because of the label conflict with
> > "pid=" due to including it in existing records rather than it being a seperate
> > record.  The serial numbers are printed in hex.
> >         type=SYSCALL msg=audit(1399651071.433:72): arch=c000003e syscall=272 success=yes exit=0 a0=40000000 a1=ffffffffffffffff a2=0 a3=22 items=0 ppid=1 pid=483 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="(t-daemon)" exe="/usr/lib/systemd/systemd" netns=97 utsns=2 ipcns=1 pidns=4 userns=3 mntns=5 subj=system_u:system_r:init_t:s0 key=(null)
> >
> > 6/6 tracks the creation and deletion of of namespaces, listing the type of
> > namespace instance, related namespace id if there is one and the newly minted
> > serial number.
> >
> > Proposed output format:
> >         type=NS_INIT msg=audit(1400217435.706:94): pid=524 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:mount_t:s0 type=20000 old_snum=0 snum=a1 res=1
> >         type=NS_DEL msg=audit(1400217435.730:95): pid=524 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:mount_t:s0 type=20000 snum=a1 res=1
> >
> >
> > v2 -> v3:
> >         Use atomic64_t in ns_serial to simplify it.
> >         Avoid funciton duplication in proc, keying on dentry.
> >         Squash down audit patch to avoid rcu sleep issues.
> >         Add tracking for creation and deletion of namespace instances.
> >
> > v1 -> v2:
> >         Avoid rollover by switching from an int to a long long.
> >         Change rollover behaviour from simply avoiding zero to raising a BUG.
> >         Expose serial numbers in /proc/<pid>/ns/*_snum.
> >         Expose ns_entries and use it in audit.
> >
> >
> > Notes:
> > There has been some progress made for audit in net namespaces and pid
> > namespaces since this previous thread.  net namespaces are now served as peers
> > by one auditd in the init_net namespace with processes in a non-init_net
> > namespace being able to write records if they are in the init_user_ns and have
> > CAP_AUDIT_WRITE.  Processes in a non-init_pid_ns can now similarly write
> > records.  As for CAP_AUDIT_READ, I just posted a patchset to check capabilities
> > of userspace processes that try to join netlink broadcast groups.
> >
> > This set does not try to solve the non-init namespace audit messages and
> > auditd problem yet.  That will come later, likely with additional auditd
> > instances running in another namespace with a limited ability to influence the
> > master auditd.  I echo Eric B's idea that messages destined for different
> > namespaces would have to be tailored for that namespace with references that
> > make sense (such as the right pid number reported to that pid namespace, and
> > not leaking info about parents or peers).
> >
> > Bugs:
> > Patch 6/6 has a timing bug such that mnt and net namespace initial namespaces
> > never get logged, I suspect because they are initialized before the audit
> > subsystem.  I've tried moving audit from __initcall to subsys_initcall, but
> > that doesn't help.
> >
> > Questions:
> > Is there a way to link serial numbers of namespaces involved in migration of a
> > container to another kernel?  It sounds like what is needed is a part of a
> > mangement application that is able to pull the audit rcords from constituent
> > hosts to build an audit trail of a container.
> >
> > What additional events should list this information?
> >
> > Does this present any problematic information leaks?  Only CAP_AUDIT_CONTROL
> > (and proposed CAP_AUDIT_READ) in init_user_ns can get to this information in
> > the init namespace at the moment from audit.  *However*, the addition of the
> > proc/<pid>/ns/*_snum does make it available to other processes now.
> >
> >
> > Richard Guy Briggs (6):
> >   namespaces: assign each namespace instance a serial number
> >   namespaces: expose namespace instance serial number in proc_ns_operations
> >   namespaces: expose ns instance serial numbers in proc
> >   namespaces: expose ns_entries
> >   audit: log namespace serial numbers
> >   audit: log creation and deletion of namespace instances
> >
> >  fs/mount.h                     |    1 +
> >  fs/namespace.c                 |   12 +++++++++
> >  fs/proc/namespaces.c           |   35 +++++++++++++++++++-------
> >  include/linux/audit.h          |   15 +++++++++++
> >  include/linux/ipc_namespace.h  |    1 +
> >  include/linux/nsproxy.h        |    8 ++++++
> >  include/linux/pid_namespace.h  |    1 +
> >  include/linux/proc_ns.h        |    2 +
> >  include/linux/user_namespace.h |    1 +
> >  include/linux/utsname.h        |    1 +
> >  include/net/net_namespace.h    |    1 +
> >  include/uapi/linux/audit.h     |    2 +
> >  init/version.c                 |    1 +
> >  ipc/msgutil.c                  |    1 +
> >  ipc/namespace.c                |   20 +++++++++++++++
> >  kernel/audit.c                 |   53 +++++++++++++++++++++++++++++++++++++++-
> >  kernel/nsproxy.c               |   17 +++++++++++++
> >  kernel/pid.c                   |    1 +
> >  kernel/pid_namespace.c         |   19 ++++++++++++++
> >  kernel/user.c                  |    1 +
> >  kernel/user_namespace.c        |   18 +++++++++++++
> >  kernel/utsname.c               |   20 +++++++++++++++
> >  net/core/net_namespace.c       |   20 ++++++++++++++-
> >  23 files changed, 240 insertions(+), 11 deletions(-)
> >
> > _______________________________________________
> > Containers mailing list
> > Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> > https://lists.linuxfoundation.org/mailman/listinfo/containers
> 
> 
> 
> -- 
> Michael Kerrisk Linux man-pages maintainer;
> http://www.kernel.org/doc/man-pages/
> Author of "The Linux Programming Interface", http://blog.man7.org/

- RGB

--
Richard Guy Briggs <rbriggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
