From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH man-pages v2 0/2] document openat2(2)
Date: Mon,  3 Feb 2020 02:19:05 +1100
Message-ID: <20200202151907.23587-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Patch changelog:
  v2:
    * Updated based on the new (now-merged) structure layout and semantics.
  v1: <https://lore.kernel.org/linux-man/20191206142931.28138-1-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org/>
    * Updated based on Kerrisk's review.
 RFC: <https://lore.kernel.org/linux-man/20191003145542.17490-1-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org/>

Now that openat2(2) has landed in Linus's tree[1], here is the
associated man-page changes to document it.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b55eef872a96738ea9cb35774db5ce9a7d3a648f

Aleksa Sarai (2):
  path_resolution.7: update to mention openat2(2) features
  openat2.2: document new openat2(2) syscall

 man2/open.2            |  17 ++
 man2/openat2.2         | 471 +++++++++++++++++++++++++++++++++++++++++
 man7/path_resolution.7 |  56 +++--
 3 files changed, 526 insertions(+), 18 deletions(-)
 create mode 100644 man2/openat2.2

-- 
2.25.0
