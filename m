From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [CFT][PATCH 09/10] sysfs: Create mountpoints with
	sysfs_create_empty_dir
Date: Wed, 12 Aug 2015 17:05:10 -0400
Message-ID: <20150812210510.GD4496@mtj.duckdns.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<878ucrhxi9.fsf@x220.int.ebiederm.org>
	<20150811184426.GH23408@mtj.duckdns.org>
	<877fp1hcuj.fsf@x220.int.ebiederm.org>
	<CALCETrXE=fKa3XkEEo6y2=ZNtsuBfX=kaoyDwiP0C2BwqKJWjw@mail.gmail.com>
	<87mvxxcogp.fsf@x220.int.ebiederm.org>
	<20150812200035.GB4496@mtj.duckdns.org>
	<87r3n82qxd.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87r3n82qxd.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Wed, Aug 12, 2015 at 03:27:26PM -0500, Eric W. Biederman wrote:
> proc has always reported -ENOENT. sysfs is the odd one out.

Hmm... open(2) is clear about failure modes and ENOENT doesn't fit the
bill here.  Maintaining the behavior for proc for backward
compatibility is fine but I don't think it's appropriate to change
behaviors on other filesystems which were behaving correctly
especially through changes which got routed through -stable.

       ENOENT O_CREAT is not set and the named file does not exist.  Or, a directory component in pathname does not exist or is a dangling symbolic link.

       ENOENT pathname refers to a nonexistent directory, O_TMPFILE and one of O_WRONLY or O_RDWR were specified in flags, but this kernel version does not provide the O_TMPFILE
                     functionality.

> I am not completely certain that trivial patch above, does not introduce
> a leak, a NULL pointer dereference or something else nasty when the code
> is hit.
> 
> So far it seems that no one cares.  And since the change is brittle I am
> not inclined to mess with it this week, as I have other demands on my
> limited review bandwidth right now.

Sure, it isn't "today" urgent but let's please restore the original
behavior before the new behavior gets too widespread.

Thanks.

-- 
tejun
