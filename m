From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v15 2/9] namei: LOOKUP_NO_MAGICLINKS: block magic-link
 resolution
Date: Wed, 13 Nov 2019 01:24:26 +0000
Message-ID: <20191113012426.GY26530@ZenIV.linux.org.uk>
References: <20191105090553.6350-1-cyphar@cyphar.com>
 <20191105090553.6350-3-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191105090553.6350-3-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian.brauner@ubuntu.com>, David Drysdale <drysdale@google.com>, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Ras
List-Id: linux-api@vger.kernel.org

On Tue, Nov 05, 2019 at 08:05:46PM +1100, Aleksa Sarai wrote:
> @@ -1078,6 +1079,10 @@ const char *get_link(struct nameidata *nd)
>  		} else {
>  			res = get(dentry, inode, &last->done);
>  		}
> +		if (nd->flags & LOOKUP_MAGICLINK_JUMPED) {
> +			if (unlikely(nd->flags & LOOKUP_NO_MAGICLINKS))
> +				return ERR_PTR(-ELOOP);
> +		}

Minor nit - the first check probably wants unlikely() more than the
second one; it's probably noise anyway, but most of the symlinks
traversed are not going to be procfs ones, so you get test + branch
taken most of the time.

OTOH, that just might compile into
	fetch nd->flags
	and with LOOKUP_MAGICLINK_JUMPED | LOOKUP_NO_MAGICLINKS
	compare with the same constant
	unlikely branch when equal

Anyway, that's no more than a minor nit and can be dealt with later (if
at all)
