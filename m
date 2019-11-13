From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v15 6/9] namei: LOOKUP_{IN_ROOT,BENEATH}: permit limited
 ".." resolution
Date: Wed, 13 Nov 2019 02:09:17 +0000
Message-ID: <20191113020917.GC26530@ZenIV.linux.org.uk>
References: <20191105090553.6350-1-cyphar@cyphar.com>
 <20191105090553.6350-7-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191105090553.6350-7-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian.brauner@ubuntu.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 05, 2019 at 08:05:50PM +1100, Aleksa Sarai wrote:

> One other possible alternative (which previous versions of this patch
> used) would be to check with path_is_under() if there was a racing
> rename or mount (after re-taking the relevant seqlocks). While this does
> work, it results in possible O(n*m) behaviour if there are many renames
> or mounts occuring *anywhere on the system*.

BTW, do you realize that open-by-fhandle (or working nfsd, for that matter)
will trigger arseloads of write_seqlock(&rename_lock) simply on d_splice_alias()
bringing disconnected subtrees in contact with parent?
