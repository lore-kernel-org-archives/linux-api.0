From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Mon, 20 Oct 2014 14:48:45 +0100
Message-ID: <CAHse=S-Xyk7CFn=tAGzo+tuUFt+04aBw+mGQmi=kWAaBJGALBw@mail.gmail.com>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
 <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com> <87zjcszz8y.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87zjcszz8y.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Oct 19, 2014 at 1:20 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>
>> [Added Eric Biederman, since I think your tree might be a reasonable
>> route forward for these patches.]
>>
>> On Thu, Jun 5, 2014 at 6:40 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>> Resending, adding cc:linux-api.
>>>
>>> Also, it may help to add a little more background -- this patch is
>>> needed as a (small) part of implementing Capsicum in the Linux kernel.
>>>
>>> Capsicum is a security framework that has been present in FreeBSD since
>>> version 9.0 (Jan 2012), and is based on concepts from object-capability
>>> security [1].
>>>
>>> One of the features of Capsicum is capability mode, which locks down
>>> access to global namespaces such as the filesystem hierarchy.  In
>>> capability mode, /proc is thus inaccessible and so fexecve(3) doesn't
>>> work -- hence the need for a kernel-space
>>
>> I just found myself wanting this syscall for another reason: injecting
>> programs into sandboxes or otherwise heavily locked-down namespaces.
>>
>> For example, I want to be able to reliably do something like nsenter
>> --namespace-flags-here toybox sh.  Toybox's shell is unusual in that
>> it is more or less fully functional, so this should Just Work (tm),
>> except that the toybox binary might not exist in the namespace being
>> entered.  If execveat were available, I could rig nsenter or a similar
>> tool to open it with O_CLOEXEC, enter the namespace, and then call
>> execveat.
>>
>> Is there any reason that these patches can't be merged more or less as
>> is for 3.19?
>
> Yes.  There is a silliness in how it implements fexecve.  The fexecve
> case should be use the empty string "" not a NULL pointer to indication
> that.  That change will then harmonize execveat with the other ...at
> system calls and simplify the code and remove a special case.  I believe
> using the empty string "" requires implementing the AT_EMPTY_PATH flag.

Good point -- I'll shift to "" + AT_EMPTY_PATH.

> For sandboxes execveat seems to make a great deal of sense.  I can
> get the same functionality by passing in a directory file descriptor
> calling fchdir and execve so this should not introduce any new security
> holes.  And using the final file descriptor removes a race.
>
> AT_SYMLINK_NOFOLLOW seems to have some limited utility as well, although
> for exec I don't know what problems it can solve.
>
> Until I am done moving I won't have time to pick this up, and the code
> clearly needs another revision but I will be happy to work to see that
> we get a sane execveat implemented.

If it helps, I can push out another revision in the next couple of days.

> Eric
>
> p.s.  I don't believe there are any namespaces issues where doing
> something with execveat flags make sense.
>
>
