From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/3] clone.2: Fix typos
Date: Sun, 17 Nov 2019 19:00:20 +0100
Message-ID: <0ef00041-9952-3dea-1d6b-2d14536764d3@gmail.com>
References: <20191116114114.7066-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191116114114.7066-1-christian@brauner.io>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: mtk.manpages@gmail.com, adrian@lisas.de, akpm@linux-foundation.org, arnd@arndb.de, avagin@gmail.com, christian.brauner@ubuntu.com, dhowells@redhat.com, fweimer@redhat.com, jannh@google.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, mingo@elte.hu, oleg@redhat.com, xemul@virtuozzo.com
List-Id: linux-api@vger.kernel.org

On 11/16/19 12:41 PM, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner@ubuntu.com>

Thanks, Christian, 

Patch applied.

Cheers,

Michael


> Fix two spelling mistakes in manpage describing the clone{2,3}()
> syscalls/syscall wrappers.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  man2/clone.2 | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/man2/clone.2 b/man2/clone.2
> index f67a60067..57a9eaba7 100644
> --- a/man2/clone.2
> +++ b/man2/clone.2
> @@ -70,12 +70,12 @@ create a new ("child") process, in a manner similar to
>  .PP
>  By contrast with
>  .BR fork (2),
> -these system cals provide more precise control over what pieces of execution
> +these system calls provide more precise control over what pieces of execution
>  context are shared between the calling process and the child process.
>  For example, using these system calls, the caller can control whether
>  or not the two processes share the virtual address space,
>  the table of file descriptors, and the table of signal handlers.
> -These system calls also allow the new child process to placed
> +These system calls also allow the new child process to be placed
>  in separate
>  .BR namespaces (7).
>  .PP
> 
> base-commit: 91243dad42a7a62df73e3b1dfbb810adc1b8b654
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
