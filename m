From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v7 0/5] Add preadv & pwritev system calls.
Date: Mon, 26 Jan 2009 14:26:24 +0100
Message-ID: <1232976389-13021-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-api@vger.kernel.org

  Hi folks,

Next round of the preadv & pwritev patch series.  The whitespace bugs
should finally be gone now, checkpatch has nothing to complain about.

There is now a git tree with the patches (branch 'preadv'):
  git://git.et.redhat.com/kernel-kraxel.git
  http://git.et.redhat.com/?p=kernel-kraxel.git;a=shortlog;h=refs/heads/preadv

Plan it so get this into the linux-next once it comes back to life (after
LCA?).

As for userspace bits someone asked for:

Qemu wants use that to handle virtual disk I/O.  A patch for qemu can be
found here: http://article.gmane.org/gmane.comp.emulators.qemu/36851
The code can't put into use yet though as the qemu block layer needs
some changes to pass though iovecs to the disk image format driver code.

Note this isn't the first attempt to get preadv support into the kernel,
therefore I expect others (databases?) will quickly use that too.

Also *BSD has this syscall for quite some time, thus there likely is
code using this in the wild already ...

cheers,
  Gerd
