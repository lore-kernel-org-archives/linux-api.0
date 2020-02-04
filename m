From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH ghak90 V8 13/16] audit: track container nesting
Date: Tue, 4 Feb 2020 10:52:36 -0500
Message-ID: <CAHC9VhRHfjuv5yyn+nQ2LbHtcezBcjKtOQ69ssYrXOiExuCjBw@mail.gmail.com>
References: <cover.1577736799.git.rgb@redhat.com> <5238532.OiMyN8JqPO@x2>
 <20200204131944.esnzcqvnecfnqgbi@madcap2.tricolour.ca> <3665686.i1MIc9PeWa@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3665686.i1MIc9PeWa@x2>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-Audit Mailing List <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, omosnace-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Dan Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mpatel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 4, 2020 at 10:47 AM Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tuesday, February 4, 2020 8:19:44 AM EST Richard Guy Briggs wrote:
> > > The established pattern is that we print -1 when its unset and "?" when
> > > its totalling missing. So, how could this be invalid? It should be set
> > > or not. That is unless its totally missing just like when we do not run
> > > with selinux enabled and a context just doesn't exist.
> >
> > Ok, so in this case it is clearly unset, so should be -1, which will be a
> > 20-digit number when represented as an unsigned long long int.
> >
> > Thank you for that clarification Steve.
>
> It is literally a  -1.  ( 2 characters)

Well, not as Richard has currently written the code, it is a "%llu".
This was why I asked the question I did; if we want the "-1" here we
probably want to special case that as I don't think we want to display
audit container IDs as signed numbers in general.

-- 
paul moore
www.paul-moore.com
