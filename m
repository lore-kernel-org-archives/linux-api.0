From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [GIT PULL] User namespace related fixes for v4.2
Date: Sun, 5 Jul 2015 00:11:18 +0100
Message-ID: <20150704231118.GT17109@ZenIV.linux.org.uk>
References: <87381eyz26.fsf@x220.int.ebiederm.org>
	<CA+55aFysKDXr2HEwNzm3z9QOw=E4ZeWcvYQ-xLhy5_k+rGbeRg@mail.gmail.com>
	<87pp4eqktr.fsf@x220.int.ebiederm.org>
	<CA+55aFw-DK-xDC-3HYa=BMX8WNyQgT9O01tihrAS9+-7PPj_jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFw-DK-xDC-3HYa=BMX8WNyQgT9O01tihrAS9+-7PPj_jA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, "<linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ivan Delalande <colona-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 03, 2015 at 03:10:40PM -0700, Linus Torvalds wrote:
> On Mon, Jun 29, 2015 at 2:13 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> >
> > Can you live with the patch below and committing to never supporting
> > executables on proc and sysfs?
> 
> Sure. I don't think executables make any sense what-so-ever in those
> filesystems. I think it's fine saying that /proc and /sys cannot have
> executables in them, and then use that flag to just ignore the
> relevant mount flags.
> 
> Al, comments?

	I can live with that, but I would prefer that to be a superblock
flag force-set in ->mount() (and preserved in ->remount_fs()) rather than
Yet Another FS Type Flag.  OTOH, it's not hard to change afterwards.

	Al, bloody annoyed by having spent hours debugging an odd corruption
in merge candidate, only to find that it correlated to temperature of the
host ;-/  Seem to be all gone after replacing CPU fan and cleaning the
mess under it...
