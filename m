From: Prakash Sangappa <prakash.sangappa@oracle.com>
Subject: [RESEND RFC PATCH 0/1] CAP_SYS_NICE inside user namespace
Date: Mon, 18 Nov 2019 09:01:17 -0800
Message-ID: <1574096478-11520-1-git-send-email-prakash.sangappa@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: ebiederm@xmission.com, tglx@linutronix.de, peterz@infradead.org, serge@hallyn.com, prakash.sangappa@oracle.com
List-Id: linux-api@vger.kernel.org

Some of the capabilities(7) which affect system wide resources, are ineffective
inside user namespaces. This restriction applies even to root user( uid 0)
from init namespace mapped into the user namespace. One such capability
is CAP_SYS_NICE which is required to change process priority. As a result of
which the root user cannot perform operations like increase a process priority
using -ve nice value or set RT priority on processes inside the user namespace.
A workaround to deal with this restriction is to use the help of a process /
daemon running outside the user namespace to change process priority, which is
a an inconvenience.

We could allow these restricted capabilities to take effect only for the root
user from init namespace mapped inside a user namespace and limit the effect
with use of cgroups. It would seem reasonable to deal with each of these
restricted capabilities on a case by case basis and address them. This patch
is concerning CAP_SYS_NICE capability. The proposal here is to selectively
allow CAP_SYS_NICE to take effect inside user namespace only for a root user
mapped from init name space. 

Which user id gets to map the root user(uid 0) from init namespace inside its
user namespaces is authorized thru /etc/subuid & /etc/subgid entries. Only
system admin / root user on the system can add these entries.
Therefore any ordinary user cannot simply map the root user(uid 0) into
user namespaces created. Necessary cgroup bandwidth control can be used
to limit cpu usage for such user namespaces.

The capabilities(7) manpage lists all the operations / system calls that are
subject to CAP_SYS_NICE capability check. This patch currently allows
CAP_SYS_NICE to take effect inside a user namespace only for system calls
affecting process priority. For completeness sake should memory
operations(migrate_pages(2), move_pages(2), mbind(2)) mentioned in the
manpage, also be permitted? There are no cgroup controls to limit the effect
of these memory operations.

Looking for feedback on this approach.

Prakash Sangappa (1):
  Selectively allow CAP_SYS_NICE capability inside user namespaces

 kernel/sched/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.7.4
