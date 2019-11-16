From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v16 02/12] namei: allow nd_jump_link() to produce errors
Date: Sat, 16 Nov 2019 00:37:02 +0000
Message-ID: <20191116003702.GX26530@ZenIV.linux.org.uk>
References: <20191116002802.6663-1-cyphar@cyphar.com>
 <20191116002802.6663-3-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191116002802.6663-3-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 16, 2019 at 11:27:52AM +1100, Aleksa Sarai wrote:
> +	error = nd_jump_link(&path);
> +	if (error)
> +		path_put(&path);

> +	error = nd_jump_link(&ns_path);
> +	if (error)
> +		path_put(&ns_path);

> +	error = nd_jump_link(&path);
> +	if (error)
> +		path_put(&path);

3 calls.  Exact same boilerplate in each to handle a failure case.
Which spells "wrong calling conventions"; it's absolutely clear
that we want that path_put() inside nd_jump_link().

The rule should be this: reference that used to be held in
*path is consumed in any case.  On success it goes into
nd->path, on error it's just dropped, but in any case, the
caller has the same refcounting environment to deal with.

If you need the same boilerplate cleanup on failure again and again,
the calling conventions are wrong and need to be fixed.

And I'm not sure that int is the right return type here, to be honest.
void * might be better - return ERR_PTR() or NULL, so that the value
could be used as return value of ->get_link() that calls that thing.
