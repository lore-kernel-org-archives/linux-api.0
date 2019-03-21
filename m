From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH RESEND v5 0/5] namei: vfs flags to restrict path resolution
Date: Thu, 21 Mar 2019 10:06:38 -0700
Message-ID: <CALCETrV-Q4qZXGeavBPQbF6-VVz7hqvjRkbhFeYmbGiQgu5Omg@mail.gmail.com>
References: <20190320143717.2523-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190320143717.2523-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, David Drysdale <drysdale@google.com>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 20, 2019 at 7:38 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
> Now that the holiday break is over, it's time to re-send this patch
> series (with a few additions, due to new information we got from
> CVE-2019-5736 -- which this patchset mostly protected against but had
> some holes with regards to #!-style scripts).

I generally like this, but, as Linus pointed out, it will be
unfortunate if application authors see this as just another
non-portable weird Linux API and don't use it.  Would it be worthwhile
to put some thought into making it an API that other OSes might be
willing to implement?  As it stands, the openat(2) flags are getting
rather crazy in this patch set.

Aleksa had a resolveat(2) proposal that really didn't seem too bad.
