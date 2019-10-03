From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH RFC 0/3] document openat2(2) patch series
Date: Fri,  4 Oct 2019 00:55:38 +1000
Message-ID: <20191003145542.17490-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian@brauner.io>, Aleksa Sarai <asarai@suse.de>, linux-man@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is a first draft of the man-page changes for the openat2(2) patch
series I'm working on[1]. It includes information about the magic-link
changes as well as the primary new features (O_EMPTYPATH and openat2).

Let me know what you think. I might go into too much detail about how
extension of openat2(2) will work -- let me know if that section should
be dropped (while it is useful for userspace to understand, it isn't
really that necessary to explain exactly what the semantics are -- it
will usually just transparently work).

[1]: https://lore.kernel.org/lkml/20190930183316.10190-1-cyphar@cyphar.com/

Aleksa Sarai (3):
  symlink.7: document magic-links more completely
  open.2: add O_EMPTYPATH documentation
  openat2.2: document new openat2(2) syscall

 man2/open.2            |  47 ++++-
 man2/openat2.2         | 381 +++++++++++++++++++++++++++++++++++++++++
 man7/path_resolution.7 |  89 ++++++++--
 man7/symlink.7         |  39 ++++-
 4 files changed, 528 insertions(+), 28 deletions(-)
 create mode 100644 man2/openat2.2

-- 
2.23.0
