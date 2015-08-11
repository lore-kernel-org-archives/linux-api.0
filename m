From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [CFT][PATCH 09/10] sysfs: Create mountpoints with
	sysfs_create_empty_dir
Date: Tue, 11 Aug 2015 16:11:55 -0400
Message-ID: <CAOS58YOHU8SFv4UXeBRr4t88UU=DXQCPg2HU_dMBmgM7WBB1zQ@mail.gmail.com>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<878ucrhxi9.fsf@x220.int.ebiederm.org>
	<20150811184426.GH23408@mtj.duckdns.org>
	<877fp1hcuj.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <877fp1hcuj.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
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
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, LINUXFS-ML <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hey,

On Tue, Aug 11, 2015 at 2:57 PM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> So, this somehow ends up confusing upstart on centos6 based systems
>> making it fail to mount tmpfs on /sys/fs/cgroup.  It also skips sunrpc
>> and other mounts are different too.  No idea why at this point.  Can
>> we please revert this from -stable until we know what's going on?
>
> *Boggle*
>
> The only time this should prevent anything is when in a container when
> you are not global root.  And then only mounting sysfs should be
> affected.

This is just plain boot. No namespace involved.

> The only difference in executed code really should be setting an extra
> flag on the kernfs, inode.  The kernfs changes will also refuse to add
> entries to these directories (but these directories are empty).

Why do we have this in -stable then? Is this part of a larger fix?

> If this is causing problems I don't have a problem with a revert but
> reverts take a minute, and this seems to be the first report of this
> kind.  Can we take a minute and attempt to get a coherent explanation.
>
> From what little information you given above it sounds like something
> shifted and when you rebuilt the kernel and now a memory stomp is
> hitting something else.  It should be a matter of moments to debug this

I don't think it's a random memory stomping thing. I reverted the
commit from two different kernels and the result was always
consistent.

> issue (once a test environment is setup), and see what is wrong and then
> we can act intelligently.  Tracing a single system call is not difficult.

I'm already out today so it'll have to wait till tomorrow.

> If there really is some weird issue I want to know what it is.

Sure, but you wanna do that in -stable?

Thanks.

-- 
tejun
