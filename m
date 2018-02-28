From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH bpf-next v8 08/11] landlock: Add ptrace restrictions
Date: Wed, 28 Feb 2018 00:09:13 +0000
Message-ID: <CALCETrW5v1sa17jPJuTskW5vdvcXqjFtRvAd0auWBmKvnAX-zQ@mail.gmail.com>
References: <20180227004121.3633-1-mic@digikod.net> <20180227004121.3633-9-mic@digikod.net>
 <CALCETrUpDbusLPyZijR6MpZd5-0x0d9KuQHBaavqP1_GZ2tjfg@mail.gmail.com>
 <D6B96EE0-8932-4845-BFA5-4C65E5189AFB@amacapital.net> <0e7d0512-12a3-568d-aa55-3def4b91c6d0@digikod.net>
 <CALCETrUTiUeV71jgYWup0CZwG8eQ3=W7X5FgJqmgPxnYbFsccw@mail.gmail.com>
 <CALCETrV_BVc44YYq6g8PCpeUYuqQaooVoQSQ7Y=VpuaBshQgQg@mail.gmail.com> <f560a30d-10fd-31fc-adba-911961915937@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f560a30d-10fd-31fc-adba-911961915937@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@t>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 28, 2018 at 12:00 AM, Mickaël Salaün <mic@digikod.net> wrote:
>
> On 28/02/2018 00:23, Andy Lutomirski wrote:
>> On Tue, Feb 27, 2018 at 11:02 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>> On Tue, Feb 27, 2018 at 10:14 PM, Mickaël Salaün <mic@digikod.net> wrote:
>>>>
>>>
>>> I think you're wrong here.  Any sane container trying to use Landlock
>>> like this would also create a PID namespace.  Problem solved.  I still
>>> think you should drop this patch.
>
> Containers is one use case, another is build-in sandboxing (e.g. for web
> browser…) and another one is for sandbox managers (e.g. Firejail,
> Bubblewrap, Flatpack…). In some of these use cases, especially from a
> developer point of view, you may want/need to debug your applications
> (without requiring to be root). For nested Landlock access-controls
> (e.g. container + user session + web browser), it may not be allowed to
> create a PID namespace, but you still want to have a meaningful
> access-control.
>

The consideration should be exactly the same as for normal seccomp.
If I'm in a container (using PID namespaces + seccomp) and a run a web
browser, I can debug the browser.

If there's a real use case for adding this type of automatic ptrace
protection, then by all means, let's add it as a general seccomp
feature.
