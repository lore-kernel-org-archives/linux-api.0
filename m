From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 0/3] posix timers: Extend kernel API to report more info about
 timers (v3)
Date: Mon, 11 Mar 2013 13:11:53 +0400
Message-ID: <513D9FD9.6020507@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Helsley <matt.helsley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi.

Currently kernel doesn't provide any API for getting information about
what timers are currently created by process and in which state they 
are. Also, the way timer IDs are generated makes it impossible to create
a timer with any desired ID. Both facilities are very very tempting by
the checkpoint-restore project.

That said, this series fixes posix timers API in this way:

1. it makes timers IDs generation per-signal_struct to allow for
   recreation of a timer with desired ID;
2. it adds per-task proc file where all timers created by it are
   listed.

This v3 series is ported on v3.9-rc2 and patches' changelogs are fixed
according to Thomas' feedback to contain info why the change is required.

Thanks,
Pavel
