From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: Simplfying copy_siginfo_to_user
Date: Mon, 24 Jul 2017 14:01:59 -0500
Message-ID: <87r2x54q1k.fsf@xmission.com>
References: <87o9shg7t7.fsf_-_@xmission.com>
	<20170718140651.15973-7-ebiederm@xmission.com>
	<CA+55aFyKsmf+BpYjcH30MGpHTDJ=zgYPx6kwyEB9CXXFxj_xsw@mail.gmail.com>
	<878tjlbqpt.fsf@xmission.com> <8760ek5ics.fsf_-_@xmission.com>
	<CA+55aFyH5W2doo9vxXta_-pXfNXqQ19d7z48k1hmfAot+aJvMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CA+55aFyH5W2doo9vxXta_-pXfNXqQ19d7z48k1hmfAot+aJvMw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Linus Torvalds's message of "Mon, 24 Jul 2017 10:43:34 -0700")
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

Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> writes:

> On Sat, Jul 22, 2017 at 1:25 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> I played with some clever changes such as limiting the copy to 48 bytes,
>> disabling the memset and the like but I could not get a strong enough
>> signal to say that any one change removed the extra or a clear part of
>> it 20ns.
>
> What CPU did you use? Because the SMAP bit in particular matters.
>
> The field-by-field copies are extremely slow on modern CPU's that
> implement SMAP, unless you also use the special "unsafe_put_user()"
> code (or the nasty old put_user_ex() code that some of the x86 signal
> code uses).
>
> So one of the advantages of just copy_to_user() ends up being visible
> only on Broadwell+ (or whatever the SMAP cutoff is).

Good point.

The cpu I was testing on was an AMD A10.  I don't actually have a cpu
that supports SMAP handy.

If you would like I can post the minimal patches and benckmark so anyone
who is interested could reproduce this for themselves.

I suspect that if it is down to only 20ns without SMAP this will
definitely be a performance improvement in the presence of SMAP.

Eric
