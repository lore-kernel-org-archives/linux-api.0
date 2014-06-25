From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v8 9/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Wed, 25 Jun 2014 11:31:48 -0700
Message-ID: <CAGXu5jLh-a2x0N+kHW7qbZSW0gOPs8v05EzBFkMYQwhft8o2aA@mail.gmail.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
	<1403642893-23107-10-git-send-email-keescook@chromium.org>
	<20140625142121.GD7892@redhat.com>
	<CAGXu5jJtLrjbobZC1FD4WV-Jm2p7cRGa1aSPK-d_isnfCZAHdA@mail.gmail.com>
	<20140625165209.GA14720@redhat.com>
	<CAGXu5jLHDew1fifGY_mWgwcH7evm0T8rqSnBrw4XpoAXGK+t-Q@mail.gmail.com>
	<20140625172410.GA17133@redhat.com>
	<CAGXu5jKkLS3++_dtWHnjWudVvaSR9DRwjNG3q00SmSy6XoCMaw@mail.gmail.com>
	<20140625182012.GA19437@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140625182012.GA19437-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 25, 2014 at 11:20 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 06/25, Kees Cook wrote:
>>
>> On Wed, Jun 25, 2014 at 10:24 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >
>> > However, do_execve() takes cred_guard_mutex at the start in prepare_bprm_creds()
>> > and drops it in install_exec_creds(), so it should solve the problem?
>>
>> I can't tell yet. I'm still trying to understand the order of
>> operations here. It looks like de_thread() takes the sighand lock.
>> do_execve_common does:
>>
>> prepare_bprm_creds (takes cred_guard_mutex)
>> check_unsafe_exec (checks nnp to set LSM_UNSAFE_NO_NEW_PRIVS)
>> prepare_binprm (handles suid escalation, checks nnp separately)
>>     security_bprm_set_creds (checks LSM_UNSAFE_NO_NEW_PRIVS)
>> exec_binprm
>>     load_elf_binary
>>         flush_old_exec
>>             de_thread (takes and releases sighand->lock)
>>         install_exec_creds (releases cred_guard_mutex)
>
> Yes, and note that when cred_guard_mutex is dropped all other threads
> are already killed,
>
>> I don't see a way to use cred_guard_mutex during tsync (which holds
>> sighand->lock) without dead-locking. What were you considering here?
>
> Just take/drop current->signal->cred_guard_mutex along with ->siglock
> in seccomp_set_mode_filter() ? Unconditionally on depending on
> SECCOMP_FILTER_FLAG_TSYNC.

Yeah, this looks good. *whew* Testing it now, so far so good.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
