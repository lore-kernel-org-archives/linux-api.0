From: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Subject: Re: [PATCH v2 2/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 12:53:57 +0100
Message-ID: <f0d590b96b7d11ae21a9a06040b8ffa85fa74e2a.camel@bitron.ch>
References: <20190329155425.26059-1-christian@brauner.io>
         <20190329155425.26059-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190329155425.26059-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>, jannh@google.com, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, ebiederm@xmission.com, khlebnikov@yandex-team.ru, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On Fri, 2019-03-29 at 16:54 +0100, Christian Brauner wrote:
> diff --git a/include/uapi/linux/wait.h b/include/uapi/linux/wait.h
> index ac49a220cf2a..d6c7c0701997 100644
> --- a/include/uapi/linux/wait.h
> +++ b/include/uapi/linux/wait.h
> @@ -18,5 +18,7 @@
>  #define P_PID		1
>  #define P_PGID		2
>  
> +/* Get a file descriptor for /proc/<pid> of the corresponding pidfd
> */
> +#define PIDFD_GET_PROCFD _IOR('p', 1, int)
>  
>  #endif /* _UAPI_LINUX_WAIT_H */

This is missing an entry in Documentation/ioctl/ioctl-number.txt and is
actually conflicting with existing entries.

However, I'd actually prefer a syscall to allow strict whitelisting via
seccomp and avoid the other ioctl disadvantages that Daniel has already
mentioned.

Cheers,
Jürg
