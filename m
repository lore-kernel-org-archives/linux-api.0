From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v6 5/6] binfmt_*: scope path resolution of interpreters
Date: Sat, 11 May 2019 13:43:44 -0400
Message-ID: <CAHk-=wgo-X9pDbVf8khfDsgEKn3wSvLJkB890OxHL+42Hosypw@mail.gmail.com>
References: <20190506165439.9155-1-cyphar@cyphar.com> <20190506165439.9155-6-cyphar@cyphar.com>
 <CAG48ez0-CiODf6UBHWTaog97prx=VAd3HgHvEjdGNz344m1xKw@mail.gmail.com>
 <20190506191735.nmzf7kwfh7b6e2tf@yavin> <20190510204141.GB253532@google.com>
 <CALCETrW2nn=omqJb4p+m-BDsCOhg+YZQ3ELd4BdhODV3G44gfA@mail.gmail.com>
 <20190510225527.GA59914@google.com> <C60DC580-854D-478D-AF23-5F29FB7C3E50@amacapital.net>
 <CAHk-=wh1JJD_RabMaFfinsAQp1vHGJOQ1rKqihafY=r7yHc8sQ@mail.gmail.com>
 <CAHk-=whOL-NBso8X5S8s597yZEOMBoU8chkMFVTi8b-ff2qARg@mail.gmail.com> <20190511173113.qhqmv5q5f74povix@yavin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190511173113.qhqmv5q5f74povix@yavin>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, May 11, 2019 at 1:31 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
> Yup, I've dropped the patch for the next version. (To be honest, I'm not
> sure why I included any of the other flags -- the only one that would've
> been necessary to deal with CVE-2019-5736 was AT_NO_MAGICLINKS.)

I do wonder if we could try to just set AT_NO_MAGICLINKS
unconditionally for execve() (and certainly for the suid case).

I'd rather try to do these things across the board, than have "suid
binaries are treated specially" if at all possible.

The main use case for having /proc/<pid>/exe thing is for finding open
file descriptors, and for 'ps' kind of use, or to find the startup
directory when people don't populate the execve() environment fully
(ie "readlink(/proc/self/exe)" is afaik pretty common.

Sadly, googling for

    execve /proc/self/exe

does actually find hits, including one that implies that chrome does
exactly that.  So it might not be possible.

Somewhat odd, but it does just confirm the whole "users will at some
point do everything in their power to use every odd special case,
intended or not".

                  Linus
