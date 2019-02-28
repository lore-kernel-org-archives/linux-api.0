From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/2] seccomp.2: document userspace notification
Date: Thu, 28 Feb 2019 14:25:55 +0100
Message-ID: <e7a5abd9-f7b7-e077-221a-4c3ef7b818df@gmail.com>
References: <20181213001106.15268-1-tycho@tycho.ws>
 <20181213001106.15268-3-tycho@tycho.ws>
 <2cea5fec-e73e-5749-18af-15c35a4bd23c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2cea5fec-e73e-5749-18af-15c35a4bd23c@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: mtk.manpages@gmail.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jann Horn <jann@thejh.net>, Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, Containers <containers@lists.linux-foundation.org>, Aleksa Sarai <asarai@suse.de>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
List-Id: linux-api@vger.kernel.org

> 7. The monitoring process can use the information in the
>    'struct seccomp_notif' to make a determination about the
>    system call being made by the target process. This
>    structure includes a 'data' field that is the same
>    'struct seccomp_data' that is passed to a BPF filter.
> 
>    In addition, the monitoring process may make use of other 
>    information that is available from user space. For example, 
>    it may inspect the memory of the target process (whose PID
>    is provided in the 'struct seccomp_notif') using
>    /proc/PID/mem, which includes inspecting the values
>    pointed to by system call arguments (whose location is
>    available 'seccomp_notif.data.args). However, when using
>    the target process PID in this way, one must guard against
>    PID re-use race conditions using the seccomp()
>    SECCOMP_IOCTL_NOTIF_ID_VALID operation.
> 
> 8. Having arrived at a decision about the target process's
>    system call, the monitoring process can inform the kernel
>    of its decision using the operation
> 
>        ioctl(listenfd, SECCOMP_IOCTL_NOTIF_SEND, respptr)
> 
>    where the third argument is a pointer to a
>    'struct seccomp_notif_resp'. [Some more details
>    needed here, but I still don't yet understand fully
>    the semantics of the 'error' and 'val' fields.]

So clearly, I misunderstood these last two steps.

(7) is something like: discover information in userspace
as required; perform userspace actions if appropriate
(perhaps doing the system call operation "on behalf of" the
target process).


(8) is something like:
   set 'error' and 'val' to return info to the target process:
    * error != 0 ==> make it look like the syscall failed,
      with 'errno' set to that value
    * error == 0 ==> make it look like the syscall succeeded 
      and returned 'val'

Right?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
