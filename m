From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] MAINTAINERS: trim the file triggers for ABI/API
Date: Thu, 4 Feb 2016 20:44:42 +0100
Message-ID: <CAKgNAkidh-kMLbVDcH-+fsnx2ajHVJFpdzEZqf_F=DVKSfwNMA@mail.gmail.com>
References: <56B35A9F.1080303@gmail.com> <20160204153415.GB6066@x>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160204153415.GB6066@x>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Josh,

On 4 February 2016 at 16:34, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> On Thu, Feb 04, 2016 at 03:05:19PM +0100, Michael Kerrisk (man-pages) wrote:
>> Josh Tripplett's commit ea8f8fc8631d9f890580a94d57a18bfeb827fa2e
>
> s/Tripplett/Triplett/
>
>> was well intentioned (I even Acked it), but in practice it has mostly
>> generated (a lot of) useless noise on linux-api as developers of
>> drivers and implementers of other uninteresting changes run
>> scripts/get-maintainers.pl and unthinkingly paste the results
>> into their email clients. And that commit didn't really
>> help catch the really important API changes (new system calls,
>> new options to existing system calls, new pseudofile entries,
>> and so on). So, trim the 'F:' triggers for the "ABI/API" entry
>> in MAINTAINERS right back to the minimum.
>
> This change makes sense, but I don't think this commit message explains
> the specific changes to the file triggers.  (Also, there's a convention
> for referencing past commits.)  Might I suggest an alternate commit
> message?
>
> """
> Commit ea8f8fc8631 ("MAINTAINERS: add linux-api for review of API/ABI
> changes") added file triggers for various paths that likely indicated
> API/ABI changes.  However, catching all changes in Documentation/ABI/
> and include/uapi/ produces a large volume of mail to linux-api, rather
> than only API/ABI changes.  Drop those two entries, but leave
> include/linux/syscalls.h and kernel/sys_ni.c to catch syscall-related
> changes.
> """

Thanks. Looks like Andrew picked your version of the commit message up.

Cheers,

Michael

>> Signed-off-by: Michael Kerrisk <mtk.man-pages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  MAINTAINERS | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index f678c37..56f7a4f 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -223,9 +223,7 @@ F:  drivers/scsi/aacraid/
>>
>>  ABI/API
>>  L:     linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> -F:     Documentation/ABI/
>>  F:     include/linux/syscalls.h
>> -F:     include/uapi/
>>  F:     kernel/sys_ni.c
>>
>>  ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
>> --
>> 2.5.0



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
