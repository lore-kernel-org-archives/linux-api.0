From: Eugene Syromiatnikov <esyr@redhat.com>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Mon, 19 Nov 2018 18:14:04 +0100
Message-ID: <20181119171404.GB28067@asgard.redhat.com>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181119103241.5229-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 11:32:39AM +0100, Christian Brauner wrote:
> +/**
> + *  sys_procfd_signal - send a signal to a process through a process file
> + *                      descriptor
> + *  @fd: the file descriptor of the process
> + *  @sig: signal to be sent
> + *  @info: the signal info
> + *  @flags: future flags to be passed
> + */
> +SYSCALL_DEFINE4(procfd_signal, int, fd, int, sig, siginfo_t __user *, info,
> +		int, flags)

It could be considered better to use an unsigned type for the "flags"
argument.
