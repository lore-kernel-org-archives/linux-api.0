From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 04/10] namei: split out nd->dfd handling to
 dirfd_path_init
Date: Fri, 12 Jul 2019 05:20:50 +0100
Message-ID: <20190712042050.GH17978@ZenIV.linux.org.uk>
References: <20190706145737.5299-1-cyphar@cyphar.com>
 <20190706145737.5299-5-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190706145737.5299-5-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-alpha@vger.ker
List-Id: linux-api@vger.kernel.org

On Sun, Jul 07, 2019 at 12:57:31AM +1000, Aleksa Sarai wrote:
> Previously, path_init's handling of *at(dfd, ...) was only done once,
> but with LOOKUP_BENEATH (and LOOKUP_IN_ROOT) we have to parse the
> initial nd->path at different times (before or after absolute path
> handling) depending on whether we have been asked to scope resolution
> within a root.

>  	if (*s == '/') {
> -		set_root(nd);
> -		if (likely(!nd_jump_root(nd)))
> -			return s;
> -		return ERR_PTR(-ECHILD);

> +		if (likely(!nd->root.mnt))
> +			set_root(nd);

How can we get there with non-NULL nd->root.mnt, when LOOKUP_ROOT case
has been already handled by that point?

> +		error = nd_jump_root(nd);
> +		if (unlikely(error))
> +			s = ERR_PTR(error);
