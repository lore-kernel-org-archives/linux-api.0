From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] TTY, devpts: document pty count limiting
Date: Thu, 22 Oct 2015 07:33:49 -0700
Message-ID: <20151022143349.GA21861@kroah.com>
References: <20151021100854.7888.90252.stgit@buzz>
 <20151021170423.GA29006@kroah.com>
 <87twpjczor.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87twpjczor.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Oct 21, 2015 at 11:08:52PM -0500, Eric W. Biederman wrote:
> Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> writes:
> 
> > On Wed, Oct 21, 2015 at 01:08:54PM +0300, Konstantin Khlebnikov wrote:
> >> Logic was changed in kernel 3.4 by commit e9aba5158a80 ("tty: rework pty
> >> count limiting") but still isn't documented. Better late than never.
> >> 
> >> Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
> >> ---
> >>  Documentation/filesystems/devpts.txt |    9 +++++++++
> >>  Documentation/sysctl/kernel.txt      |    7 +++++++
> >>  2 files changed, 16 insertions(+)
> >
> > Any reason you didn't cc: the tty maintainer on this?
> 
> It looks like he attempted to and managed to get your old suse.de
> address.

Ah, you are right, my apologies, that address is long dead :)

greg k-h
