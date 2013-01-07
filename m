From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 4/4] setns.2: Document the pid, user, and mount namespace support.
Date: Mon, 07 Jan 2013 15:58:46 -0800
Message-ID: <8738yc5yvd.fsf@xmission.com>
References: <87a9u4rmz0.fsf@xmission.com> <87k3t7q39u.fsf@xmission.com>
	<CAKgNAkiaw5L_oNE8NENjmoBS8Hq_uj+iaEdhyXc1+hje4HdnNQ@mail.gmail.com>
	<87bodftmv0.fsf@xmission.com>
	<CAKgNAkjJR02rKOBh98n7HJwXqAwywHY=Ef35t9tW7wOuyo86NQ@mail.gmail.com>
	<87mwwt2pj8.fsf@xmission.com>
	<CAKgNAkggEOV0dXVzr4Zf3n_-it5SXfvjJ1ooYxiVNWaYzQgRLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkggEOV0dXVzr4Zf3n_-it5SXfvjJ1ooYxiVNWaYzQgRLg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Michael Kerrisk's message of "Mon, 7 Jan 2013 10:51:04 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Okay. See below.
>
> So, let's take one more pass. How does the following look:
>
>        A multi-threaded process may not  change  user  namespace  with
>        setns().   It  is  not  permitted to use setns() to reenter the
>        caller's current user namespace.  This prevents a  caller  that
>        has  dropped capabilities from regaining those capabilities via
>        a call to setns() A process reassociating itself  with  a  user
>        namespace must have CAP_SYS_ADMIN privileges in the target user
>        namespace.
>
>        A process may not be reassociated with a new mount namespace if
>        it  is  multi-threaded.   Changing the mount namespace requires
>        that the caller possess both CAP_SYS_CHROOT  and  CAP_SYS_ADMIN
>        capabilities in its own user namespace and CAP_SYS_ADMIN in the
>        target mount namespace.

That wording looks correct.

Eric
