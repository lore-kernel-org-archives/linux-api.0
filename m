From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 them from a queue
Date: Tue, 19 Feb 2013 21:53:36 +0400
Message-ID: <5123BC20.9040405@parallels.com>
References: <1360768595-31943-1-git-send-email-avagin@openvz.org> <CAKgNAkicAGEkvNFnSso__wK6QKao8jyDu5yuRmeyUOeaXLGChw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkicAGEkvNFnSso__wK6QKao8jyDu5yuRmeyUOeaXLGChw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/19/2013 04:15 PM, Michael Kerrisk (man-pages) wrote:
> On Wed, Feb 13, 2013 at 4:16 PM, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>> This patch adds a new ptrace request PTRACE_PEEKSIGINFO.
>>
>> This request is used to retrieve information about a signal with the
>> specified sequence number. A siginfo_t structure is copied from the child
>> to location data in the parent.
>>
>> The low 16 bits of addr contains a sequence number of signal in a queue:
> 
> I think 16 bits is probably not enough.... Already, on the "out of the
> box" system that I have at hand, one can queue more than 2^16-1
> signals:
> 
>     $ cat /proc/$$/status | grep SigQ
>     SigQ:	2/126065

Yup :( Well, actually it would be enough to have only 1 bit as "flags"
and the rest (31 at least) for the number. But taking into account
Oleg's wish to have an ability to extend the amount of flags in the
future, we should make addr point to something like

struct siginfo_peek_options {
	unsigned int flags;
	unsigned int pos;
};

and force flags to contain zero in all the bits but one, and this
latter bit is to select between private or shared queue. In this case
the patch loses its main advantage -- the simplicity.

Oleg, please, suggest which way would be more preferable?

> Cheers,
> 
> Michael
