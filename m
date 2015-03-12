From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 13/14] kdbus: add walk-through user space example
Date: Thu, 12 Mar 2015 17:34:40 +0100
Message-ID: <CANq1E4QVY4ZpjL4=80Xzkn_5JCAyNqu=W-XXJAf_CCycj6Ms6A@mail.gmail.com>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
	<1425906560-13798-14-git-send-email-gregkh@linuxfoundation.org>
	<5501A848.5080402@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5501A848.5080402-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Thu, Mar 12, 2015 at 3:52 PM, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On 03/09/2015 09:09 AM, Greg Kroah-Hartman wrote:
>> diff --git a/samples/kdbus/Makefile b/samples/kdbus/Makefile
>> new file mode 100644
>> index 000000000000..d009025369f4
>> --- /dev/null
>> +++ b/samples/kdbus/Makefile
>> @@ -0,0 +1,10 @@
>> +# kbuild trick to avoid linker error. Can be omitted if a module is built.
>> +obj- := dummy.o
>> +
>> +hostprogs-y += kdbus-workers
>> +
>> +always := $(hostprogs-y)
>> +
>> +HOSTCFLAGS_kdbus-workers.o +=                \
>> +     -I$(objtree)/usr/include/       \
>> +     -I$(objtree)/include/uapi/
>         -lrt
>
> For older glibcs, otherwise clock_gettime() isn't found on linking.

Right, thanks! Fixed in "[PATCH] samples/kdbus: add -lrt".

Thanks
David
