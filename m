From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH -next v2 0/3] sysvipc: introduce STAT_ANY commands
Date: Sun, 4 Nov 2018 17:29:18 +0100
Message-ID: <480cff75-03a5-5df8-a2e0-c40cf4ebdae4@gmail.com>
References: <20180215162458.10059-1-dave@stgolabs.net>
 <20180320185503.nimh3htpprbg7nth@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180320185503.nimh3htpprbg7nth@linux-n805>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>, akpm@linux-foundation.org
Cc: mtk.manpages@gmail.com, mhocko@kernel.org, robert.kettler@outlook.com, manfred@colorfullife.com, ebiederm@xmission.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>
List-Id: linux-api@vger.kernel.org

Hello Davidlohr,

On 3/20/18 7:55 PM, Davidlohr Bueso wrote:
> On Thu, 15 Feb 2018, Davidlohr Bueso wrote:
> 
>> Once (if) merged, I will submit the necesary manpage updates. But I'm
>> thinking something like:
> 
> Hi Michael, here are the updated manpage entries. As always, please feel
> free to modify the descriptions as you see fit.

Thanks. Patch applied. Sorry for the delay...

Cheers,

Michael

> ------------8<----------------------------------------------------------
> [PATCH] sysvipc: add *_STAT_ANY command descriptions
> 
> The *ctl syscall descriptions have been updated to reflect the
> new commands in msg queues, semaphores and shmem.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>  man2/msgctl.2 | 20 +++++++++++++++++---
>  man2/semctl.2 | 19 ++++++++++++++++++-
>  man2/shmctl.2 | 17 +++++++++++++++--
>  3 files changed, 50 insertions(+), 6 deletions(-)
> 
> diff --git a/man2/msgctl.2 b/man2/msgctl.2
> index df74c750457a..31b1a1f12fb0 100644
> --- a/man2/msgctl.2
> +++ b/man2/msgctl.2
> @@ -33,6 +33,7 @@
>  .\"	Language and formatting clean-ups
>  .\"	Added msqid_ds and ipc_perm structure definitions
>  .\" 2005-08-02, mtk: Added IPC_INFO, MSG_INFO, MSG_STAT descriptions
> +.\" 2018-03-20, dbueso: Added MSG_STAT_ANY description.
>  .\"
>  .TH MSGCTL 2 2017-09-15 "Linux" "Linux Programmer's Manual"
>  .SH NAME
> @@ -222,10 +223,23 @@ Return a
>  structure as for
>  .BR IPC_STAT .
>  However, the
> -.I msqid
> +.I msgid
>  argument is not a queue identifier, but instead an index into
>  the kernel's internal array that maintains information about
>  all message queues on the system.
> +.TP
> +.BR MSG_STAT_ANY " (Linux-specific)"
> +Return a
> +.I msqid_ds
> +structure as for
> +.BR MSG_STAT .
> +However, the
> +.I msg_perm.mode
> +is not checked for read access for
> +.IR msqid ,
> +resembing the behaviour of
> +/proc/sysvipc/msg.
> +.PP
>  .SH RETURN VALUE
>  On success,
>  .BR IPC_STAT ,
> @@ -241,10 +255,10 @@ operation returns the index of the highest used entry in the
>  kernel's internal array recording information about all
>  message queues.
>  (This information can be used with repeated
> -.B MSG_STAT
> +.B MSG_STAT or MSG_STAT_ANY
>  operations to obtain information about all queues on the system.)
>  A successful
> -.B MSG_STAT
> +.B MSG_STAT or MSG_STAT_ANY
>  operation returns the identifier of the queue whose index was given in
>  .IR msqid .
>  .PP
> diff --git a/man2/semctl.2 b/man2/semctl.2
> index 02930d2c74ae..0ebe0434c05f 100644
> --- a/man2/semctl.2
> +++ b/man2/semctl.2
> @@ -37,6 +37,7 @@
>  .\"	Rewrote semun text
>  .\"	Added semid_ds and ipc_perm structure definitions
>  .\" 2005-08-02, mtk: Added IPC_INFO, SEM_INFO, SEM_STAT descriptions.
> +.\" 2018-03-20, dbueso: Added SEM_STAT_ANY description.
>  .\"
>  .TH SEMCTL 2 2017-09-15 "Linux" "Linux Programmer's Manual"
>  .SH NAME
> @@ -240,6 +241,17 @@ argument is not a semaphore identifier, but instead an index into
>  the kernel's internal array that maintains information about
>  all semaphore sets on the system.
>  .TP
> +.BR SEM_STAT_ANY " (Linux-specific)"
> +Return a
> +.I seminfo
> +structure containing the same information as for
> +.BR SEM_STAT .
> +However, the
> +.I sem_perm.mode
> +is not checked for read access for
> +.IR semid ,
> +resembing the behaviour of
> +/proc/sysvipc/sem.
>  .B GETALL
>  Return
>  .B semval
> @@ -367,7 +379,7 @@ the index of the highest used entry in the
>  kernel's internal array recording information about all
>  semaphore sets.
>  (This information can be used with repeated
> -.B SEM_STAT
> +.B SEM_STAT or SEM_STAT_ANY
>  operations to obtain information about all semaphore sets on the system.)
>  .TP
>  .B SEM_INFO
> @@ -377,6 +389,10 @@ as for
>  .B SEM_STAT
>  the identifier of the semaphore set whose index was given in
>  .IR semid .
> +.TP
> +.B SEM_STAT_ANY
> +as for
> +.BR SEM_STAT .
>  .PP
>  All other
>  .I cmd
> @@ -397,6 +413,7 @@ has one of the values
>  .BR GETZCNT ,
>  .BR IPC_STAT ,
>  .BR SEM_STAT ,
> +.BR SEM_STAT_ANY ,
>  .BR SETALL ,
>  or
>  .B SETVAL
> diff --git a/man2/shmctl.2 b/man2/shmctl.2
> index 7bb503999941..42c47d9f4350 100644
> --- a/man2/shmctl.2
> +++ b/man2/shmctl.2
> @@ -41,6 +41,7 @@
>  .\" 2005-04-25, mtk -- noted aberrant Linux behavior w.r.t. new
>  .\"	attaches to a segment that has already been marked for deletion.
>  .\" 2005-08-02, mtk: Added IPC_INFO, SHM_INFO, SHM_STAT descriptions.
> +.\" 2018-03-20, dbueso: Added SHM_STAT_ANY description.
>  .\"
>  .TH SHMCTL 2 2017-09-15 "Linux" "Linux Programmer's Manual"
>  .SH NAME
> @@ -242,6 +243,18 @@ However, the
>  argument is not a segment identifier, but instead an index into
>  the kernel's internal array that maintains information about
>  all shared memory segments on the system.
> +.TP
> +.BR SHM_STAT_ANY " (Linux-specific)"
> +Return a
> +.I shmid_ds
> +structure as for
> +.BR SHM_STAT .
> +However, the
> +.I shm_perm.mode
> +is not checked for read access for
> +.IR shmid ,
> +resembing the behaviour of
> +/proc/sysvipc/shm.
>  .PP
>  The caller can prevent or allow swapping of a shared
>  memory segment with the following \fIcmd\fP values:
> @@ -287,7 +300,7 @@ operation returns the index of the highest used entry in the
>  kernel's internal array recording information about all
>  shared memory segments.
>  (This information can be used with repeated
> -.B SHM_STAT
> +.B SHM_STAT or SHM_STAT_ANY
>  operations to obtain information about all shared memory segments
>  on the system.)
>  A successful
> @@ -328,7 +341,7 @@ isn't accessible.
>  \fIshmid\fP is not a valid identifier, or \fIcmd\fP
>  is not a valid command.
>  Or: for a
> -.B SHM_STAT
> +.B SHM_STAT or SHM_STAT_ANY
>  operation, the index value specified in
>  .I shmid
>  referred to an array slot that is currently unused.
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
