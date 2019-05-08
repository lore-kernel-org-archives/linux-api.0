From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v6 5/6] binfmt_*: scope path resolution of interpreters
Date: Tue, 07 May 2019 19:38:58 -0500
Message-ID: <87o94d6aql.fsf@xmission.com>
References: <20190506165439.9155-1-cyphar@cyphar.com>
        <20190506165439.9155-6-cyphar@cyphar.com>
        <CAG48ez0-CiODf6UBHWTaog97prx=VAd3HgHvEjdGNz344m1xKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0-CiODf6UBHWTaog97prx=VAd3HgHvEjdGNz344m1xKw@mail.gmail.com>
        (Jann Horn's message of "Mon, 6 May 2019 20:37:37 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Jann Horn <jannh@google.com> writes:
>
> In my opinion, CVE-2019-5736 points out two different problems:
>
> The big problem: The __ptrace_may_access() logic has a special-case
> short-circuit for "introspection" that you can't opt out of;

Once upon a time in a galaxy far far away I fixed a bug where we missing
ptrace_may_access checks on various proc files and systems using selinux
stopped working.  At the time selinux did not allow ptrace like access
to yourself.  The "introspection" special case was the quick and simple
work-around.

There is nothing fundamental in having the "introspection" special case
except that various lsms have probably grown to depend upon it being
there.  I expect without difficulty we could move the check down
into the various lsms.  Which would get that check out of the core
kernel code.

Then the special case would the lsms challenge to keep or remove.

Eric
