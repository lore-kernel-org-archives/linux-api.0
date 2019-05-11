From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v6 5/6] binfmt_*: scope path resolution of interpreters
Date: Sat, 11 May 2019 13:26:55 -0400
Message-ID: <CAHk-=whOL-NBso8X5S8s597yZEOMBoU8chkMFVTi8b-ff2qARg@mail.gmail.com>
References: <20190506165439.9155-1-cyphar@cyphar.com> <20190506165439.9155-6-cyphar@cyphar.com>
 <CAG48ez0-CiODf6UBHWTaog97prx=VAd3HgHvEjdGNz344m1xKw@mail.gmail.com>
 <20190506191735.nmzf7kwfh7b6e2tf@yavin> <20190510204141.GB253532@google.com>
 <CALCETrW2nn=omqJb4p+m-BDsCOhg+YZQ3ELd4BdhODV3G44gfA@mail.gmail.com>
 <20190510225527.GA59914@google.com> <C60DC580-854D-478D-AF23-5F29FB7C3E50@amacapital.net>
 <CAHk-=wh1JJD_RabMaFfinsAQp1vHGJOQ1rKqihafY=r7yHc8sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wh1JJD_RabMaFfinsAQp1vHGJOQ1rKqihafY=r7yHc8sQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>Linu
List-Id: linux-api@vger.kernel.org

On Sat, May 11, 2019 at 1:21 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Notice? None of the real problems are about execve or would be solved
> by any spawn API. You just think that because you've apparently been
> talking to too many MS people that think fork (and thus indirectly
> execve()) is bad process management.

Side note: a good policy has been (and remains) to make suid binaries
not be dynamically linked. And in the absence of that, the dynamic
linker at least resets the library path when it notices itself being
dynamic, and it certainly doesn't inherit any open flags from the
non-trusted environment.

And by the same logic, a suid interpreter must *definitely* should not
inherit any execve() flags from the non-trusted environment. So I
think Aleksa's patch to use the passed-in open flags is *exactly* the
wrong thing to do for security reasons. It doesn't close holes, it
opens them.

                Linus
