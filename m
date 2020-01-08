From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH RFC 1/1] mount: universally disallow mounting over symlinks
Date: Tue, 7 Jan 2020 20:39:10 -0800
Message-ID: <CALCETrX1JZV-KtU-LwAuTv4Dc2yFWdTOKUZnmN_pgbUdC-bgLw@mail.gmail.com>
References: <20191230052036.8765-1-cyphar@cyphar.com> <20191230052036.8765-2-cyphar@cyphar.com>
 <CAHk-=wjHPCQsMeK5bFOJQnrGPfVDXTAFQK4VsBZPj5u=ZgS-QA@mail.gmail.com> <20191230082847.dkriyisvu7wwxqqu@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20191230082847.dkriyisvu7wwxqqu@yavin.dot.cyphar.com>
Sender: stable-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, stable <stable@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 30, 2019 at 12:29 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
> On 2019-12-29, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Sun, Dec 29, 2019 at 9:21 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
> If allowing bind-mounts over symlinks is allowed (which I don't have a
> problem with really), it just means we'll need a few more kernel pieces
> to get this hardening to work. But these features would be useful
> outside of the problems I'm dealing with (O_EMPTYPATH and some kind of
> pidfd-based interface to grab the equivalent of /proc/self/exe and a few
> other such magic-link targets).

As one data point, I would use this ability in virtme: this would
allow me to more reliably mount over /etc/resolve.conf even when it's
a symlink.

(Perhaps I should use overlayfs instead.  Hmm.)
