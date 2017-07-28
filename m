From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v5 0/6] Improved seccomp logging
Date: Fri, 28 Jul 2017 20:55:46 +0000
Message-ID: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an update to the previous seccomp logging patch sets. The main
difference in this revision compared to the last is that the application now
has the ability to request that all actions in a filter, except for RET_ALLOW,
should be logged. This is done with a new filter flag. In support of that
change, the log_max_action sysctl was renamed to actions_logged as it now lists
the actions that an admin has allowed to be logged. The admin has the final say
in what actions get logged.

Please see the individual patches for summaries of changes since the last
revision.

Thanks!

Tyler
