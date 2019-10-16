From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 0/7] Harden userfaultfd
Date: Wed, 16 Oct 2019 11:02:07 +1100 (AEDT)
Message-ID: <alpine.LRH.2.21.1910161100590.23617@namei.org>
References: <20191012191602.45649-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191012191602.45649-1-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, lokeshgidra@google.com, nnk@google.com, nosh@google.com, timmurray@google.com
List-Id: linux-api@vger.kernel.org

On Sat, 12 Oct 2019, Daniel Colascione wrote:

>  Documentation/admin-guide/sysctl/vm.rst | 19 +++++-
>  fs/anon_inodes.c                        | 89 +++++++++++++++++--------
>  fs/userfaultfd.c                        | 47 +++++++++++--
>  include/linux/anon_inodes.h             | 27 ++++++--
>  include/linux/lsm_hooks.h               |  8 +++
>  include/linux/security.h                |  2 +
>  include/linux/userfaultfd_k.h           |  3 +
>  include/uapi/linux/userfaultfd.h        | 14 ++++
>  kernel/sysctl.c                         |  9 +++
>  security/security.c                     |  8 +++
>  security/selinux/hooks.c                | 68 +++++++++++++++++++
>  security/selinux/include/classmap.h     |  2 +
>  12 files changed, 256 insertions(+), 40 deletions(-)

For any changes to security/ please include the linux-security-module 
list.

-- 
James Morris
<jmorris@namei.org>
