From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 08/15] kexec: New syscall kexec_file_load() declaration
Date: Fri, 27 Jun 2014 14:20:24 +0200
Message-ID: <CAKgNAkioWzEgTXUP-r9u+WvkhqfX4=76gtsKs0AE5SHyT2TL=Q@mail.gmail.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-9-git-send-email-vgoyal@redhat.com> <20140626204303.GE11136@redhat.com>
 <CALCETrU8mixFxpS2Bt2Q7S08zUFxZwE1zfqHw8PEetqewgR7RQ@mail.gmail.com> <20140627115057.GC13337@redhat.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140627115057.GC13337-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kexec Mailing List <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, WANG Chao <chaowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 27, 2014 at 1:50 PM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, Jun 26, 2014 at 02:03:17PM -0700, Andy Lutomirski wrote:
>> On Thu, Jun 26, 2014 at 1:43 PM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Thu, Jun 26, 2014 at 04:33:37PM -0400, Vivek Goyal wrote:
>> >> This is the new syscall kexec_file_load() declaration/interface. I have
>> >> reserved the syscall number only for x86_64 so far. Other architectures
>> >> (including i386) can reserve syscall number when they enable the support
>> >> for this new syscall.
>> >>
>> >> Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >
>> > +.BR KEXEC_FILE_NO_INITRAMFS
>> > +Loading initrd/initramfs is optional. Specify this flag if no initramfs
>> > +is being loaded. If this flag is set, kernel will ignore the value passed
>> > +in
>>
>> This seems pointless.  Why not just pass -1 for initrd_fd to indicate
>> that no initrd is needed?
>
> I was not sure whether negative fd should be treated as error and system
> call should fail or it should be treated as user does not want to load
> initrd and system call succeeds.
>
> I was concerned about the cases where application does an fd = open(),
> operation fails and fd contains -1. Caller does not check fd and
> passed it to kexec system call.
>
> I thought that in such cases we should error out saying initrd fd is
> not valid. Instead of continuing and loading kernel without initrd. A
> user might be surprised.
>
> This is little defensive programming. But I am open to change it if
> the perception is that above is not a valid concern.

Your logic for using a flag rather than -1 sounds reasonable to me.
The nearest precedent I can think of offhand is mmap(), which also
takes a file descriptor argument for some use cases. However, if
MAP_ANONYMOUS is specified, no file descriptor ir required. The
treatment of the 'fd' argument in that case depends on the system. On
Linux, the fd argument is just ignored. However, many other systems
require 'fd' to be negative when MAP_ANONYMOUS is specified; one
presumes as a kind of safety check.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
