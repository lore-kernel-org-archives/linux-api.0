From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Simplfying copy_siginfo_to_user
Date: Sat, 22 Jul 2017 15:25:55 -0500
Message-ID: <8760ek5ics.fsf_-_@xmission.com>
References: <87o9shg7t7.fsf_-_@xmission.com>
	<20170718140651.15973-7-ebiederm@xmission.com>
	<CA+55aFyKsmf+BpYjcH30MGpHTDJ=zgYPx6kwyEB9CXXFxj_xsw@mail.gmail.com>
	<878tjlbqpt.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <878tjlbqpt.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
	"Tue, 18 Jul 2017 12:27:26 -0500")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Willy Tarreau <w@1wt.eu>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:

> Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> writes:
>
>> On Tue, Jul 18, 2017 at 7:06 AM, Eric W. Biederman
>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>> struct siginfo is a union and the kernel since 2.4 has been hiding a union
>>> tag in the high 16bits of si_code using the values:
>>> __SI_KILL
>>> __SI_TIMER
>>> __SI_POLL
>>> __SI_FAULT
>>> __SI_CHLD
>>> __SI_RT
>>> __SI_MESGQ
>>> __SI_SYS
>>>
>>> While this looks plausible on the surface, in practice this situation has
>>> not worked well.
>>
>> So on the whole I think we just need to do this, but the part I really
>> hate about this series is still this the siginfo_layout() part.
>>
>> I can well believe that it is needed for the compat case. siginfo is a
>> piece of crap crazy type, and re-ordering fields for compat is
>> something we are always going to have to do.
>>
>> But for the native case, the *only* reason we do not just copy the
>> siginfo as-is seems to be that it's just too big, due to other bad
>> design decisions in siginfo ("let's make sure it's big enough by
>> allocating 512 bytes for it).
>>
>> And afaik, absolutely nobody uses more than about 36 bytes of that
>> 512-byte _sifields union (and that one use is SIGILL with three
>> pointers and three integers and some padding.
>>
>> So why don't we just say "screw this idiotic layout crap, and just
>> unconditionally copy that much smaller maximum of bytes"?
>>
>> Leave that layout thing purely for compat handling.
>
> I completely agree.

So I just did some measurements to see what the performance impact is of
doing the simple and obvious thing of always copying the entire siginfo
around.  There is a fair amount of variation in my timings but for
the whole change I see about a 20ns increase in time taken to send
a signal with siginfo from the current process to the current process.
AKA timing kill(getpid(),...). 

I played with some clever changes such as limiting the copy to 48 bytes,
disabling the memset and the like but I could not get a strong enough
signal to say that any one change removed the extra or a clear part of
it 20ns.

Do we care about those 20ns for signal deliver?  I suspect from my
previous numbers that if Andy can get signal delivery to use sysret
it will more than make up for the small increase in cost here.

Eric
