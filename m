From: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: kdbus: add node and filesystem implementation
Date: Fri, 21 Nov 2014 12:03:51 -0500
Message-ID: <546F7077.4010200@oracle.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-7-git-send-email-gregkh@linuxfoundation.org> <546F606D.40407@oracle.com> <CANq1E4QkXv9Ak6eT+NZPsy+5nTGKE8oypLvdr97cFcvmtigS_A@mail.gmail.com> <20141121165638.GA24866@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141121165638.GA24866-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/21/2014 11:56 AM, Greg Kroah-Hartman wrote:
>>> Maybe it's worth basing your git tree on top of Al's rather than a random
>>> > > -rc, since it's now a filesystem?
>> > 
>> > Sure, sounds good.
> No, I'll keep it as is, we can handle the merge issues later when it
> hits Linus's tree, this makes it easier for me and others to test it
> out properly.

It should be hitting -next, not Linus's tree. This is why we have an
integration tree, no?


Thanks,
Sasha
