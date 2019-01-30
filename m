From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Wed, 30 Jan 2019 07:24:00 -0600
Message-ID: <877eemth1r.fsf@xmission.com>
References: <87va2716mh.fsf@xmission.com>
        <9151.1548852654@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9151.1548852654-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org> (David Howells's message
        of "Wed, 30 Jan 2019 12:50:54 +0000")
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> You need to rebase on linus/master.  A bunch of your patches are obsoleted by
> Al's security changes there.

Before anything is merged definitely.

Al dealt with mount options from the LSMs in a slightly different way
than I did.  At a practical level Als version of the changes to the LSMs
and mine are you say po-tae-toe I say po-tah-toe differences so I don't
see that influencing semantics up at the api level.

For purposes of disucssing an API (not of merging one) I chose to start
with code I had a reasonable amount of testing against, so that other
people could play with it without expecting trouble.

Eric
