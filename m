From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 01/10] namei: obey trailing magic-link DAC permissions
Date: Fri, 12 Jul 2019 07:36:18 +0100
Message-ID: <20190712063617.GJ17978@ZenIV.linux.org.uk>
References: <20190706145737.5299-1-cyphar@cyphar.com>
 <20190706145737.5299-2-cyphar@cyphar.com>
 <20190712041454.GG17978@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190712041454.GG17978@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian@brauner.io>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-alpha@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 12, 2019 at 05:14:54AM +0100, Al Viro wrote:

> That's not quite guaranteed (it is possible to bind a symlink on top
> of a regular file, and you will get LOOKUP_JUMPED on the entry into
> trailing_symlink() when looking the result up).  Moreover, why bother
> with LOOKUP_JUMPED here?  See that
> 	nd->last_type = LAST_BIND;
> several lines prior?  That's precisely to be able to recognize those
> suckers.

... except that this won't work these days (once upon a time it used
to, but that had been a long time ago).  However, that doesn't change
the fact that the test is really wrong.  So let's do it right:

* set a new flag along with LOOKUP_JUMPED in nd_jump_link()
* clear it in get_link() right before
	res = READ_ONCE(inode->i_link);
* check it in trailing_symlink() (or callers thereof)

The rest of comments stand, AFAICS.
