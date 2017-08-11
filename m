From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v6 0/6] Improved seccomp logging
Date: Fri, 11 Aug 2017 04:33:51 +0000
Message-ID: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Tycho Andersen <tycho-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch set aims to improve logging in seccomp by:

 1) Empowering administrators to be able to permit or quiet logging of
    specific seccomp actions
 2) Allowing applications to request logging of all actions, except for
    RET_ALLOW, in the filter being loaded (subject to the
    administrator's wishes in #1)
 3) By making it possible for application developers to request logging
    of specific syscalls while developing filters for their application
    (subject to the administrator's wishes in #1)

With this patch set applied, the logic for deciding if an action will be
logged is as described in the commit message of the final patch.

* Changes since v5:
  - Rebase onto
    https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/?h=seccomp/kill_process
    (kees)
    + Redefine the value of SECCOMP_FILTER_FLAG_LOG to account for the
      new SECCOMP_FILTER_FLAG_KILL_PROCESS
    + Add SECCOMP_FILTER_FLAG_KILL_PROCESS to the
      detect_seccomp_filter_flags selftest
  - Reorder patches to move SECCOMP_GET_ACTION_AVAIL patch behind
    actions_avail sysctl patch (kees)
  - Reorder patches to move the selftest to detect filter flag support
    before the patch that adds SECCOMP_FILTER_FLAG_LOG (kees)
  - Add psuedo code showing the high level logic of when and when not to
    log to the commit message of each patch that changes the logging
    behavior (inspired by kees)
  - Add Suggested-by to the SECCOMP_GET_ACTION_AVAIL patch to credit
    Andy for the idea (tyhicks)
  - Use sizeof(seccomp_actions_avail), instead of strlen(), to avoid
    variable length "names" array in seccomp_actions_logged_handler()
    (smatch)
  - Only check the actions_logged sysctl value for "kill" when first
    introducing the actions_logged sysctl since filters cannot yet set
    the FILTER_FLAG_LOG flag (kees)
  - Mention how the actions_logged sysctl could quiet SECCOMP_RET_LOG
    actions in seccomp_filter.rst documentation (kees)

Tyler
