From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [RFC v5 1/1] ns: add binfmt_misc to the user namespace
Date: Tue, 9 Oct 2018 08:16:41 -0700
Message-ID: <20181009151641.GB10149@cisco>
References: <20181009103752.21482-1-laurent@vivier.eu>
 <20181009103752.21482-2-laurent@vivier.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181009103752.21482-2-laurent@vivier.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <laurent@vivier.eu>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <dima@arista.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, Jann Horn <jannh@google.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Eric Biederman <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 09, 2018 at 12:37:52PM +0200, Laurent Vivier wrote:
> @@ -80,18 +74,32 @@ static int entry_count;
>   */
>  #define MAX_REGISTER_LENGTH 1920
>  
> +static struct binfmt_namespace *binfmt_ns(struct user_namespace *ns)
> +{
> +	struct binfmt_namespace *b_ns;
> +
> +	while (ns) {
> +		b_ns = READ_ONCE(ns->binfmt_ns);
> +		if (b_ns)
> +			return b_ns;
> +		ns = ns->parent;
> +	}
> +	WARN_ON_ONCE(1);

It looks like we warn here,

> @@ -133,17 +141,18 @@ static int load_misc_binary(struct linux_binprm *bprm)
>  	struct file *interp_file = NULL;
>  	int retval;
>  	int fd_binary = -1;
> +	struct binfmt_namespace *ns = binfmt_ns(current_user_ns());
>  
>  	retval = -ENOEXEC;
> -	if (!enabled)
> +	if (!ns->enabled)

...but then in cases like this we immediately dereference the pointer
anyways and crash. Can we return some other error code here in the !ns
case so we don't crash?

Tycho
