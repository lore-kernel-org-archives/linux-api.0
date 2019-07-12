From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 05/10] namei: O_BENEATH-style path resolution flags
Date: Fri, 12 Jul 2019 05:33:42 +0100
Message-ID: <20190712043341.GI17978@ZenIV.linux.org.uk>
References: <20190706145737.5299-1-cyphar@cyphar.com>
 <20190706145737.5299-6-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190706145737.5299-6-cyphar@cyphar.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, Shuah Khan <shuah@kernel.org>, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Aleksa Sarai <asarai@suse.de>, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, linux-xtensa@linux-xtensa.org, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, linuxppc-dev@lists.ozlabs.org, linux-m68k@lists.linux-m68k.org, Andy Lutomirski <luto@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, David Drysdale <drysdale@google.com>, Christian Brauner <christian@brauner.io>, "J. Bruce Fields" <bfields@fieldses.org>, linux-parisc@vger.kernel.org, linux-api@vger.kernel.orgCh
List-Id: linux-api@vger.kernel.org

On Sun, Jul 07, 2019 at 12:57:32AM +1000, Aleksa Sarai wrote:

> @@ -1442,8 +1464,11 @@ static int follow_dotdot_rcu(struct nameidata *nd)
>  	struct inode *inode = nd->inode;
>  
>  	while (1) {
> -		if (path_equal(&nd->path, &nd->root))
> +		if (path_equal(&nd->path, &nd->root)) {
> +			if (unlikely(nd->flags & LOOKUP_BENEATH))
> +				return -EXDEV;

> @@ -1468,6 +1493,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
>  				return -ECHILD;
>  			if (&mparent->mnt == nd->path.mnt)
>  				break;
> +			if (unlikely(nd->flags & LOOKUP_XDEV))
> +				return -EXDEV;
>  			/* we know that mountpoint was pinned */
>  			nd->path.dentry = mountpoint;
>  			nd->path.mnt = &mparent->mnt;
> @@ -1482,6 +1509,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
>  			return -ECHILD;
>  		if (!mounted)
>  			break;
> +		if (unlikely(nd->flags & LOOKUP_XDEV))
> +			return -EXDEV;

Are you sure these failure exits in follow_dotdot_rcu() won't give
suprious hard errors?

> +	if (unlikely(nd->flags & LOOKUP_BENEATH)) {
> +		error = dirfd_path_init(nd);
> +		if (unlikely(error))
> +			return ERR_PTR(error);
> +		nd->root = nd->path;
> +		if (!(nd->flags & LOOKUP_RCU))
> +			path_get(&nd->root);
> +	}
>  	if (*s == '/') {
>  		if (likely(!nd->root.mnt))
>  			set_root(nd);
> @@ -2350,9 +2400,11 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
>  			s = ERR_PTR(error);
>  		return s;
>  	}
> -	error = dirfd_path_init(nd);
> -	if (unlikely(error))
> -		return ERR_PTR(error);
> +	if (likely(!nd->path.mnt)) {

Is that a weird way of saying "if we hadn't already called dirfd_path_init()"?
