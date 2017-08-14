From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v4 0/4] seccomp: Implement SECCOMP_RET_KILL_PROCESS action
Date: Mon, 14 Aug 2017 14:10:54 -0700
Message-ID: <CAGXu5jKbpJ8YUZX5G_4eyk5WoScv9sSnU8xMes=pXf2C3u7PfA@mail.gmail.com>
References: <1502489117-70522-1-git-send-email-keescook@chromium.org> <CAHC9VhTeotOHSD+qKG=TF-SidFT0-46GnE_pz=rjGt6gzr1mcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHC9VhTeotOHSD+qKG=TF-SidFT0-46GnE_pz=rjGt6gzr1mcw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Fabricio Voznika <fvoznika-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tycho Andersen <tycho-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mathias Svensson <idolf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 14, 2017 at 1:46 PM, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
> On Fri, Aug 11, 2017 at 6:05 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> This series is the result of Fabricio, Tyler, Will and I going around a
>> few times on possible solutions for finding a way to enhance RET_KILL
>> to kill the process group. There's a lot of ways this could be done,
>> but I wanted something that felt cleanest. My sense of what constitutes
>> "clean" has shifted a few times, and after continually running into
>> weird corner cases, I decided to make changes to the seccomp action mask,
>> which shouldn't be too invasive to userspace as it turns out. Everything
>> else becomes much easier, especially after being able to use Tyler's
>> new SECCOMP_GET_ACTION_AVAIL operation.
>>
>> This renames SECCOMP_RET_KILL to SECCOMP_RET_KILL_THREAD and adds
>> SECCOMP_RET_KILL_PROCESS.
>
> I just took a very quick look and I'm not seeing anything that would
> cause any backwards compatibility issues for libseccomp.  You could
> try running the libseccomp tests against a patched kernel to make
> sure; the README has all the info you need (pay special attention to
> the "live" tests, although those are pretty meager at the moment).

Ah-ha, perfect. Ran it now and yup, these all pass. Thanks!

-Kees

-- 
Kees Cook
Pixel Security
