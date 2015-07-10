From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [REVIEW][PATCH 1/2] vfs: Commit to never having exectuables on
 proc and sysfs.
Date: Fri, 10 Jul 2015 12:30:52 -0700
Message-ID: <20150710193052.GB19824@kroah.com>
References: <87381eyz26.fsf@x220.int.ebiederm.org>
 <CA+55aFysKDXr2HEwNzm3z9QOw=E4ZeWcvYQ-xLhy5_k+rGbeRg@mail.gmail.com>
 <87pp4eqktr.fsf@x220.int.ebiederm.org>
 <CA+55aFw-DK-xDC-3HYa=BMX8WNyQgT9O01tihrAS9+-7PPj_jA@mail.gmail.com>
 <20150704231118.GT17109@ZenIV.linux.org.uk>
 <87mvz4yomp.fsf_-_@x220.int.ebiederm.org>
 <87h9pcyokc.fsf_-_@x220.int.ebiederm.org>
 <55A00DE9.7060806@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55A00DE9.7060806-/L3Ra7n9ekc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>, Ivan Delalande <colona-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 10, 2015 at 08:24:41PM +0200, Richard Weinberger wrote:
> Am 10.07.2015 um 18:17 schrieb Eric W. Biederman:
> > 
> > Today proc and sysfs do not contain any executable files.  Several
> > applications today mount proc or sysfs without noexec and nosuid and
> > then depend on there being no exectuables files on proc or sysfs.
> > Having any executable files show on proc or sysfs would cause
> > a user space visible regression, and most likely security problems.
> > 
> > Therefore commit to never allowing executables on proc and sysfs by
> > adding a new flag to mark them as filesystems without executables and
> > enforce that flag.
> > 
> > Test the flag where MNT_NOEXEC is tested today, so that the only user
> > visible effect will be that exectuables will be treated as if the
> > execute bit is cleared.
> > 
> > The filesystems proc and sysfs do not currently incoporate any
> > executable files so this does not result in any user visible effects.
> > 
> > This makes it unnecessary to vet changes to proc and sysfs tightly for
> > adding exectuable files or changes to chattr that would modify
> > existing files, as no matter what the individual file say they will
> > not be treated as exectuable files by the vfs.
> > 
> > Not having to vet changes to closely is important as without this we
> > are only one proc_create call (or another goof up in the
> > implementation of notify_change) from having problematic executables
> > on proc.  Those mistakes are all too easy to make and would create
> > a situation where there are security issues or the assumptions of
> > some program having to be broken (and cause userspace regressions).
> 
> Would it make sense to add SB_I_NOEXEC to more pseudo filesystems?
> Say pstore or devpts?

And configfs and cgroupfs?
