From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH bpf-next v8 00/11] Landlock LSM: Toward unprivileged
 sandboxing
Date: Tue, 6 Mar 2018 15:46:36 -0700
Message-ID: <20180306224636.wf5z3kujtc7r5qyh@cisco>
References: <20180227004121.3633-1-mic@digikod.net>
 <CALCETrV3OZb70o83uOG437PubwBwaUJ6SKQucq_7g1BuBOmxzg@mail.gmail.com>
 <2e06621c-08e9-dc12-9b6e-9c09d5d8f458@digikod.net>
 <CALCETrWnJ7WkkfiymyahQd7YqO0KXP4mG1pRMq7fp8LG8Bwtcw@mail.gmail.com>
 <a70b41ee-78cb-52cc-152c-ac5e43b7e45c@digikod.net>
 <CALCETrUQYp0ta4tLgUWJ79pZVwp3WRY7cp-XaPcn1WyTc=wZyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUQYp0ta4tLgUWJ79pZVwp3WRY7cp-XaPcn1WyTc=wZyg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Wil
List-Id: linux-api@vger.kernel.org

On Tue, Mar 06, 2018 at 10:33:17PM +0000, Andy Lutomirski wrote:
> >> Suppose I'm writing a container manager.  I want to run "mount" in the
> >> container, but I don't want to allow moun() in general and I want to
> >> emulate certain mount() actions.  I can write a filter that catches
> >> mount using seccomp and calls out to the container manager for help.
> >> This isn't theoretical -- Tycho wants *exactly* this use case to be
> >> supported.
> >
> > Well, I think this use case should be handled with something like
> > LD_PRELOAD and a helper library. FYI, I did something like this:
> > https://github.com/stemjail/stemshim
> 
> I doubt that will work for containers.  Containers that use user
> namespaces and, for example, setuid programs aren't going to honor
> LD_PRELOAD.

Or anything that calls syscalls directly, like go programs.

Tycho
