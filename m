From: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/7 v2] tracing: Fix tracefs lockdown and various clean ups
Date: Fri, 11 Oct 2019 20:57:47 -0400
Message-ID: <20191012005747.210722465@goodmis.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Garrett <matthewgarrett@google.com>, James Morris James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

It appears that using destroy_inode() to clean up the proxy_ops that was
used by the lockdown code to have all open calls to the tracefs directory
was totally broken. It caused the inodes to not be cleaned up as the
destroy_inode() method is expected to clean up the inode, and not just what
it allocated as extra.

Linus suggested to get rid of the proxy_ops in tracefs, and just put the
checks in the open functions themselves. This also gives us a bit more fine
grain control to what exactly can be accessed.

Currently, I left the event format files (as they may need to be used by
something other than tracing), and enabled_functions, which shows what
functions are currently being traced. Not sure it is wise to not display
that information.

They can always be locked down later if need be.

Steven Rostedt (VMware) (7):
      tracefs: Revert ccbd54ff54e8 ("tracefs: Restrict tracefs when the kernel is locked down")
      ftrace: Get a reference counter for the trace_array on filter files
      tracing: Get trace_array reference for available_tracers files
      tracing: Have trace events system open call tracing_open_generic_tr()
      tracing: Add tracing_check_open_get_tr()
      tracing: Add some more locked_down checks
      tracing: Do not create tracefs files if tracefs lockdown is in effect

----
 fs/tracefs/inode.c                  |  46 ++----------
 kernel/trace/ftrace.c               |  55 ++++++++++----
 kernel/trace/trace.c                | 138 ++++++++++++++++++++++--------------
 kernel/trace/trace.h                |   2 +
 kernel/trace/trace_dynevent.c       |   4 ++
 kernel/trace/trace_events.c         |  49 +++++--------
 kernel/trace/trace_events_hist.c    |  13 +++-
 kernel/trace/trace_events_trigger.c |   8 ++-
 kernel/trace/trace_kprobe.c         |  12 +++-
 kernel/trace/trace_printk.c         |   7 ++
 kernel/trace/trace_stack.c          |   8 +++
 kernel/trace/trace_stat.c           |   6 +-
 kernel/trace/trace_uprobe.c         |  11 +++
 13 files changed, 220 insertions(+), 139 deletions(-)
