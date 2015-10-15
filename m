From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH v4 45/79] linux/if.h linux/hdlc/ioctl.h: move IFNAMSIZ
 definition to hdlc/ioctl.h
Date: Thu, 15 Oct 2015 21:08:50 +0300
Message-ID: <20151015180850.GC6104@lakka.kapsi.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-46-git-send-email-mikko.rapeli@iki.fi>
 <CAH6sp9Pc48Qfux9K68rCRvfBUhEpxqM9k43Nn2vCpKh4Ewa+QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH6sp9Pc48Qfux9K68rCRvfBUhEpxqM9k43Nn2vCpKh4Ewa+QQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frans Klaver <fransklaver-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 10:49:17AM +0200, Frans Klaver wrote:
> Hi,
> 
> On Thu, Oct 15, 2015 at 7:56 AM, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
> > And include linux/hdlc/ioctl.h from linux/if.h.
> 
> That appears to have already been the case before this patch. You just
> add a comment behind the include statement.

True, fixed in a new version.

-Mikko
