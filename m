From: "Michael Kerrisk (man-opages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH v7 0/6] seccomp trap to userspace
Date: Fri, 28 Sep 2018 23:57:40 +0200
Message-ID: <686fe047-16e6-3dfc-6284-ed574d97ad2f@gmail.com>
References: <20180927151119.9989-1-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927151119.9989-1-tycho@tycho.ws>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
Cc: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Tycho,

On 09/27/2018 05:11 PM, Tycho Andersen wrote:
> Hi all,
> 
> Here's v7 of the seccomp trap to userspace set. There are various minor
> changes and bug fixes, but two major changes:
> 
> * We now pass fds to the tracee via an ioctl, and do it immediately when
>    the ioctl is called. For this we needed some help from the vfs, so
>    I've put the one patch in this series and cc'd fsdevel. This does have
>    the advantage that the feature is now totally decoupled from the rest
>    of the set, which is itself useful (thanks Andy!)
> 
> * Instead of putting all of the notification related stuff into the
>    struct seccomp_filter, it now lives in its own struct notification,
>    which is pointed to by struct seccomp_filter. This will save a lot of
>    memory (thanks Tyler!)

Is there a documentation (man page) patch for this API change?

Thanks,

Michael

> v6 discussion: https://lkml.org/lkml/2018/9/6/769
> 
> Thoughts welcome,
> 
> Tycho
> 
> Tycho Andersen (6):
>    seccomp: add a return code to trap to userspace
>    seccomp: make get_nth_filter available outside of CHECKPOINT_RESTORE
>    seccomp: add a way to get a listener fd from ptrace
>    files: add a replace_fd_files() function
>    seccomp: add a way to pass FDs via a notification fd
>    samples: add an example of seccomp user trap
> 
>   Documentation/ioctl/ioctl-number.txt          |   1 +
>   .../userspace-api/seccomp_filter.rst          |  89 +++
>   fs/file.c                                     |  22 +-
>   include/linux/file.h                          |   8 +
>   include/linux/seccomp.h                       |  14 +-
>   include/uapi/linux/ptrace.h                   |   2 +
>   include/uapi/linux/seccomp.h                  |  42 +-
>   kernel/ptrace.c                               |   4 +
>   kernel/seccomp.c                              | 527 ++++++++++++++-
>   samples/seccomp/.gitignore                    |   1 +
>   samples/seccomp/Makefile                      |   7 +-
>   samples/seccomp/user-trap.c                   | 312 +++++++++
>   tools/testing/selftests/seccomp/seccomp_bpf.c | 607 +++++++++++++++++-
>   13 files changed, 1617 insertions(+), 19 deletions(-)
>   create mode 100644 samples/seccomp/user-trap.c
> 
