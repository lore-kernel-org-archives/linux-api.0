From: Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>
Subject: Re: [PATCH 1/7] signal/alpha: Document a conflict with SI_USER for
	SIGTRAP
Date: Tue, 18 Jul 2017 08:22:52 -1000
Message-ID: <e0e3c779-b00b-dc86-60f5-12f54e8d5f3a@twiddle.net>
References: <87o9shg7t7.fsf_-_@xmission.com>
	<20170718140651.15973-1-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170718140651.15973-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ivan Kokshaysky <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Willy Tarreau <w@1wt.eu>, Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/18/2017 04:06 AM, Eric W. Biederman wrote:
> Setting si_code to __SI_FAULT results in a userspace seeing
> an si_code of 0.  This is the same si_code as SI_USER.  Posix
> and common sense requires that SI_USER not be a signal specific
> si_code.  As such this use of 0 for the si_code is a pretty
> horribly broken ABI.
> 
> Given that alpha is on it's last legs I don't know that it is worth
> fixing this, but it is worth documenting what is going on so that
> no one decides to copy this bad decision.
> 
> This was introduced during the 2.5 development cycle so this
> mess has had a long time for people to be able to depend upon it.
> 
> v2: Added FPE_FIXME for alpha as Helge Deller<deller-Mmb7MZpHnFY@public.gmane.org>  pointed out
>      with his alternate patch one of the cases is SIGFPE not SIGTRAP.
> 
> Cc: Helge Deller<deller-Mmb7MZpHnFY@public.gmane.org>
> Cc: Richard Henderson<rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>
> Cc: Ivan Kokshaysky<ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>
> Cc: Matt Turner<mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc:linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> History Tree:https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
> Ref: 0a635c7a84cf ("Fill in siginfo_t.")
> Signed-off-by: "Eric W. Biederman"<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> ---
>   arch/alpha/include/uapi/asm/siginfo.h | 14 ++++++++++++++
>   arch/alpha/kernel/traps.c             |  6 +++---
>   2 files changed, 17 insertions(+), 3 deletions(-)

Acked-by: Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>


r~
