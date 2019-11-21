From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] clone.2: Mention that CLONE_PARENT is off-limits for
 inits
Date: Thu, 21 Nov 2019 10:53:50 +0100
Message-ID: <ac6c1644-c6d3-c7eb-48b1-28eb9342a468@gmail.com>
References: <20191120104504.22411-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191120104504.22411-1-christian@brauner.io>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: mtk.manpages@gmail.com, adrian@lisas.de, akpm@linux-foundation.org, arnd@arndb.de, avagin@gmail.com, christian.brauner@ubuntu.com, dhowells@redhat.com, fweimer@redhat.com, jannh@google.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, mingo@elte.hu, oleg@redhat.com, xemul@virtuozzo.com
List-Id: linux-api@vger.kernel.org

Hello Christian,

On 11/20/19 11:45 AM, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner@ubuntu.com>
> 
> The CLONE_PARENT flag cannot but used by init processes. Let's mention
> this in the manpages to prevent suprises.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  man2/clone.2 | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/man2/clone.2 b/man2/clone.2
> index f0f29d6f1..aa98ab79b 100644
> --- a/man2/clone.2
> +++ b/man2/clone.2
> @@ -646,6 +646,13 @@ if
>  .B CLONE_PARENT
>  is set, then the parent of the calling process, rather than the
>  calling process itself, will be signaled.
> +.IP
> +The kernel will not allow global init and init processes in pid
> +namespaces to use the
> +.B CLONE_PARENT
> +flag. This is done to prevent the creation of multi-rooted process
> +trees. It also avoids unreapable zombies in the initial pid
> +namespace.
>  .TP
>  .BR CLONE_PARENT_SETTID " (since Linux 2.5.49)"
>  Store the child thread ID at the location pointed to by

Thank. I applied, and then tweaked the text a little,
and noted the associated EINVAL error. In the end, the
change is as below.

Cheers,

Michael

index 60e746151..382f6b791 100644
--- a/man2/clone.2
+++ b/man2/clone.2
@@ -648,6 +648,14 @@ if
 .B CLONE_PARENT
 is set, then the parent of the calling process, rather than the
 calling process itself, will be signaled.
+.IP
+The
+.B CLONE_PARENT
+flag can't be used in clone calls by the
+global init process (PID 1 in the initial PID namespace)
+and init processes in other PID namespaces.
+This restriction prevents the creation of multi-rooted process trees
+as well as the creation of unreapable zombies in the initial PID namespace.
 .TP
 .BR CLONE_PARENT_SETTID " (since Linux 2.5.49)"
 Store the child thread ID at the location pointed to by
@@ -1273,6 +1281,11 @@ were specified in the
 .IR flags
 mask.
 .TP
+.BR EINVAL " (since Linux 2.6.32)"
+.\" commit 123be07b0b399670a7cc3d82fef0cb4f93ef885c
+.BR CLONE_PARENT
+was specified, and the caller is an init process.
+.TP
 .B EINVAL
 Returned by the glibc
 .BR clone ()



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
