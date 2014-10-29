From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Wed, 29 Oct 2014 15:27:29 -0700
Message-ID: <20141029222729.GB8129@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 29, 2014 at 03:15:51PM -0700, Andy Lutomirski wrote:
> (reply 1/2 -- I'm replying twice to keep the threading sane)
> 
> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > kdbus is a kernel-level IPC implementation that aims for resemblance to
> > the the protocol layer with the existing userspace D-Bus daemon while
> > enabling some features that couldn't be implemented before in userspace.
> >
> 
> >  * Support for multiple domains, completely separated from each other,
> >    allowing multiple virtualized instances to be used at the same time.
> 
> Given that there is no such thing as a device namespace, how does this work?

See the document for the details.

> The docs seem a bit confusing to me as to whether there's a hierarchy
> of domains.  Do domains have a concept of a parent?

Yes.

> What's "container-name"?

Is that used in the documentation?

> Given that domains have random IDs, how can they be checkpointed and restored?

Good question, I don't know about checkpoint/restore, but I think that
has been done.  Daniel would know more than I do about that.

thanks,

greg k-h
