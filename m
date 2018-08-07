From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v4 0/4] seccomp trap to userspace
Date: Mon, 6 Aug 2018 20:44:42 -0600
Message-ID: <20180807024442.GA12274@cisco.lan>
References: <20180621220416.5412-1-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180621220416.5412-1-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, "Tobin C . Harding" <me@tobin.cc>
List-Id: linux-api@vger.kernel.org

Hi all,

Dinesh Subhraveti has claimed that some part of this series might be
patented. While he has not furnished me with anything to confirm this
claim, I'll put this series on hold.

Tycho

On Thu, Jun 21, 2018 at 04:04:12PM -0600, Tycho Andersen wrote:
> Hi all,
> 
> Here's v4 of the seccomp trap to userspace series. v3 is here:
> https://lkml.org/lkml/2018/5/31/527
> 
> I believe we've addressed the two burning questions I had about v3: 1.
> it seems ok not to use netlink, since there's not a great way to re-use
> the API without a lot of unnecessary code and 2. only having return
> capability for fds seems fine with people. Or at least I haven't heard
> any strong objections.
> 
> I've re-worked a bunch of things in this version based on feedback from
> the last series. See patch notes for details. At this point I'm not
> aware of anything that needs to be addressed, but of course that is
> subject to change :)
> 
> Tycho
> 
> Tycho Andersen (4):
>   seccomp: add a return code to trap to userspace
>   seccomp: make get_nth_filter available outside of CHECKPOINT_RESTORE
>   seccomp: add a way to get a listener fd from ptrace
>   seccomp: add support for passing fds via USER_NOTIF
> 
>  .../userspace-api/seccomp_filter.rst          |  79 +++
>  arch/Kconfig                                  |   7 +
>  include/linux/seccomp.h                       |  18 +-
>  include/uapi/linux/ptrace.h                   |   2 +
>  include/uapi/linux/seccomp.h                  |  23 +-
>  kernel/ptrace.c                               |   4 +
>  kernel/seccomp.c                              | 491 ++++++++++++++-
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 560 +++++++++++++++++-
>  8 files changed, 1172 insertions(+), 12 deletions(-)
> 
> -- 
> 2.17.1
> 
