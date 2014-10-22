From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv5 man-pages 3/3] execveat.2: initial man page for execveat(2)
Date: Wed, 22 Oct 2014 21:13:39 +0100
Message-ID: <CAHse=S951SJsyEf7KX38Q1OfaRUwcZ_f9NMkB8nPfQ1CSZzfuQ@mail.gmail.com>
References: <1413978269-17274-1-git-send-email-drysdale@google.com>
 <1413978269-17274-4-git-send-email-drysdale@google.com> <87wq7sgfah.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87wq7sgfah.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 22, 2014 at 6:55 PM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
>> +.TH EXECVEAT 2 2014-04-02 "Linux" "Linux Programmer's Manual"
>> +.SH NAME
>> +execveat \- execute program relative to a directory file descriptor
>> +.SH SYNOPSIS
>> +.B #include <unistd.h>
>> +.sp
>> +.BI "int execve(int " fd ", const char *" pathname ","
>             ^^^^^^ That needs to be execveat

Ah yes, so it does -- thanks for spotting.
