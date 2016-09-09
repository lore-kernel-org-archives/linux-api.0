From: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 0/3] syscall/tracing: compat syscall support
Date: Fri, 9 Sep 2016 10:03:26 +0200
Message-ID: <1473408209-17335-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patchset adds support syscall event tracing for compat syscalls.

Patch 1 removes the unnecessary syscall_nr field from syscall metadata,
which was one of the obstacles for adding proper support for compat syscalls.

Patch 2 adds a method to distinguish handling of syscalls for compat tasks
if an arch requires that. In disussions about an earlier version of these
patches (http://marc.info/?l=linux-mips&m=147259973128606&w=2) it was suggested
to use audit arch for detecting syscall type. After analysing the code
for various arches it seemed to me that this would add an unnecessary
complexity (as would require extra APIs to enumerate and map all audit
arch types) and I've just simply used compat task status to determine call
type. I cannot see any added value from using the audit arch type in this
context, but it is of course possible that I'm missing some vital piece
of information here ... hence this change is sent as an RFC so that I can
get valuable feedback on the proposed solution.

Finally the last patch adds the missing compat syscall metadata.


Marcin Nowakowski (3):
  tracing/syscalls: remove syscall_nr from syscall metadata
  tracing/syscalls: add handling for compat tasks
  tracing/syscalls: add compat syscall metadata

 arch/mips/kernel/ftrace.c     |   4 +-
 arch/x86/include/asm/ftrace.h |  10 +-
 arch/x86/kernel/ftrace.c      |  14 +++
 include/linux/compat.h        |  74 ++++++++++++
 include/linux/ftrace.h        |   2 +-
 include/linux/syscalls.h      |   1 -
 include/trace/syscall.h       |   2 -
 kernel/trace/trace.h          |  11 +-
 kernel/trace/trace_syscalls.c | 254 +++++++++++++++++++++++++++---------------
 9 files changed, 265 insertions(+), 107 deletions(-)

-- 
2.7.4
