From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v6 0/5] Add preadv & pwritev system calls.
Date: Fri, 16 Jan 2009 17:45:39 +0100
Message-ID: <1232124344-25892-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-api@vger.kernel.org

  Hi folks,

Next round of the preadv & pwritev patch series.  Had no review comments
to fix.  That means it is ready to be merged, right?

Changes:
 - compat_sys_{read,write}v bugfix patch dropped (merged).
 - rebase to latest git, adapt to CVE-2009-0029 changes.

How to proceed now?  Is there a syscall maintainer where I could queue
up the patches?  If not, anyone (akpm?) willng to pick this up?  Should
I try to send to Linus directly?

What is the usual way to handle the arch-specific syscall windup?  I'd
prefer to leave that to the arch maintainers as they know best what
needs to be done, is that ok?  Right now only x86 (/me) and mips (patch
from Ralf Baechle) is covered ...

cheers,
  Gerd
