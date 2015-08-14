From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv4 man-pages 3/3] open.2: describe O_BENEATH flag
Date: Fri, 14 Aug 2015 16:30:37 +0100
Message-ID: <CAHse=S9PqpruWC3p7z_zLoO+1cHRosoafreRbKwXVL9OA1uiNg@mail.gmail.com>
References: <1439458366-8223-1-git-send-email-drysdale@google.com>
 <1439458366-8223-4-git-send-email-drysdale@google.com> <CALCETrWusE9CbQ6A1iqgBVjei-_JWL4o4ezS14JLEAbrGJmaNg@mail.gmail.com>
 <CAKgNAkj+fZJnzKbHb8UvZg-0kNfB7MQHQYoAz-dVhnkso0Uq2A@mail.gmail.com>
 <CAHse=S9HdriyqKrQRj=x3CpEFftPgVFX7p8B9efu9_mQtEvJSA@mail.gmail.com> <CALCETrXLhp6-dVq8TS0_vSQBJieP-SrabhoDJE0PZ8KpMz1m0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXLhp6-dVq8TS0_vSQBJieP-SrabhoDJE0PZ8KpMz1m0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jorge Lucangeli Obes <jorgelo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lee Campbell <leecam-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Depinet <mdepinet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>Linux FS Devel <linux>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 14, 2015 at 3:17 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Fri, Aug 14, 2015 at 2:29 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> On Fri, Aug 14, 2015 at 6:33 AM, Michael Kerrisk (man-pages)
>> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On 13 August 2015 at 19:38, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>>> On Thu, Aug 13, 2015 at 2:32 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>>>> Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>>
>>>> What's the behavior wrt fcntl(F_GETFL, etc)?
>>>
>>> I would presume that O_BENEATH is one of the so-called "file creation
>>> flags". See this paragraph of the DESCRIPTION:
>>>
>>>        In addition, zero or more file creation  flags  and  file  status
>>>        flags  can be bitwise-or'd in flags.  The file creation flags are
>>>        O_CLOEXEC, O_CREAT, O_DIRECTORY,  O_EXCL,  O_NOCTTY,  O_NOFOLLOW,
>>>        O_TMPFILE,  O_TRUNC,  and  O_TTY_INIT.  The file status flags are
>>>        all of the remaining flags listed below.  The distinction between
>>>        these  two  groups  of flags is that the file status flags can be
>>>        retrieved and (in some cases) modified; see fcntl(2) for details.
>>>
>>> David, presuming this is correct (I can't see how O_BENEATH could be a
>>> "file *status* flag"), your patch should also add O_BENEATH to the
>>> list in that paragraph.
>>
>> Yeah, O_BENEATH makes sense as a file creation flag; I'll add it
>> to that list -- thanks for spotting.
>
> Should there be a test that you can't clear O_BENEATH with F_SETFL?
>
> --Andy

I'll add a test that fcntl(F_SETFL) silently ignores the file creation flags,
including O_BENEATH.
