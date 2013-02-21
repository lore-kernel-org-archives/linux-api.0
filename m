From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 them from a queue
Date: Thu, 21 Feb 2013 14:30:26 +0400
Message-ID: <5125F742.2050707@parallels.com>
References: <1360768595-31943-1-git-send-email-avagin@openvz.org> <CAKgNAkicAGEkvNFnSso__wK6QKao8jyDu5yuRmeyUOeaXLGChw@mail.gmail.com> <5123BC20.9040405@parallels.com> <20130219193424.GA9606@redhat.com> <5123D6D6.7010904@parallels.com> <20130220223703.GB16194@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130220223703.GB16194-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/21/2013 02:37 AM, Oleg Nesterov wrote:
> On 02/19, Pavel Emelyanov wrote:
>>
>> On 02/19/2013 11:34 PM, Oleg Nesterov wrote:
>>> But, given that every PEEK does list_for_each() until it finds the
>>> necessary sequence number, I am wondering how this O(n**2) will work
>>> if you want to dump 126065 signals ;)
>>
>> Isn't it the great reason for making the addr point to a structure, that
>> would look like
>>
>> struct siginfo_peek_arg {
>> 	unsigned flags; /* all bits but 0th, that selects between private/shared
>> 			   queues, should be zero */
>> 	unsigned int off; /* from which siginfo to start */
>> 	unsigned int nr; /* how may siginfos to take */
>> };
> 
> I am fine either way, to me everything looks better than signalfd
> hacks.
> 
> But if you meant "avoid n^2", this won't help? You can't do
> copy_siginfo_to_user() under ->siglock, so you need to restart
> list_for_each() anyway.

Or allocate intermediate buffer putting the siginfo's there.

> Oleg.

Thanks,
Pavel
