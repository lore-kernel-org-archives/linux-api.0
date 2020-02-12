From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH v2 2/6] Add a concept of a "secure" anonymous file
Date: Wed, 12 Feb 2020 11:49:27 -0500
Message-ID: <6c24ec53-1839-832c-cbfb-8b10b413e7db@tycho.nsa.gov>
References: <20200211225547.235083-1-dancol@google.com>
 <20200211225547.235083-3-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200211225547.235083-3-dancol@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>, timmurray@google.com, nosh@google.com, nnk@google.com, lokeshgidra@google.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, selinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2/11/20 5:55 PM, Daniel Colascione wrote:
> A secure anonymous file is one we hooked up to its own inode (as
> opposed to the shared inode we use for non-secure anonymous files). A
> new selinux hook gives security modules a chance to initialize, label,
> and veto the creation of these secure anonymous files. Security
> modules had limit ability to interact with non-secure anonymous files
> due to all of these files sharing a single inode.
> 
> Signed-off-by: Daniel Colascione <dancol@google.com>

(please add linux-fsdevel, viro, linux-security-module, 
jmorris@namei.org, serge@hallyn.com to cc on future versions of this 
patch since it is a VFS and a LSM change)

> --- > diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 20d8cf194fb7..ba208ce5711d 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -215,6 +215,10 @@
>    *	Returns 0 if @name and @value have been successfully set,
>    *	-EOPNOTSUPP if no security attribute is needed, or
>    *	-ENOMEM on memory allocation failure.
> + * @inode_init_security_anon:
> + *      Set up a secure anonymous inode.
> + *	Returns 0 on success. Returns -EPERM if	the security module denies
> + *	the creation of this inode.

Please document the parameters for the hook as well.
