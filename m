From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2] Introduce v3 namespaced file capabilities
Date: Sat, 29 Apr 2017 13:22:52 -0500
Message-ID: <87a86zul8j.fsf@xmission.com>
References: <20170429041534.GA25594@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170429041534.GA25594@mail.hallyn.com> (Serge E. Hallyn's
        message of "Fri, 28 Apr 2017 23:15:34 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Seth Forshee <seth.forshee@canonical.com>, lkml <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, Kees Cook <keescook@chromium.org>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@kernel.org>, "Andrew G. Morgan" <morgan@kernel.org>
List-Id: linux-api@vger.kernel.org


"Serge E. Hallyn" <serge@hallyn.com> writes:

[snip]
> A patch to linux-test-project adding a new set of tests for this
> functionality is in the nsfscaps branch at github.com/hallyn/ltp
>
> Changelog:
>    Nov 02 2016: fix invalid check at refuse_fcap_overwrite()
>    Nov 07 2016: convert rootid from and to fs user_ns
>    (From ebiederm: mar 28 2017)
>      commoncap.c: fix typos - s/v4/v3
>      get_vfs_caps_from_disk: clarify the fs_ns root access check
>      nsfscaps: change the code split for cap_inode_setxattr()
>    Apr 09 2017:
>        don't return v3 cap for caps owned by current root.
>       return a v2 cap for a true v2 cap in non-init ns
>    Apr 18 2017:
>       . Change the flow of fscap writing to support s_user_ns writing.
>       . Remove refuse_fcap_overwrite().  The value of the previous
>         xattr doesn't matter.
>    Apr 24 2017:
>       . incorporate Eric's incremental diff
>       . move cap_convert_nscap to setxattr and simplify its usage
> ---
>  fs/xattr.c                      |   6 +
>  include/linux/capability.h      |   3 +-
>  include/linux/security.h        |   2 +
>  include/uapi/linux/capability.h |  22 +++-
>  security/commoncap.c            | 269 +++++++++++++++++++++++++++++++++++++---
>  5 files changed, 279 insertions(+), 23 deletions(-)
>

Grrr.  No Signed-off-by: again.

Eric
