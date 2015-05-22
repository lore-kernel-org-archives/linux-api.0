From: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] [RFC] fs, proc: don't guard /proc/<pid>/task/<tid>/children
 on CONFIG_CHECKPOINT_RESTORE
Date: Fri, 22 May 2015 14:49:01 +0200
Message-ID: <CALdWxct549hxJHPGM+7VtZ7uiyD_JVp0wUkG52XKTOABxKhCpw@mail.gmail.com>
References: <1432204221-1933-1-git-send-email-alban@endocode.com>
	<CALCETrVbaKnqj7qLBr+ufirPHfdjAYzo6_e362N0muVGnH7HTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVbaKnqj7qLBr+ufirPHfdjAYzo6_e362N0muVGnH7HTg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Iago Lopez Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 21, 2015 at 11:47 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Thu, May 21, 2015 at 3:30 AM, Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> From: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
>>
>> commit 818411616baf ("fs, proc: introduce
>> /proc/<pid>/task/<tid>/children entry") introduced the children entry
>> for checkpoint restore and the file is only available on kernels
>> configured with CONFIG_EXPERT and CONFIG_CHECKPOINT_RESTORE.
>>
>> This is available in most distributions (Fedora, Debian, Ubuntu, CoreOS)
>> because they usually enable CONFIG_EXPERT and CONFIG_CHECKPOINT_RESTORE.
>> But Arch does not enable CONFIG_EXPERT or CONFIG_CHECKPOINT_RESTORE.
>>
>> However, the children proc file is useful outside of checkpoint restore.
>> I would like to use it in rkt. The rkt process exec() another program it
>> does not control, and that other program will fork()+exec() a child
>> process. I would like to find the pid of the child process from an
>> external tool without iterating in /proc over all processes to find
>> which one has a parent pid equal to rkt.
>>
>> Since the children proc file is useful outside of checkpoint-restore,
>> I am removing the guard on CONFIG_CHECKPOINT_RESTORE.
>
> I sent an essentially identical patch a couple years ago, and it got
> some interesting comments:
>
> http://lkml.kernel.org/g/0e00e9073855c02a382d49ba1ede9c4fda3451b7.1372189875.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org

Thanks for the pointer, I didn't see it.

> See also:
>
> http://lkml.kernel.org/g/5f9a6b3ab75b12f2c5ba61ea1f6f3b08e9952b55.1372280661.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org

Your paragraph seems good to have in the documentation but I am also
not qualified to comment on the behavior.
