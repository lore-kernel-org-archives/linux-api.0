From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 9/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Wed, 25 Jun 2014 20:20:12 +0200
Message-ID: <20140625182012.GA19437@redhat.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org> <1403642893-23107-10-git-send-email-keescook@chromium.org> <20140625142121.GD7892@redhat.com> <CAGXu5jJtLrjbobZC1FD4WV-Jm2p7cRGa1aSPK-d_isnfCZAHdA@mail.gmail.com> <20140625165209.GA14720@redhat.com> <CAGXu5jLHDew1fifGY_mWgwcH7evm0T8rqSnBrw4XpoAXGK+t-Q@mail.gmail.com> <20140625172410.GA17133@redhat.com> <CAGXu5jKkLS3++_dtWHnjWudVvaSR9DRwjNG3q00SmSy6XoCMaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKkLS3++_dtWHnjWudVvaSR9DRwjNG3q00SmSy6XoCMaw@mail.gmail.com>
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
> On Wed, Jun 25, 2014 at 10:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > However, do_execve() takes cred_guard_mutex at the start in prepare_bprm_creds()
> > and drops it in install_exec_creds(), so it should solve the problem?
>
> I can't tell yet. I'm still trying to understand the order of
> operations here. It looks like de_thread() takes the sighand lock.
> do_execve_common does:
>
> prepare_bprm_creds (takes cred_guard_mutex)
> check_unsafe_exec (checks nnp to set LSM_UNSAFE_NO_NEW_PRIVS)
> prepare_binprm (handles suid escalation, checks nnp separately)
>     security_bprm_set_creds (checks LSM_UNSAFE_NO_NEW_PRIVS)
> exec_binprm
>     load_elf_binary
>         flush_old_exec
>             de_thread (takes and releases sighand->lock)
>         install_exec_creds (releases cred_guard_mutex)

Yes, and note that when cred_guard_mutex is dropped all other threads
are already killed,

> I don't see a way to use cred_guard_mutex during tsync (which holds
> sighand->lock) without dead-locking. What were you considering here?

Just take/drop current->signal->cred_guard_mutex along with ->siglock
in seccomp_set_mode_filter() ? Unconditionally on depending on
SECCOMP_FILTER_FLAG_TSYNC.

Oleg.
