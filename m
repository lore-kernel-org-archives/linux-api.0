From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 00/10] namei: openat2(2) path resolution restrictions
Date: Fri, 12 Jul 2019 16:11:18 +0100
Message-ID: <20190712151118.GP17978@ZenIV.linux.org.uk>
References: <20190706145737.5299-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190706145737.5299-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, David Drysdale <drysdale@google.com>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <ole>
List-Id: linux-api@vger.kernel.org

On Sun, Jul 07, 2019 at 12:57:27AM +1000, Aleksa Sarai wrote:
> Patch changelog:
>   v9:
>     * Replace resolveat(2) with openat2(2). [Linus]
>     * Output a warning to dmesg if may_open_magiclink() is violated.
>     * Add an openat2(O_CREAT) testcase.

One general note for the future, BTW: for such series it's generally
a good idea to put it into a public git tree somewhere and mention that
in the announcement...
