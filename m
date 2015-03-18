From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 0/3] UserfaultFD: Extension for non cooperative uffd usage
Date: Wed, 18 Mar 2015 22:34:26 +0300
Message-ID: <5509D342.7000403@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sanidhya Kashyap <sanidhya.gatech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

On the recent LSF Andrea presented his userfault-fd patches and
I had shown some issues that appear in usage scenarios when the
monitor task and mm task do not cooperate to each other on VM
changes (and fork()-s).

Here's the implementation of the extended uffd API that would help 
us to address those issues.

As proof of concept I've implemented only fix for fork() case, but
I also plan to add the mremap() and exit() notifications, both are
also required for such non-cooperative usage.

More details about the extension itself is in patch #2 and the fork()
notification description is in patch #3.

Comments and suggestion are warmly welcome :)


Andrea, what's the best way to go on with the patches -- would you
prefer to include them in your git tree or should I instead continue
with them on my own, re-sending them when required? Either way would
be OK for me.

Thanks,
Pavel
