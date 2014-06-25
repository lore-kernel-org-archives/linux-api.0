From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 9/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Wed, 25 Jun 2014 18:52:09 +0200
Message-ID: <20140625165209.GA14720@redhat.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org> <1403642893-23107-10-git-send-email-keescook@chromium.org> <20140625142121.GD7892@redhat.com> <CAGXu5jJtLrjbobZC1FD4WV-Jm2p7cRGa1aSPK-d_isnfCZAHdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJtLrjbobZC1FD4WV-Jm2p7cRGa1aSPK-d_isnfCZAHdA@mail.gmail.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 06/25, Kees Cook wrote:
>
> On Wed, Jun 25, 2014 at 7:21 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > But. Doesn't this change add a new security hole?
> >
> > Obviously, we should not allow to install a filter and then (say) exec
> > a suid binary, that is why we have no_new_privs/LSM_UNSAFE_NO_NEW_PRIVS.
> >
> > But what if "thread->seccomp.filter = caller->seccomp.filter" races with
> > any user of task_no_new_privs() ? Say, suppose this thread has already
> > passed check_unsafe_exec/etc and it is going to exec the suid binary?
>
> Oh, ew. Yeah. It looks like there's a cred lock to be held to combat this?

Yes, cred_guard_mutex looks like an obvious choice... Hmm, but somehow
initially I thought that the fix won't be simple. Not sure why.

Yes, at least this should close the race with suid-exec. And there are no
other users. Except apparmor, and I hope you will check it because I simply
do not know what it does ;)

> I wonder if changes to nnp need to "flushed" during syscall entry
> instead of getting updated externally/asynchronously? That way it
> won't be out of sync with the seccomp mode/filters.
>
> Perhaps secure computing needs to check some (maybe seccomp-only)
> atomic flags and flip on the "real" nnp if found?

Not sure I understand you, could you clarify?

But I was also worried that task_no_new_privs(current) is no longer stable
inside the syscall paths, perhaps this is what you meant? However I do not
see something bad here... And this has nothing to do with the race above.



Also. Even ignoring no_new_privs, SECCOMP_FILTER_FLAG_TSYNC is not atomic
and we can do nothing with this fact (unless it try to freeze the thread
group somehow), perhaps it makes sense to document this somehow.

I mean, suppose you want to ensure write-to-file is not possible, so you
do seccomp(SECCOMP_FILTER_FLAG_TSYNC, nack_write_to_file_filter). You can't
assume that this has effect right after seccomp() returns, this can obviously
race with a sub-thread which has already entered sys_write().

Once again, I am not arguing, just I think it makes sense to at least mention
the limitations during the discussion.

Oleg.
