From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH 2/4] pid: add pidfd_open()
Date: Wed, 27 Mar 2019 18:21:24 +0100
Message-ID: <9254286c02dbe883c14e38ed2af0022d36b17355.camel@opteya.com>
References: <20190327162147.23198-1-christian@brauner.io>
         <20190327162147.23198-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327162147.23198-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>, jannh@google.com, khlebnikov@yandex-team.ru, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, ebiederm@xmission.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

Le mercredi 27 mars 2019 à 17:21 +0100, Christian Brauner a écrit :

> diff --git a/kernel/pid.c b/kernel/pid.c
> index 20881598bdfa..c9e24e726aba 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -26,8 +26,10 @@
> +SYSCALL_DEFINE4(pidfd_open, pid_t, pid, int, procfd, int, pidfd,
> unsigned int,
> +		flags)
> +{
> +	long fd = -EINVAL;
> +
> +	if (flags & ~(PIDFD_TO_PROCFD | PROCFD_TO_PIDFD))
> +		return -EINVAL;
> +
> +	if (!flags) {
> +		struct pid *pidfd_pid;
> +
> +		if (pid <= 0)
> +			return -EINVAL;
> +
> +		if (procfd != -1 || pidfd != -1)
> +			return -EINVAL;
> +
> +		rcu_read_lock();
> +		pidfd_pid = get_pid(find_pid_ns(pid, task_active_pid_ns(current)));
> +		rcu_read_unlock();
> +
> +		fd = pidfd_create_fd(pidfd_pid, O_CLOEXEC);
> +		put_pid(pidfd_pid);
> +	} else if (flags & PIDFD_TO_PROCFD) {

[...]

> +	} else if (flags & PROCFD_TO_PIDFD) {
> +		if (flags & ~PROCFD_TO_PIDFD)
> +			return -EINVAL;
> +
> +		if (pid != -1)
> +			return -EINVAL;
> +
> +		if (pidfd >= 0)
> 

I think it can be stricter with:

                if (pidfd != -1)

(and match the check done for flag == 0).

Regards.

-- 
Yann Droneaud
OPTEYA
