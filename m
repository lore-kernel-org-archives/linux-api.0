From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/11] capsicum: prctl(2) to force use of O_BENEATH
Date: Fri, 25 Jul 2014 16:01:57 +0200
Message-ID: <53D26355.9020809@redhat.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com> <1406296033-32693-11-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1406296033-32693-11-git-send-email-drysdale@google.com>
Sender: linux-security-module-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Il 25/07/2014 15:47, David Drysdale ha scritto:
> @@ -1996,6 +2013,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		if (arg2 || arg3 || arg4 || arg5)
>  			return -EINVAL;
>  		return current->no_new_privs ? 1 : 0;
> +	case PR_SET_OPENAT_BENEATH:
> +		if (arg2 != 1 || arg4 || arg5)
> +			return -EINVAL;
> +		if ((arg3 & ~(PR_SET_OPENAT_BENEATH_TSYNC)) != 0)
> +			return -EINVAL;
> +		error = prctl_set_openat_beneath(me, arg3);
> +		break;
> +	case PR_GET_OPENAT_BENEATH:
> +		if (arg2 || arg3 || arg4 || arg5)
> +			return -EINVAL;
> +		return me->openat_beneath;
>  	case PR_GET_THP_DISABLE:
>  		if (arg2 || arg3 || arg4 || arg5)
>  			return -EINVAL;
> 

Why are you always forbidding a change of prctl from 1 to 0?  It should
be safe if current->no_new_privs is clear.

Do new threads inherit from the parent?

Also, I wonder if you need something like this check:

        /*
         * Installing a seccomp filter requires that the task has
         * CAP_SYS_ADMIN in its namespace or be running with no_new_privs.
         * This avoids scenarios where unprivileged tasks can affect the
         * behavior of privileged children.
         */
        if (!current->no_new_privs &&
            security_capable_noaudit(current_cred(), current_user_ns(),
                                     CAP_SYS_ADMIN) != 0)
                return -EACCES;

Paolo
